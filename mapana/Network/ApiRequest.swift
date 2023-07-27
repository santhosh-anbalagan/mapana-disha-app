//
//  ApiRequest.swift
//  mapana
//
//  Created by Naman Sheth on 17/07/23.
//

import Foundation
import UIKit

struct ApiRequest {
    
    static func makeLoginUser<T: Codable>(of type: T.Type = T.self, username: String, password: String, completion: @escaping (Result<T, RequestError>, Data) -> Void)  {
        let url = ApiConstants.apiBaseURL + ApiConstants.loginAuth
        let parameters = ["username": username, "password": password]
        NetworkManager().postRequest(url: url, parameters: parameters, completion: completion)
    }
    
    static func fetchAllBorough<T: Codable>(of type: T.Type = T.self, completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        let url = ApiConstants.apiBaseURL + ApiConstants.getAllBorough
        NetworkManager().getServiceData(url: url, completion: completion)
    }
    
    static func getBroughtByID<T: Codable>(of type: T.Type = T.self, boroughId: String, completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        let url = ApiConstants.apiBaseURL + ApiConstants.getBoroughByID
        let parameters = ["boroughId": boroughId]
        NetworkManager().postRequest(url: url, parameters: parameters, completion: completion)
    }
    
    
    static func getRouteMatrixApi<T:Codable>(of type: T.Type = T.self, parameters: NSMutableDictionary, completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        let url = ApiConstants.computeRouteMatrix
        let parameters = parameters
        NetworkManager().postRequestForGoogle(url: url, parameters: parameters, completion: completion)
    }
    
    static func getRouteComputeRoute<T:Codable>(of type: T.Type = T.self, parameters: NSMutableDictionary, completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        let url = ApiConstants.computeRoute
        let parameters = parameters
        NetworkManager().postRequestForGoogleRoute(url: url, parameters: parameters, completion: completion)
    }

    static func getAllSurveyImages<T: Codable>(of type: T.Type = T.self, userId: String, completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        let url = ApiConstants.apiBaseURL + ApiConstants.getAllImages + userId
        NetworkManager().getServiceData(url: url, completion: completion)
    }
    
    static func getAllSurveyComments<T: Codable>(of type: T.Type = T.self, userId: String, completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        let url = ApiConstants.apiBaseURL + ApiConstants.getAllComments + userId
        NetworkManager().getServiceData(url: url, completion: completion)
    }
    
    static func addAComment<T: Codable>(of type: T.Type = T.self, userID: String, signId: String, comment: String, completion: @escaping (Result<T, RequestError>, Data) -> Void)  {
        let url = ApiConstants.apiBaseURL + ApiConstants.addAComment
        let parameters = ["userId": userID, "signId": signId, "comment": comment]
        NetworkManager().postRequest(url: url, parameters: parameters, completion: completion)
    }
    
    static func uploadImage<T: Codable>(of type: T.Type = T.self, file: UIImage, userId: String, pos: [String: String], completion: @escaping (Result<T, RequestError>, Data) -> Void)  {
        let url = ApiConstants.apiBaseURL + ApiConstants.uploadImage
        let parameters = ["file": file, "userId": userId, "pos": pos] as [String : Any]
        NetworkManager().postRequest(url: url, parameters: parameters, completion: completion)
    }
    
}
