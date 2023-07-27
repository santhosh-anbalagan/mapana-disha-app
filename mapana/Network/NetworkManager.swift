//
//  NetworkManager.swift
//  mapana
//
//  Created by Naman Sheth on 15/07/23.
//

import Foundation

enum RequestError: Error {
    case clientError
    case serverError
    case noData
    case dataDecodingError
}

struct NetworkManager {
    
    private let decoder: JSONDecoder
    
    public init(_ decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    /// getServiceData is to call api
    ///
    /// - Parameters:
    ///   - url: String varible
    ///   - completion: escaping clouser
    func getServiceData<T: Codable>(url: String, completion: @escaping (Result<T, RequestError>, Data) -> Void)  {
        let session = URLSession.shared
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            
            guard let serverData = data else {
                completion(.failure(.clientError), Data())
                return
            }
            
            guard error == nil else {
                completion(.failure(.clientError), serverData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverError), serverData)
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData), serverData)
                return
            }
            
            // Now parsing
            do {
                let response  = try self.decoder.decode(T.self, from: serverData)
                completion(.success(response), data)
            } catch {
                completion(.failure(.dataDecodingError), serverData)
            }
        }.resume()
    }
    
    func postRequest<T: Decodable>(of type: T.Type = T.self, url: String, parameters: [String:Any],
                                   completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        request.httpBody  = try? JSONSerialization.data(withJSONObject: parameters)
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let serverData = data else {
                completion(.failure(.clientError), Data())
                return
            }
            
            guard error == nil else {
                completion(.failure(.clientError), serverData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverError), serverData)
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData), serverData)
                return
            }
            
            do {
                let response  = try self.decoder.decode(T.self, from: serverData)
                completion(.success(response), data)
            } catch {
                completion(.failure(.dataDecodingError), serverData)
            }
        })
        
        task.resume()
    }
    
    func postRequestForGoogle<T: Decodable>(of type: T.Type = T.self, url: String, parameters: NSMutableDictionary,
                                   completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        
     
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        let data  = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let jsonString = String(data: data!, encoding: .utf8)?.data(using: String.Encoding.utf8)
        print(jsonString ?? "")
        request.httpBody = String(data: data!, encoding: .utf8)!.data(using: String.Encoding.utf8)
        
        //HTTP Headers
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("no-cache", forHTTPHeaderField: "cache-control")
        request.addValue(ApiConstants.googleApi, forHTTPHeaderField: "X-Goog-Api-Key")
        request.addValue("originIndex,destinationIndex,duration,distanceMeters,status,condition", forHTTPHeaderField: "X-Goog-FieldMask")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let serverData = data else {
                completion(.failure(.clientError), Data())
                return
            }
            
            guard error == nil else {
                completion(.failure(.clientError), serverData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverError), serverData)
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData), serverData)
                return
            }
            
            do {
                let response  = try self.decoder.decode(T.self, from: serverData)
                completion(.success(response), data)
            } catch {
                completion(.failure(.dataDecodingError), serverData)
            }
        })
        
        task.resume()
    }
    
    func postRequestForGoogleRoute<T: Decodable>(of type: T.Type = T.self, url: String, parameters: NSMutableDictionary,
                                   completion: @escaping (Result<T, RequestError>, Data) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        let data  = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let jsonString = String(data: data!, encoding: .utf8)?.data(using: String.Encoding.utf8)
        print(jsonString ?? "")
        request.httpBody = String(data: data!, encoding: .utf8)!.data(using: String.Encoding.utf8)
        
        //HTTP Headers
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("no-cache", forHTTPHeaderField: "cache-control")
        request.addValue(ApiConstants.googleApi, forHTTPHeaderField: "X-Goog-Api-Key")
        request.addValue("routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline", forHTTPHeaderField: "X-Goog-FieldMask")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let serverData = data else {
                completion(.failure(.clientError), Data())
                return
            }
            
            guard error == nil else {
                completion(.failure(.clientError), serverData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.serverError), serverData)
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData), serverData)
                return
            }
            
            do {
                let response  = try self.decoder.decode(T.self, from: serverData)
                completion(.success(response), data)
            } catch {
                completion(.failure(.dataDecodingError), serverData)
            }
        })
        
        task.resume()
    }
}



