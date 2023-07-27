//
//  LocationManager.swift
//  mapana
//
//  Created by Naman Sheth on 20/07/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    
    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
    }
}
