//
//  RouteViewController.swift
//  mapana
//
//  Created by Naman Sheth on 19/07/23.
//

import UIKit
import MapKit
import DropDown
import CoreLocation
import SDWebImage
import Polyline
import Lottie
//import FLEX
struct Waypoint {
    let latitude: Double
    let longitude: Double
}
class RouteViewController: UIViewController {
    
    @IBOutlet weak var backGroundImgView: UIImageView!
    @IBOutlet weak var progressView: LottieAnimationView!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPitsDistance: UILabel!
    @IBOutlet weak var lblPitsTime: UILabel!
    @IBOutlet weak var lblTotalPits: UILabel!
    @IBOutlet weak var lblTotalDistance: UILabel!
    
    var ETA = 0
    var totalDistance = 0
    var filteredObj = [MKPointAnnotation]()
    var finalFilteredObj = [MKPointAnnotation]()
    var routeMatrixModel: [RouteMatrix] = []
    var farestObj: RouteMatrixElement?
    var boroughDataModel: BoroughAll = []
    var boroughLocationModel: BoroughLocation = []
    var menuDropDown = DropDown()
    var routeModel: RouteModel?
    var locationManager: CLLocationManager?
    var latitude: Double?
    var longitude: Double?
    var locations: [MKPointAnnotation] = []
    var farestDropedObj: MKPointAnnotation?
    var lotView = LottieAnimationView()
    var i = 0
    var d = 2000
    var isRouteMatrixCompleted = false
    private var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        

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
        
        routeModel = RouteModel()
        menuDropDown.anchorView = btnDropDown
        routeModel?.fetchAllBorough()
        
        self.routeModel?.onErrorHandling = { error in
            
            print(error)
            
        }
        
        self.routeModel?.onSucessHandling = { [weak self] model in
            print(model)
            guard let self = self else { return }
            self.boroughLocationModel = model
            
            var waypoints : [(Double, Double)] = []
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.removeOverlays(self.mapView.overlays)
                self.locations = []
            }
            
            for obj in self.boroughLocationModel {
                
                if let lat = obj.lat, let lng = obj.lng, let objID = obj.referenceId {
                    
                    let douLat = Double(lat)!
                    let douLng = Double(lng)!
                    waypoints.append((douLat, douLng))
                    
                    let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
                    
                    let dropPin = CustomPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = "\(objID)"
                    dropPin.imageName = obj.icon ?? "loc_tab"
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.mapView.addAnnotation(dropPin)
                        self.mapView.selectAnnotation(dropPin, animated: true)
                        
                        self.locations.append(dropPin)
                        self.mapView.showAnnotations(self.locations, animated: true)
                        let region = MKCoordinateRegion(center: dropPin.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            }
        }
        
        self.routeModel?.onSucessHandlingBoroughAll = { model in
            print(model)
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
                routeModel?.getBoroughByBoroughID(userSelectedBoroughID: "\(objID)")
                DispatchQueue.main.async {
                    self.btnDropDown.setTitle(objName, for: .normal)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationManager.shared.requestLocationAuthorization()
        //FLEXManager.shared.showExplorer()
      //  print(LocationManager.shared.longitude ?? 0.0)
      //  print(LocationManager.shared.latitude ?? 0.0)
    }
    
    @IBAction func btnDropDownClicked(_ sender: UIButton) {
        self.menuDropDown.show()
    }
    
    @IBAction func btnStartnavigation(_ sender: UIButton) {
       // openGoogleMap()
      
        var waypointsParam = [Waypoint]()
        for obj in finalFilteredObj {
            if obj.coordinate.latitude != farestDropedObj?.coordinate.latitude {
                waypointsParam.append(Waypoint(latitude: obj.coordinate.latitude, longitude: obj.coordinate.longitude))
            }
        }
//        var waypointsParam = [(Double, Double)]()
//       for obj in finalFilteredObj {
//           if obj.coordinate.latitude != farestDropedObj?.coordinate.latitude {
//               waypointsParam.append((obj.coordinate.latitude,obj.coordinate.longitude))
//           }
//       }
//    let otherWaypoints = waypointsParam.dropFirst().map { "\($0.0),\($0.1)" }.joined(separator: "|")
//
        openGoogleMapsWithWaypoints(waypoints: waypointsParam)
    }
    
    func openGoogleMapsWithWaypoints(waypoints: [Waypoint]) {

        // Compose the URL scheme for Google Maps
        let baseURL = "comgooglemaps-x-callback://"

        // Add the origin (current location) to the URL
        var urlString = "&saddr=\(String(describing: latitude!)),\(String(describing: longitude!))&waypoints="

        // Add all the waypoints (stopovers) to the URL
        for waypoint in waypoints {
            urlString += "\(waypoint.latitude),\(waypoint.longitude)"
        }

        // Add the destination as the last waypoint in the URL
        urlString += "&daddr=\(String(describing: farestDropedObj!.coordinate.latitude)),\(String(describing: farestDropedObj!.coordinate.longitude))"

        //let encodedUrl = (baseURL + urlString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // Open Google Maps if it's installed, otherwise open in the browser
        if let url = URL(string: baseURL + urlString), UIApplication.shared.canOpenURL(url) {
            print(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Provide fallback action if Google Maps is not installed on the device
            // For example, open Google Maps in the browser using Google Maps web URL
            let googleMapsWebURL = "https://www.google.com/maps/dir/?api=1" + urlString
            let encodedUrl = googleMapsWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: encodedUrl!) {
                print(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openGoogleMap() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
        
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(farestDropedObj!.coordinate.latitude),\(farestDropedObj!.coordinate.longitude)&directionsmode=driving") {
            UIApplication.shared.open(url, options: [:])
        }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=(farestDropedObj!.coordinate.latitude),\(farestDropedObj!.coordinate.longitude)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
    
    func playAnimation() {
      backGroundImgView.isHidden = false
      progressView.isHidden = false
    progressStackView.isHidden = false
      lotView = LottieAnimationView(name: "optimizing")
      lotView.frame = self.progressView.frame
      self.progressView.addSubview(lotView)
        progressView.contentMode = .scaleAspectFit
      lotView.animationSpeed = 1
      lotView.loopMode = .loop
      lotView.play()
     }
    
    func stopAnimation()  {
        self.backGroundImgView.isHidden = true
        self.progressView.isHidden = true
        self.progressStackView.isHidden = true
        self.lotView.stop()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension RouteViewController : CLLocationManagerDelegate  {
    
    private func requestLocationUpdate() {
        locationManager?.startUpdatingLocation()
    }
    
    private func stopLocationUpdate() {
        locationManager?.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .restricted: break
        case .denied:
            NSLog("do some error handling")
            break
        default:
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        updateLocationOnMap(to: location, with: "User Current Location")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func updateLocationOnMap(to location: CLLocation, with title: String?) {
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
      
        self.mapView.addAnnotation(point)
        
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
//        self.mapView.setRegion(region, animated: true)
    }
    
    
}

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"

        if !(annotation is CustomPointAnnotation) {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "user_loc")
            //userPinView = pin
            return pin
        }
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let ivImage = UIImageView()
            if let customAnnotationView = annotation as? CustomPointAnnotation, let ivImageUrl = customAnnotationView.imageName {
                ivImage.sd_setImage(with: URL(string: ivImageUrl), placeholderImage: UIImage(named: "loc_tab"))
                annotationView?.image = ivImage.image
            } else{
                annotationView?.image = UIImage(named: "loc_tab")
            }
            annotationView?.canShowCallout = true

            // if you want a disclosure button, you'd might do something like:
            //
            // let detailButton = UIButton(type: .detailDisclosure)
            // annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemRed.withAlphaComponent(0.9)
            renderer.lineWidth = 7
            return renderer
        }

        return MKOverlayRenderer()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered, !self.boroughLocationModel.isEmpty {
            getPinsUnderLocations(distanceFrom: i, distanceTo: d)
            if isRouteMatrixCompleted, farestObj != nil {
                navigationView.isHidden = false
            } 
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation is CustomPointAnnotation else { return }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(RouteViewController.calloutTapped(sender:)))
            view.addGestureRecognizer(gesture)
    }
    
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        guard let view = sender.view as? MKAnnotationView, let title = view.annotation?.title else { return }
        print(title!)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        detailVC.detailObj = self.boroughLocationModel.filter { $0.referenceId == title! }
        let nav = UINavigationController(rootViewController: detailVC)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.preferredCornerRadius = 50
        }
        present(nav, animated: true, completion: nil)
    }
}

extension RouteViewController {
  
    func getPinsUnderLocations(distanceFrom: Int, distanceTo: Int) {
        print("distanceFrom", distanceFrom, "distanceTo", distanceTo)
       
        if let latitude = latitude, let longitude = longitude {
            let currentLocation = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
            let filter = locations.filter { Int($0.coordinate.distance(to: currentLocation)) >= distanceFrom && Int($0.coordinate.distance(to: currentLocation)) <= distanceTo }
            filteredObj.append(contentsOf: filter)
            finalFilteredObj.append(contentsOf: filter)
            if filter.count == 0, distanceFrom < 100000 {
                i = i + 5000
                d = d + 5000
                getPinsUnderLocations(distanceFrom: i, distanceTo: d)
            } else if !isRouteMatrixCompleted, distanceFrom < 100000 {
                i = i + 2000
                d = d + 2000
                
                var destinations: [NSMutableDictionary] = []
                for obj in filter {
                    // Create the first destination dictionary
                    let destination: NSMutableDictionary = [
                        "waypoint": [
                            "location": [
                                "latLng": [
                                    "latitude": obj.coordinate.latitude,
                                    "longitude": obj.coordinate.longitude
                                ]
                            ]
                        ]
                    ]
                    destinations.append(destination)
                }
                if destinations.count == 0 {
                    isRouteMatrixCompleted = true
                    self.callComputeRoutes()
                    stopAnimation()
                    return
                }
                let dynamicDictionary: NSMutableDictionary = [
                    "origins": [
                        [
                            "waypoint": [
                                "location": [
                                    "latLng": [
                                        "latitude": latitude,
                                        "longitude": longitude
                                    ]
                                ]
                            ] as [String : Any],
                            "routeModifiers": ["avoid_ferries": true]
                        ]
                    ],
                    "destinations": destinations, // Add the dynamic destinations array here
                    "travelMode": "DRIVE",
                    "routingPreference": "TRAFFIC_AWARE"
                ]
                
                // Printing the dynamic dictionary
                print(dynamicDictionary)
                
                routeModel?.makeRequestForRouteMatrixApi(parameters: dynamicDictionary)
                
            } else if distanceFrom >= 100000 {
                print("distanceFrom", i, "distanceTo", d)
                isRouteMatrixCompleted = true
                self.callComputeRoutes()
            }
        }
        
        routeModel?.onSucessHandlingGoogleRouteMatrix = { [weak self] model in
            guard let self = self else { return }
            print(model.first?.destinationIndex)
            routeMatrixModel.append(model)
            var furtherstDistanceInMeter : Int?
            for obj in model {
                if furtherstDistanceInMeter == nil {
                    
                    farestObj = obj
                } else if let objDis = obj.distanceMeters, let tempFurtherstDistanceInMeter = furtherstDistanceInMeter,
                          objDis > tempFurtherstDistanceInMeter {
                    furtherstDistanceInMeter = objDis
                    farestObj = obj
                }
                
                furtherstDistanceInMeter = obj.distanceMeters
                if  let objIndex  = obj.destinationIndex {
                    farestDropedObj = filteredObj[objIndex]
                }
            }
            
            routeModel?.onErrorHandlingGoogleRouteMatrix = { [weak self] error in
                guard let self = self else { return }
                print(error)
                self.stopAnimation()
            }
            filteredObj = []
            getPinsUnderLocations(distanceFrom: i, distanceTo: d)
        }
    }
    
}

extension RouteViewController {
    func callComputeRoutes() {
        
        if finalFilteredObj.count == 0 {
            stopAnimation()
            return
        }
        
        var intermediates: [NSMutableDictionary] = []
        var count = ceil(Double(finalFilteredObj.count / 20))
        var i = 0
        for number in 1...Int(count) {
            let prefix = 20 * number
            var array = finalFilteredObj
            number == 1 ? nil : array.removeSubrange(0...prefix)
            for obj in array {
                if (obj.coordinate.latitude != farestDropedObj?.coordinate.latitude), i < 20 {
                    // Create the first destination dictionary
                    i = i + 1
                    let intermediate: NSMutableDictionary = [
                        "location": [
                            "latLng": [
                                "latitude": obj.coordinate.latitude,
                                "longitude": obj.coordinate.longitude
                            ]
                        ]
                    ]
                    intermediates.append(intermediate)
                }
            }
            
            
            let requestDictionary: NSMutableDictionary = [
                "origin": [
                    "location": [
                        "latLng": [
                            "latitude": latitude!,
                            "longitude": longitude!
                        ]
                    ]
                ],
                "destination": [
                    "location": [
                        "latLng": [
                            "latitude": farestDropedObj!.coordinate.latitude,
                            "longitude": farestDropedObj!.coordinate.longitude
                        ]
                    ]
                ],
                "intermediates": intermediates,
                "travelMode": "DRIVE",
                "routingPreference": "TRAFFIC_AWARE",
                "departureTime": "2023-10-15T15:01:23.045123456Z",
                "computeAlternativeRoutes": false,
                "routeModifiers": [
                    "avoidTolls": false,
                    "avoidHighways": false,
                    "avoidFerries": false
                ],
                "languageCode": "en-US",
                "units": "IMPERIAL"
            ]
            
            routeModel?.makeRequestForRouteComputeApi(parameters: requestDictionary)
            
        }
            
        routeModel?.onSucessHandlingGoogleRoutePolyline = { [weak self] model in
            var distanceInMeters = 0
            var duration = 0
            for obj in model.routes! {
                if  let strPolyine = obj.polyline?.encodedPolyline {
                    let coordinates: [CLLocationCoordinate2D]? = decodePolyline(strPolyine)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        stopAnimation()
                        let durationInSec = obj.duration!.replacingOccurrences(of: "s", with: "")
                        duration = duration + (Int(durationInSec) ?? 0)
                        distanceInMeters = distanceInMeters + (obj.distanceMeters ?? 0)
                        self.lblTotalDistance.text = "\(duration) meters"
                        self.lblTime.text = "\(durationInSec)s"
                        self.mapView.addOverlay(MKPolyline(coordinates: coordinates!, count: coordinates!.count))
                    }
                }
            }
        }
    }
}
extension CLLocationCoordinate2D {

    func distance(to coordinate: CLLocationCoordinate2D) -> Double {

        return MKMapPoint(self).distance(to: MKMapPoint(coordinate))
    }
}
