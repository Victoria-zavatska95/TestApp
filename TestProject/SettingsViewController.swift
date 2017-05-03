//
//  SettingsViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 4/4/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import ReachabilitySwift

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    var currentUser = UserDefaults.standard
    
    @IBOutlet weak var deleteAcountButton: UIButton!
    var myColor = UIColor.white
    
    @IBOutlet weak var cancelRequest: UIButton!
    
    @IBOutlet weak var deleteSpotButton: UIButton!
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.logoutButton.layer.cornerRadius = 25.0
        self.deleteAcountButton.layer.cornerRadius = 25.0
        self.logoutButton.layer.borderWidth = 2.0
        self.deleteAcountButton.layer.borderColor = myColor.cgColor
        self.deleteAcountButton.layer.borderWidth = 2.0
        self.logoutButton.layer.borderColor = myColor.cgColor
        self.deleteSpotButton.layer.borderColor = myColor.cgColor
        self.deleteSpotButton.layer.borderWidth = 2.0
        self.deleteSpotButton.layer.cornerRadius = 25.0
        self.cancelRequest.layer.borderWidth = 2.0
        self.cancelRequest.layer.borderColor = myColor.cgColor
        self.cancelRequest.layer.cornerRadius = 25.0
        self.cancelRequest.isHidden = true
        self.deleteSpotButton.isHidden = true
        super.viewDidLoad()
    }
    
    
    // create the new account
    @IBAction func deleteAcountAction(_ sender: Any) {
        if self.currentUser.object(forKey: "isLoginedViaFB") != nil && self.currentUser.bool(forKey: "isLoginedViaFB") && !self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated") {
            let loginManagerJustConstant = LoginManager()
            loginManagerJustConstant.logOut()
            self.currentUser.set(false, forKey: "isLogined")
            self.currentUser.set(false, forKey: "isLoginedViaFB")
            self.currentUser.set(nil, forKey: "pictureURL")
            
        }
        if !self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated") {
            self.currentUser.set(false, forKey: "isRegistered")
            self.currentUser.set(false, forKey: "isLogined")
            self.currentUser.set(nil, forKey: "pictureURL")
            self.performSegue(withIdentifier: "fromdeleteAccountToRegistrationViewController", sender: self)
        }
        else if self.currentUser.bool(forKey: "spotCreated") {
            self.deleteSpotButton.isHidden = false
            self.deleteAcountButton.isEnabled = false
            Alert().creatingAlert(message: "You cannot create the new account because you have already created a spot. Please first delete the spot", controller: self)
        } else {
            self.cancelRequest.isHidden = false
            self.logoutButton.isEnabled = false
            Alert().creatingAlert(message: "You cannot create the new account because you have already sent a reguest. Please first cancel the request", controller: self)
        }
    }
    // end
    
    
    // logout
    @IBAction func logoutAction(_ sender: Any) {
        if self.currentUser.object(forKey: "isLoginedViaFB") != nil && self.currentUser.bool(forKey: "isLoginedViaFB") && !self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated"){
            let loginManagerJustConstant = LoginManager()
            loginManagerJustConstant.logOut()
            self.currentUser.set(false, forKey: "isLogined")
            self.currentUser.set(false, forKey: "isLoginedViaFB")
            self.currentUser.set(nil, forKey: "pictureURL")
        }
        if !self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated") {
            self.currentUser.set(false, forKey: "isLogined")
            self.currentUser.set(nil, forKey: "pictureURL")
            self.performSegue(withIdentifier: "fromLogouttoLoginizationViewController", sender: self)
        }
        else if self.currentUser.bool(forKey: "spotCreated") {
            self.deleteSpotButton.isHidden = false
            self.logoutButton.isEnabled = false
            Alert().creatingAlert(message: "You cannot log out because you have already created a spot. Please first delete the spot", controller: self)
        } else {
            self.cancelRequest.isHidden = false
            self.logoutButton.isEnabled = false
            Alert().creatingAlert(message: "You cannot log out because you have already sent a reguest. Please first cancel the request", controller: self)
        }
    }
    // end
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func deleteSpotAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().deletePrivareCharge { (response, status, error) in
                if status {
                    Alert().creatingAlert(message: "Your charge was successfully deleted", controller: self)
                    self.deleteSpotButton.isHidden = true
                    self.logoutButton.isEnabled = true
                    self.deleteAcountButton.isEnabled = true
                }else{
                    Alert().creatingAlert(message: "\(error)", controller: self)
                }
                
            }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
        }
    }
    
    
    @IBAction func cancelRequestAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation { (json, status) in
                if status {
                    Alert().creatingAlert(message: "Your request was successfully deleted", controller: self)
                    self.cancelRequest.isHidden = true
                    self.logoutButton.isEnabled = true
                    self.deleteAcountButton.isEnabled = true
                }else{
                    Alert().creatingAlert(message: "Deleting of your request was failed", controller: self)
                }
                
            }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
        }
    }
    
    
}
