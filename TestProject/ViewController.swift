//  ViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 3/21/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift
import SwiftyJSON
import FacebookLogin
import FacebookCore
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    var parameters: [String : String] = [:]
    var currentUser = UserDefaults.standard
    
    
    @IBOutlet weak var emailLabelSecond: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var logInBar: UIButton!
    var emailVariable: String = ""
    
    
    
    @IBOutlet weak var viewForFrame: UIView!
    let reachability = Reachability()!
    
    @IBOutlet weak var myLoginButton: UIButton!
    
    override func viewDidLoad() {
        self.errorLabel.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        if self.currentUser.bool(forKey: "isLogined") {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toRequestFromViewController", sender: self)
            }
        }
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.forFrameViewTapped))
        
        self.myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        self.viewForFrame.addGestureRecognizer(tapGesture)
        nameTextField.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.emailTextfield.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.userNameLabel.adjustsFontSizeToFitWidth = true
        self.emailLabelSecond.adjustsFontSizeToFitWidth = true
        self.passwordLabel.adjustsFontSizeToFitWidth = true
        self.myLoginButton.layer.cornerRadius = 7.5
        self.registrationButton.layer.cornerRadius = 7.5
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // perform seque to ShowLoginizationView
    @IBAction func logInBarAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowLoginizationView", sender: self)
    }
    // end
    
    //log in user
    @objc func loginButtonClicked() {
        let loginManagerJustConstant = LoginManager()
        loginManagerJustConstant.logIn([.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                Alert().creatingAlert(message: "Your loginizaton was failed, error: \(error)", controller: self)
            case .cancelled:
                Alert().creatingAlert(message: "You cancelled login", controller: self)
            case .success:
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "email, id, name, first_name, last_name"])){ httpResponse, result in
                    
                    switch result {
                    case .success(let response):
                        self.facebookRegistration(response: response)
                    case .failed(let error):
                        Alert().creatingAlert(message: "\(error)", controller: self)
                    }
                }
                connection.start()
            }
        }
    }
    // end
    
    // in case of getting a successful GraphRequest response
    func facebookRegistration(response: GraphRequest.Response) {
        if response.dictionaryValue?["email"] != nil {
            self.emailVariable = response.dictionaryValue?["email"] as! String
        } else {
            let emailGenerated: String = response.dictionaryValue?["id"] as! String + "ab@mail.ru"
            self.emailVariable = emailGenerated
        }
        self.parameters = [
            "facebookId": response.dictionaryValue?["id"] as! String,
            "password": "12345678ab",
            "firstName": response.dictionaryValue?["first_name"] as! String,
            "userName": response.dictionaryValue?["id"] as! String,
            "provider": "facebook",
            "email": self.emailVariable
        ]
        
        RequestsForUserRegistrationLoginization().postFacebookRegistration(parameters: self.parameters, completitionHandler: { (status, json, error) in
            if status {
                self.performSegue(withIdentifier: "ShowLoginizationView", sender: self)
            } else {
                
                ValidationChecking().warning(warningLabel: self.errorLabel, warningLabelText: error)
            }
        })

    }
    // end
    
    
    // hide labels while editing textfields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.nameLabel.isHidden = true
        self.userNameLabel.isHidden = true
        self.emailLabelSecond.isHidden = true
        self.passwordLabel.isHidden = true
    }
    // end
    
    // register user not via FB
    @IBAction func registrationAction(_ sender: Any) {
        self.nameLabel.text = ""
        self.userNameLabel.text = ""
        self.passwordLabel.text = ""
        self.emailLabelSecond.text = ""
        self.errorLabel.text = ""
        
        let resultOfChecking = ValidationChecking().checkingForRegistration(nameTextField.text!, userNameTextField.text!, userNameLabel, emailTextfield.text!, emailLabelSecond, nameLabel, passwordTextfield.text!, passwordLabel)
        
        
        if resultOfChecking.parameters.count == 0 {
            self.nameLabel.text = resultOfChecking.error["name"]
            self.userNameLabel.text = resultOfChecking.error["username"]
            self.passwordLabel.text = resultOfChecking.error["password"]
            self.emailLabelSecond.text = resultOfChecking.error["email"]
            self.errorLabel.text! = "Data is incorrect"
        } else {
            if self.reachability.isReachable {
                self.parameters = resultOfChecking.parameters
                RequestsForUserRegistrationLoginization().registerUser(parameters: self.parameters, password: self.passwordTextfield.text!, userName: self.userNameTextField.text!, completion: { (status, json, error) in
                    if status {
                        self.performSegue(withIdentifier: "ShowLoginizationView", sender: self)
                    } else {
                        ValidationChecking().warning(warningLabel: self.errorLabel, warningLabelText: error)
                    }
                })
            } else {
                Alert().creatingAlert(message: "No Internet Connection", controller: self)
            }
        }
        
    }
    // end
    
    // set up the view for TapGestureRecognizer
    func forFrameViewTapped() {
        self.view.endEditing(true)
    }
    // end
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
