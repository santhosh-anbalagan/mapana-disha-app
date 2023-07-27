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
    var onSucessHandlingBoroughAll : ((BoroughAll) -> Void)?
    
    var onSucessHandlingGoogleRouteMatrix: ((RouteMatrix) -> Void)?
    var onErrorHandlingGoogleRouteMatrix: ((RequestError) -> Void)?
    
    var onSucessHandlingGoogleRoutePolyline: ((GoogleRoute) -> Void)?
    var onErrorHandlingGoogleRoutePolyline: ((RequestError) -> Void)?
    
    func fetchAllBorough()  {
        ApiRequest.fetchAllBorough { [weak self]  (result: Result<BoroughAll, RequestError>, serverData) in
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
}
