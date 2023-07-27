//
//  LoginViewModel.swift
//  mapana
//
//  Created by Naman Sheth on 15/07/23.
//

import Foundation

class LoginViewModel: NSObject {
    var onErrorHandling : ((RequestError) -> Void)?
    var onSucessHandling : ((LoginAPI) -> Void)?


    func checkUserAuth(userName: String, password: String) {
        
        ApiRequest.makeLoginUser(username: userName, password: password) { [weak self]  (result: Result<LoginAPI, RequestError>, serverData)  in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
                if let userId = model.id, let userName = model.username, let userRole = model.userRole {
                    let defaults = UserDefaults.standard
                    defaults.set(userId, forKey: "userId")
                    defaults.set(userName, forKey: "userName")
                    defaults.set(1, forKey: "userRoleId")
                    defaults.set(userRole, forKey: "userRole")
                    defaults.synchronize()
                    print(UserDefaults.standard.object(forKey: "userId")!)
                }
                self.onSucessHandling?(model)
                break
            case .failure(let error):
                print(error)
                self.onErrorHandling?(error)
                break
            }
        }
    }
}
