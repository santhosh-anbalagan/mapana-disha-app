//
//  NewRouteViewController.swift
//  mapana
//
//  Created by iOS Developer on 29/07/23.
//

import UIKit
import NbmapNavigation
import NbmapCoreNavigation
import NbmapDirections
import Nbmap
import DropDown
import Lottie

class NewRouteViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var progressView: AnimationView!
    @IBOutlet weak var progressStackView: UIStackView!
    
    var lotView = AnimationView()
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTotalJobs: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
    
    var boroughDataModel: BoroughAll = []
    var boroughRouteLocationModel: BoroughRoute?
    var arrLocations: [CLLocation] = []
    var routeModel: RouteModel?
    var menuDropDown = DropDown()
    var userID = UserDefaults.standard.value(forKey: "userId")
    
    //MARK: - Variables
    var mapView: NavigationMapView?  {
        didSet {
            oldValue?.removeFromSuperview()
            if let mapView = mapView {
                viewMap.insertSubview(mapView, at: 0)
            }
        }
    }
    
    let locationManager = NavigationLocationManager()
    
    var routes: [Route]? {
        didSet {
            guard routes != nil else{
                btnStart.isEnabled = false
                return
            }
            btnStart.isEnabled = true
            stopAnimation()
            
            guard let routes = routes,
                  let current = routes.first else { mapView?.removeRoutes(); return }
            
            mapView?.showRoutes(routes)
            mapView?.showWaypoints(current) //point - 1, 2, 3...
            mapView?.showRouteDurationSymbol(routes) //
            
            guard let newCamera = mapView?.camera else {
                return
            }
            
            newCamera.centerCoordinate = arrLocations[arrLocations.count/2].coordinate
            newCamera.viewingDistance = 5000
            mapView?.setCamera(newCamera, animated: true)
        }
    }
    
    var navigationViewController: NavigationViewController?
    
    var timer: Timer?
    var counter = 0
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: - Methods
    private func setupUI() {
        stopTimer()
        setupSideMenu()
        setupDropDown()
        setupMapView()
    }
    
    private func setupSideMenu() {
        let buttonRight = UIButton(type: .custom)
        //set image for button
        buttonRight.setImage(UIImage(named: "sideLogo"), for: .normal)
        //set frame
        buttonRight.frame = CGRectMake(0, 0, 200, 50)
        
        let barButton = UIBarButtonItem(customView: buttonRight)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        // Menu Button Tint Color
        // navigationController?.navigationBar.tintColor = .black
        // navigationController?.navigationBar.isTranslucent = false
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
    }
    
    private func setupDropDown(){
        routeModel = RouteModel()
        menuDropDown.anchorView = btnDropDown
        routeModel?.fetchAllBorough(userId: String(describing: userID!))
        
        self.routeModel?.onErrorHandling = { error in
            print(error)
            self.stopAnimation()
        }
        
        self.routeModel?.onSucessHandlingBoroughAll = { model in
            print("BOROUGH \(model)")
            self.boroughDataModel = model
            var idArray = ["Select Borough"]
            let nameArray = model.map({ (boroughElement: BoroughAllElement) -> String in
                boroughElement.name ?? ""
            })
            idArray.append(contentsOf: nameArray)
            self.menuDropDown.dataSource = idArray
            DispatchQueue.main.async {
                self.btnDropDown.setTitle("Select Borough", for: .normal)
            }
        }
        
        // Action triggered on selection
        self.menuDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if let obj = boroughDataModel.firstIndex(where: { $0.id == (index)}), let objID = boroughDataModel[obj].id,
               let objName = boroughDataModel[obj].name {
                playAnimation()
                print("FETCHING ROUTES:: \(objID)==>\(String(describing:userID!))")
                routeModel?.fetchBoroughRouteById(userSelectedBoroughID: "\(objID)", userId: String(describing: userID!))
                DispatchQueue.main.async {
                    self.btnDropDown.setTitle(objName, for: .normal)
                }
            }
        }
        
        self.routeModel?.onSucessBoroughRouteHandling = { [weak self] model in
            print(model)
            guard let self = self else { return }
            self.boroughRouteLocationModel = model
            DispatchQueue.main.async {
                self.arrLocations = []
            }
            guard let locations = self.boroughRouteLocationModel?.locations.location else { return }

            for loc in locations {
                let latLongs=loc.split(separator: ",")
                self.arrLocations.append(CLLocation(latitude: Double(latLongs[0]) ?? 0.0, longitude: Double(latLongs[1]) ?? 0.0))
            }
            
            DispatchQueue.main.async {
                self.stopAnimation()
                self.requestRoutes()
                self.showAnnotations()
            }
        }
    }
    
    private func setupApiValuesForJobs(){
        let route = routes?.first
//        lblDistance.text =
        lblTotalJobs.text = "\(arrLocations.count) pitstops"
        lblTotalDistance.text = "\(((route?.distance ?? 0)/1000).rounded())km Total"
            
        lblTotalDuration.text = String(describing: stringFromTimeInterval(interval: route?.expectedTravelTime ?? 0.0))
    }
    
    //MARK: - Timer
    func startTimer() {
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCounter), userInfo: nil, repeats: true)
    }
    
    @objc func startCounter() {
        counter += 1
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func onReportSubmittedButtonClicked() {
        let alertVC = UIAlertController(title: "Alert", message: "Reported Successfully", preferredStyle: .alert)
        let reportAction = UIAlertAction(title: "OK", style: .default)
        
        alertVC.addAction(reportAction)
        self.navigationViewController?.present(alertVC, animated: true)
    }
    
    //MARK: - API
    func callReportAPI() {
        routeModel?.makeRequestForReportApi(userID: String(describing: userID!), signId: String(describing: boroughDataModel.first!.id!), status: "ISSUE", timestamp: String(describing: NSDate().description.localizedLowercase), timerSec: "\(counter)", lat: "\(arrLocations.first!.coordinate.latitude)", long: "\(arrLocations.first!.coordinate.longitude)")
        
        routeModel?.onErrorHandling = { error in
            print(error)
        }
        
        routeModel?.onSucessHandling = { _ in
            self.onReportSubmittedButtonClicked()
        }
    }
    
    func callCrossPointAPI() {
        routeModel?.makeRequestForCrossPointApi(userID: String(describing: userID!), signId: String(describing: boroughDataModel.first!.id!), status: "CROSS", timestamp: "\(counter)", timerSec: String(describing: NSDate().description.localizedLowercase))
    }
    
    //MARK: - SetupMap
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {

      let ti = NSInteger(interval)

      let ms = Int((interval).truncatingRemainder(dividingBy: 1) * 1000)

      let seconds = ti % 60
      let minutes = (ti / 60) % 60
//      let hours = (ti / 3600)

//      return NSString(format: "%0.2d:%0.2d:%0.2d min",hours,minutes,seconds,ms)
      return NSString(format: "%0.2d:%0.2d min",minutes,seconds,ms)
    }
    
    //Setup Map View
    private func setupMapView() {
        self.mapView = NavigationMapView(frame: viewMap.bounds)
        //configure for mapView based on your needs
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView?.userTrackingMode = .followWithHeading
        mapView?.logoView.isHidden = true
        mapView?.compassView.isHidden = false
        mapView?.showsUserLocation = true
        
        //Assign Your ViewController as the delegate of navigationMapView
        mapView?.navigationMapDelegate = self
        self.viewMap.insertSubview(mapView!, at: 0)
        
        self.viewMap.setNeedsLayout()
    }
    
    //Show multiple markers / Annotations
    private func requestRoutes() {
        let options = NavigationRouteOptions(locations: arrLocations)
        options.distanceMeasurementSystem = MeasurementSystem.metric
        
        Directions.shared.calculate(options) { [weak self] routes, error in
            guard let weakSelf = self else {
                return
            }
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let routes = routes else { return }
            weakSelf.routes = routes
            DispatchQueue.main.async {
                self?.setupApiValuesForJobs()
            }
        }
    }
    
    @IBAction func btnDropDownClicked(_ sender: UIButton) {
        self.menuDropDown.show()
    }
    
    private func showAnnotations() {
        for item in arrLocations {
            let coordinates = CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude)
            
            let annotation = NGLPointAnnotation()
            annotation.coordinate = coordinates
            mapView?.addAnnotation(annotation)
            mapView?.compassView.compassVisibility = NGLOrnamentVisibility.visible
        }
    }
    
    private func navigationMap() {
        let options = NavigationRouteOptions(locations: arrLocations)
        options.distanceMeasurementSystem = MeasurementSystem.metric
        
        Directions.shared.calculate(options) { [weak self] routes, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let routes = routes else { return }
            
            /**
             Initialize the `NBNavigationService`  with fetched routes , and set the default index to 0 . If `simulationIsEnabled` is `true`  , Set the navigation to simulation mode, otherwise only use simulation navigation mode in tunnels.
             */
            let navigationService = NBNavigationService(routes: routes, routeIndex: 0, simulating: SimulationMode.inTunnels)
            
            let navigationOptions = NavigationOptions(navigationService: navigationService)
            
            navigationOptions.navigationMapView?.compassView.isHidden = false
            navigationOptions.navigationMapView?.compassView.compassVisibility = NGLOrnamentVisibility.visible
            
            // Initialize the NavigationViewController
            let navigationViewController = NavigationViewController(for: routes, navigationOptions: navigationOptions)
            
            // Set the delegate of navigationViewController to subscribe for NavigationView’s events, This is optional
            navigationViewController.modalPresentationStyle = .fullScreen
            
            navigationViewController.showsEndOfRouteFeedback = true
            
            navigationViewController.navigationMapView?.compassView.isHidden = false
            navigationViewController.navigationMapView?.compassView.compassVisibility = NGLOrnamentVisibility.visible
            
            // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
            navigationViewController.routeLineTracksTraversal = true
            navigationViewController.navigationView.navigationMapView.compassView.compassVisibility = NGLOrnamentVisibility.visible
            
            navigationViewController.delegate = self as? NavigationViewControllerDelegate
            
            self?.navigationViewController = navigationViewController
            
            //Add Report Button
            let reportButton = UIButton()
            reportButton.backgroundColor = .red
            reportButton.frame = CGRect(x: 0, y: 150, width: 100, height: 50)
//            reportButton.setImage(UIImage(systemName: "list.clipboard.fill"), for: .normal)
            reportButton.setTitle("Report", for: .normal)
            reportButton.tintColor = .white
            
            reportButton.addTarget(self, action: #selector(self?.onReportAPIButtonClicked(_:)), for: .touchUpInside)
            navigationViewController.navigationView.floatingButtons = [reportButton]
            
            // Start navigation
            strongSelf.present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func onBtnStartNavigationClicked(_ sender: UIButton) {
        if arrLocations.count == 0 {
            return
        }
        
        startTimer()
        
        routeModel?.makeRequestForNavigationUpdateApi(userID: String(describing: userID!), signId: String(describing: boroughDataModel.first!.id!), isStart: true, timestamp: String(describing: NSDate().description.localizedLowercase) , timerSec: "0", lat: String(describing: arrLocations.first!.coordinate.latitude), long: String(describing: arrLocations.first!.coordinate.longitude), derivedDistance: "", derivedTime: "")
        navigationMap()
    }
    
    @objc func onReportAPIButtonClicked(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Alert", message: "Please click on the button below to report", preferredStyle: .alert)
        let reportAction = UIAlertAction(title: "Report", style: .cancel) { _ in
            print("Report")
            
            //Call API
            self.callReportAPI()
        }
        
        alertVC.addAction(reportAction)
        self.navigationViewController?.present(alertVC, animated: true)
    }
    
    func playAnimation() {
        backgroundImageView.isHidden = false
        progressView.isHidden = false
        progressStackView.isHidden = false
        lotView = AnimationView(name: "optimizing") //LottieAnimationView(name: "optimizing")
        lotView.frame = self.progressView.frame
        self.progressView.addSubview(lotView)
        progressView.contentMode = .scaleAspectFit
        lotView.animationSpeed = 1
        lotView.loopMode = .loop
        lotView.play()
    }
    
    func stopAnimation()  {
        self.backgroundImageView.isHidden = true
        self.progressView.isHidden = true
        self.progressStackView.isHidden = true
        self.lotView.stop()
    }
}

//MARK: - NavigationMapViewDelegate
extension NewRouteViewController : NavigationMapViewDelegate {
    func mapView(_ mapView: NGLMapView, imageFor annotation: NGLAnnotation) -> NGLAnnotationImage? {
        // Create a custom image for the destination icon
        let image = UIImage(named: "ic_destination", in: .main, compatibleWith: nil)!.withRenderingMode(.alwaysOriginal)
        return NGLAnnotationImage(image: image, reuseIdentifier: "destination_icon_identifier")
    }
    
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
        let isFinalLeg = navigationViewController.navigationService.routeProgress.isFinalLeg
        if isFinalLeg {
            return true
        }
        
        //API CrossPoint
        //self.callCrossPointAPI
        self.stopTimer()
        
        let alert = UIAlertController(title: "Arrived at", message: "Would you like to continue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            // Begin the next leg once the driver confirms
            guard !isFinalLeg else { return }
            navigationViewController.navigationService.router.routeProgress.legIndex += 1
            navigationViewController.navigationService.start()
        }))
        navigationViewController.present(alert, animated: true, completion: nil)
        
        return false
    }
}

extension NewRouteViewController: NGLMapViewDelegate {
    func exitNavigation(byCanceling canceled: Bool = false) {
        print("Exit map")
    }
}
