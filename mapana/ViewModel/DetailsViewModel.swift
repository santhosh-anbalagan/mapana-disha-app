//
//  DetailsViewModel.swift
//  mapana
//
//  Created by Naman Sheth on 25/07/23.
//

import Foundation
import UIKit



class DetailsViewModel: NSObject {
    
    var onErrorHandlingOfSurveyImages : ((RequestError) -> Void)?
    var onSucessHandlingOfSurveyImages : ((SurveyImage) -> Void)?
    
    var onErrorHandlingOfSurveyComments : ((RequestError) -> Void)?
    var onSucessHandlingOfSurveyComments : ((SurveyComments) -> Void)?
    
    var onErrorHandlingOfAddingComment : ((RequestError) -> Void)?
    var onSucessHandlingOfUploadImage: ((SurveyComments) -> Void)?
    
    
    var onErrorHandlingOfAddingImage: ((RequestError) -> Void)?
    var onSucessHandlingOfAddingImage: ((SurveyComments) -> Void)?
    
    func fetchAllImages(userID: String)  {
        ApiRequest.getAllSurveyImages(userId: userID, completion: { [weak self]  (result: Result<SurveyImage, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandlingOfSurveyImages?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandlingOfSurveyImages?(error)
                break
            }
        })
    }
    
    func fetchAllComments(userID: String)  {
        ApiRequest.getAllSurveyComments(userId: userID, completion: { [weak self]  (result: Result<SurveyComments, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandlingOfSurveyComments?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandlingOfSurveyComments?(error)
                break
            }
        })
    }
    
    func uploadUserLocationImage(image: UIImage, pos: [String : String], userId: String) {
        ApiRequest.uploadImage(file: image, userId: userId, pos: pos, completion: { [weak self]  (result: Result<SurveyComments, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandlingOfUploadImage?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandlingOfSurveyImages?(error)
                break
            }
        })
    }
    
    func addComment(userId: String, siginId: String, comment: String)  {
        ApiRequest.addAComment(userID: userId, signId: siginId, comment: comment, completion: { [weak self]  (result: Result<SurveyComments, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandlingOfAddingComment?(error)
                break
            }
        })
    }
}


