//
//  DetailsViewController.swift
//  mapana
//
//  Created by Naman Sheth on 25/07/23.
//

import UIKit
import WebKit
import SDWebImage
import MobileCoreServices
import DropDown
class DetailsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var tblCommentView: UITableView!
    @IBOutlet weak var txtWriteComment: UITextField!
    @IBOutlet weak var caroselCollectionView: UICollectionView!
    @IBOutlet weak var lblLocationReferenceID: UILabel!
    var userID = UserDefaults.standard.value(forKey: "userId")
    var detailsModel: DetailsViewModel?
    var detailObj: BoroughLocation?
    var imageModel = [SurveyImageElement]()
    var commentsModel =  [SurveyComment]()
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        txtWriteComment.delegate = self
        detailsModel = DetailsViewModel()
        if let objID = detailObj?.first?.id {
            detailsModel?.fetchAllComments(userID: String(describing: "\(objID)"))
        }
        detailsModel?.fetchAllImages(userID: String(describing: userID!))
        
        
        detailsModel?.onSucessHandlingOfSurveyImages = { [weak self] model in
            guard let self = self else { return }
            print(model.count)
            
            self.imageModel.append(contentsOf: model)
            self.imageModel.append(contentsOf: model)
            self.imageModel.append(contentsOf: model)
            self.imageModel.append(contentsOf: model)
            DispatchQueue.main.async {
                self.caroselCollectionView.reloadData()
            }
        }
        
        detailsModel?.onSucessHandlingOfSurveyComments = { [weak self] model in
            guard let self = self else { return }
            print(model.count)
            self.commentsModel = model
            DispatchQueue.main.async {
                self.tblCommentView.reloadData()
            }
            
        }
        
        detailsModel?.onErrorHandlingOfSurveyImages = { error in
            
        }
        
        detailsModel?.onErrorHandlingOfSurveyComments = { error in
            
        }
       
        segmentView.setImage(UIImage(named: "gallery"), forSegmentAt: 0)
        segmentView.setImage(UIImage(named:"drawing"), forSegmentAt: 1)
        segmentView.setImage(UIImage(named: "loc_tab"), forSegmentAt: 2)
        segmentView.setTitle("Gallery", forSegmentAt: 0)
        segmentView.setTitle("Drawing", forSegmentAt: 1)
        segmentView.setTitle("Location", forSegmentAt: 2)
    }
    
    @IBAction func btnCameraClicked(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Photos", "Camera"]
        dropDown.anchorView = btnCamera
        // Action triggered on selection
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if index == 0 {
                self.openPhotos()
            } else {
                self.openCamera()
            }
        }
        
        dropDown.show()
    }

}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        guard let mediaURL = imageModel[indexPath.row].mediaUrl else { return  cell }
//        cell.imageViewCollection.sd_imageTransition = .fade
//        cell.imageViewCollection.sd_setImage(with: URL(string: mediaURL), completed: nil)
        SDWebImageManager.shared.loadImage(
                with: URL(string: mediaURL),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                  print(isFinished)
                    cell.imageViewCollection.image = image
                }
        return cell
        
    }
    
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.lblUserName.text = commentsModel[indexPath.row].fullName
        cell.lblTime.text = ""
        cell.lblComment.text = commentsModel[indexPath.row].text
       // cell.userImageView.sd_setImage(with: URL(string: commentsModel[indexPath.row].avatarURL ?? ""))
               
        SDWebImageManager.shared.loadImage(
                with: URL(string: commentsModel[indexPath.row].avatarUrl ?? ""),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                  print(isFinished)
                    cell.userImageView.image = image
                }
        return cell
    }

    
}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openPhotos()  {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button photo")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.cameraDevice = .rear
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let lat = detailObj?.first?.lat, let lng = detailObj?.first?.lng else { return }
           let pos = ["lat" : lat, "lng" : lng]
            detailsModel?.uploadUserLocationImage(image: image, pos: pos, userId: "\(userID!)")
            getImageResponse()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getImageResponse() {
        
        detailsModel?.onSucessHandlingOfAddingImage = { [weak self] model in
            guard let self = self else { return }
            self.detailsModel?.fetchAllImages(userID: String(describing: self.userID!))
        }
        
        detailsModel?.onSucessHandlingOfSurveyImages = { [weak self] model in
//            guard let self = self else { return }
        }
        
       
    }
    
    func fetchCommentResponse() {
        detailsModel?.onErrorHandlingOfAddingComment = { error in
            if let objID = self.detailObj?.first?.id {
                self.detailsModel?.fetchAllComments(userID: String(describing: "\(objID)"))
            }
        }
    }
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //textField code

        txtWriteComment.resignFirstResponder()
        guard let id = detailObj?.first?.id else { return false }
        detailsModel?.addComment(userId: "\(userID!)", siginId: "\(id)", comment: txtWriteComment.text ?? "")
        txtWriteComment.text = ""
        fetchCommentResponse()
        return true
    }
}
