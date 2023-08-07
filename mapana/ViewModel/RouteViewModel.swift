//
//  RouteViewModel.swift
//  mapana
//
//  Created by Naman Sheth on 19/07/23.
//

import Foundation

class RouteModel: NSObject {
    var onErrorHandling : ((RequestError) -> Void)?
    var onSucessHandling : ((BoroughLocation) -> Void)?
    var onSucessBoroughRouteHandling : ((BoroughRoute) -> Void)?
    var onSucessHandlingBoroughAll : ((BoroughAll) -> Void)?
    
    var onSucessHandlingGoogleRouteMatrix: ((RouteMatrix) -> Void)?
    var onErrorHandlingGoogleRouteMatrix: ((RequestError) -> Void)?
    
    var onSucessHandlingGoogleRoutePolyline: ((GoogleRoute) -> Void)?
    var onErrorHandlingGoogleRoutePolyline: ((RequestError) -> Void)?
    
    func fetchAllBorough(userId:String)  {
        ApiRequest.fetchAllBorough(userId: userId) { [weak self]  (result: Result<BoroughAll, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandlingBoroughAll?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandling?(error)
                break
            }
        }
    }
    
    func getBoroughByBoroughID(userSelectedBoroughID: String) {
        ApiRequest.getBroughtByID(boroughId: userSelectedBoroughID) { [weak self]  (result: Result<BoroughLocation, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandling?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandling?(error)
                break
            }
        }
    }
    
    func fetchBoroughRouteById(userSelectedBoroughID: String,userId: String) {
        ApiRequest.fetchBoroughRouteByID(boroughId: userSelectedBoroughID,userId: userId) { [weak self]  (result: Result<BoroughRoute, RequestError>, serverData) in
            guard let self = self else { return }
            print("RESPONSE:: \(result)")
            switch result {
            case .success(let model):
                print(model)
                self.onSucessBoroughRouteHandling?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandling?(error)
                break
            }
        }
    }
    
    func makeRequestForRouteMatrixApi(parameters: NSMutableDictionary)  {
        ApiRequest.getRouteMatrixApi(parameters: parameters) { [weak self]  (result: Result<RouteMatrix, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandlingGoogleRouteMatrix?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandlingGoogleRouteMatrix?(error)
                break
            }
        }
    }
    
    func makeRequestForRouteComputeApi(parameters: NSMutableDictionary)  {
        ApiRequest.getRouteComputeRoute(parameters: parameters) { [weak self]  (result: Result<GoogleRoute, RequestError>, serverData) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                self.onSucessHandlingGoogleRoutePolyline?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandlingGoogleRoutePolyline?(error)
                break
            }
        }
    }
    
    func makeRequestForNavigationUpdateApi(userID: String, signId: String, isStart: Bool,timestamp: String,timerSec: String,lat: String,long: String,derivedDistance: String,derivedTime: String){
        ApiRequest.updateNavigation(userID: userID, signId: signId, isStart: isStart, timestamp: timestamp, timerSec: timerSec, lat: lat, long: long, derivedDistance: derivedDistance, derivedTime: derivedTime) {
            [weak self]  (result: Result<JSONNull, RequestError>, serverData) in
//                guard let self = self else { return }
                switch result {
                case .success(let model):
                    print("NAVIGATION_UPDATE:: \(model)")
                    break
                case .failure(let error):
                    print("NAVIGATION_UPDATE:: \(error)")
                    break
                }
        }
    }
    
    func makeRequestForReportApi(userID: String, signId: String, status: String, timestamp: String, timerSec: String, lat: String, long: String) {
        ApiRequest.reportAPI(signId: signId, userID: userID, status: status, lat: lat, long: long, timestamp: timestamp, timerSec: timerSec) {
            [weak self]  (result: Result<JSONNull, RequestError>, serverData) in
            
            switch result {
            case .success(let model):
                print("REPORT:: success")
                break
            case .failure(let error):
                print("REPORT:: \(error)")
                break
            }
        }
    }
    
    func makeRequestForCrossPointApi(userID: String, signId: String, status: String, timestamp: String, timerSec: String) {
        ApiRequest.crossPointAPI(signId: signId, userID: userID, status: status, timestamp: timestamp, timerSec: timerSec) {
            [weak self]  (result: Result<JSONNull, RequestError>, serverData) in
            
            switch result {
            case .success(let model):
                print("REPORT:: success")
                break
            case .failure(let error):
                print("REPORT:: \(error)")
                break
            }
        }
    }
}
