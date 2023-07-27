//
//  Constant.swift
//  mapana
//
//  Created by Naman Sheth on 15/07/23.
//

import Foundation


struct ApiConstants {
    static let apiBaseURL = "https://api-mapana.lattice.site/"
    static let loginAuth = "user/auth/"
    static let getAllBorough = "borough/all"
    static let getBoroughByID = "sign/location/req"
    static let signsDrawing = "sign/drawing/data/"
    static let getAllImages = "survey/media/"
    static let getAllComments = "survey/comment/"
    static let addAComment = "survey/comment"
    static let uploadImage = "survey/media/upload/"
    
    static let computeRouteMatrix = "https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix"
    static let computeRoute = "https://routes.googleapis.com/directions/v2:computeRoutes"
    static let googleApi = "AIzaSyDgM9o0ABoRIn-YQit77Nemr3WlcmQbIAQ"
    static let distanceApi = "https://maps.googleapis.com/maps/api/directions/json?origin="
}



/// getDate to make operation for date related
///
/// - Parameter time: String value of time
/// - Returns: Date object
func getDate(time: Int) -> String {
    let timeInterval = TimeInterval(time)
    // create NSDate from Double (NSTimeInterval)
    let myNSDate = Date(timeIntervalSince1970: timeInterval)
    
    let dateFormater = DateFormatter()
    dateFormater.dateStyle = .full
    dateFormater.timeStyle = .full
    return dateFormater.string(from: myNSDate)
}


//{
//  "origins": [
//    {
//      object (RouteMatrixOrigin)
//    }
//  ],
//  "destinations": [
//    {
//      object (RouteMatrixDestination)
//    }
//  ],
//  "travelMode": DRIVE,
//  "routingPreference": ROUTING_PREFERENCE_UNSPECIFIED,
//  "languageCode": en,
//}
