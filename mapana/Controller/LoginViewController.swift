//
//  LoginViewController.swift
//  mapana
//
//  Created by Naman Sheth on 15/07/23.
//

import UIKit
//import FLEX
class LoginViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var loginBaseView: UIView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var loginViewModel: LoginViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // FLEXManager.shared.showExplorer()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func buttonLoginTapped(_ sender: UIButton) {
       // labelEmail.text = "crew-survey"
       // labelPassword.text = "survey@2023"
        
        if !handleValidationError() {
            loginViewModel?.checkUserAuth(userName: userEmailTextField.text!, password: userPasswordTextField.text!)
        }
        self.loginViewModel?.onErrorHandling = { error in
            print(error)
        }
        
        self.loginViewModel?.onSucessHandling = { model in
            print(model)
            self.makeUserLogin()
        }
        

    }
    
    func makeUserLogin() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first
            if window != nil {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                //let navController = UINavigationController(rootViewController: loginVC!)
                window!.rootViewController = nil
                window!.rootViewController = loginVC
                window!.makeKeyAndVisible()
                UIView.transition(with: window!, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            }
        }
    }
    
    func handleValidationError() -> Bool {
        if let text =  userEmailTextField.text, text.isEmpty {
            showErrorMessage(message: "Please enter email id")
            return true
        } else if isValidEmail(userEmailTextField.text!) {
            //showErrorMessage(message: "Please enter valid email id")
            return false
        } else if let text = userPasswordTextField.text, text.isEmpty {
            showErrorMessage(message: "Please enter password")
            return true
        }
      return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showErrorMessage(message: String)  {
        var alert = UIAlertController(title: "Lattice Mapana", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] (action: UIAlertAction!) in
            
            
        }))
        present(alert, animated: true, completion: nil)
        
    }
}
