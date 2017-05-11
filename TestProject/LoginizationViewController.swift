//
//  LoginizationViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 3/21/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import ReachabilitySwift
import FacebookLogin
import FacebookCore

class LoginizationViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var currentUser = UserDefaults.standard
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var loginizationButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    var parameters: [String:String] = [:]
    
    
    @IBOutlet weak var viewForFrame: UIView!
    
    let locationManager = CLLocationManager()
    
    var coordLongitude: CLLocationDegrees = 0.0
    
    var coordLatitude: CLLocationDegrees = 0.0
    
    @IBOutlet weak var errorLabel: UILabel!
    let reachability = Reachability()!
    
    @IBOutlet weak var signUpBarButton: UIButton!
    
    @IBOutlet weak var myLoginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.errorLabel.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginizationViewController.forFrameViewTapped))
        self.viewForFrame.addGestureRecognizer(tapGesture)
        
        passwordConfirmTextField.delegate = self
        self.username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestAlwaysAuthorization()
            
        }
            
        else if CLLocationManager.authorizationStatus() == .denied {
            Alert().creatingAlert(message: "If you deny authorization, you will be not able to find or share a spot", controller: self)
        }
            
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.loginizationButton.layer.cornerRadius = 7.5
        self.myLoginButton.layer.cornerRadius = 7.5
        
    }
    
    // segue to RegistrationViewController
    @IBAction func signUpBarAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegistrationViewController", sender: self)
    }
    
    
    
    
    
    // login user
    @IBAction func loginizationAction(_ sender: Any) {
        if self.currentUser.value(forKey: "DeviceToken") == nil {
             Alert().AlertToAllowNotifications(text: "In order to log in, you should allow notification receiving", controller: self)
        } else {
        ValidationChecking().checkingForLoginization(username.text!, usernameLabel, passwordConfirmTextField.text!, passwordLabel) { (userLabel, passwordlabel, parameters) in
            
            if parameters.isEmpty == true {
                self.usernameLabel.text = userLabel
                self.passwordLabel.text = passwordlabel
                
            } else {
                self.parameters = parameters
                if self.reachability.isReachable {
                    ValidationChecking().loginUser(parameters: parameters, completion: { (status, response, error) in
                        if status {
                            self.performSegue(withIdentifier: "toRequesrForAuthorizationSecond", sender: self)
                        } else {
                            ValidationChecking().warning(warningLabel: self.errorLabel, warningLabelText: error)
                        }
                    })
                } else {
                    Alert().creatingAlert(message: "No Internet Connection", controller: self)
                }
                
            }
            
        }
    }
    }
    // end
    
    
    @objc func loginButtonClicked() {
        if self.currentUser.value(forKey: "DeviceToken") == nil {
            Alert().AlertToAllowNotifications(text: "In order to log in, you should allow notification receiving", controller: self)
        } else {
        let loginManagerJustConstant = LoginManager()
        loginManagerJustConstant.logIn([.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                Alert().creatingAlert(message: "Your loginizaton was failed, error: \(error)", controller: self)
            case .cancelled:
                Alert().creatingAlert(message: "You cancelled login", controller: self)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "email, id, name, first_name, last_name, picture.type(large)"])){ httpResponse, result in
                    
                    switch result {
                    case .success(let response):
                        CreateTokens().createTokenForFacebook(facebookId: response.dictionaryValue?["id"] as! String, password: "12345678ab", deviceSignature: String(describing: self.currentUser.value(forKey: "DeviceToken")!))
                        
                        self.parameters = ["token" : self.currentUser.value(forKey: "userTokenFaceboook") as! String]
                        
                        if self.reachability.isReachable {
                            ValidationChecking().loginUserViaFB(parameters: self.parameters, completion: { (status, json, error) in
                                if status {
                                    let urlVariable: String = ("https://graph.facebook.com/\(response.dictionaryValue?["id"] as! String)/picture?height=1024&width=1024" as String?)!
                                    self.currentUser.set(urlVariable, forKey: "pictureURL")
                                    self.performSegue(withIdentifier: "toRequesrForAuthorization", sender: self)
                                }
                                if !status {
                                    Alert().creatingAlert(message: "\(error)", controller: self)
                                }
                            })
                        } else {
                            Alert().creatingAlert(message: "No Internet Connection", controller: self)
                        }
                    case .failed(let error):
                        Alert().creatingAlert(message: "\(error)", controller: self)
                    }
                }
                connection.start()
            }
        }
    }
    }
    // end
    

    
    // update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.coordLongitude = (manager.location?.coordinate.longitude)!
        
        self.coordLatitude = (manager.location?.coordinate.latitude)!
        self.currentUser.set(Double(self.coordLatitude), forKey: "userLatitude")
        self.currentUser.set(Double(self.coordLongitude), forKey: "userLongitude")
        self.locationManager.stopUpdatingLocation()
    }
    // end
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // set up the view for TapGestureRecognizer
    func forFrameViewTapped() {
        self.view.endEditing(true)
    }
    // end
    
    
}
