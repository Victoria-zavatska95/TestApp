//
//  RequestsForUserRegistrationLoginization.swift
//  TestProject
//
//  Created by Azinec LLC on 5/16/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JWT


class RequestsForUserRegistrationLoginization: NSObject {
    var url : String = "http://188.166.110.248:3010/v1"
    var port: String = ""
    var currentUser = UserDefaults.standard
    
    // send request to server in order to register User
    func registerUser(parameters: [String : String], password: String, userName: String, completion: @escaping (_ status: Bool, _ result: JSON, _ descriptionOfError: String) -> Void) {
        var descriptionofError: String = ""
        self.port = "/users"
        Alamofire.request("\(self.url)\(self.port)", method: .post, parameters: parameters).responseJSON { (response) in
            let result: JSON = JSON(response.data)
            if result["description"].stringValue == "Created" {
                self.currentUser.set(true, forKey: "isRegistered")
                completion(true, result, "")
            }
            else {
                
                if result["error"]["errors"]["userName"]["message"].stringValue == "Error, expected `userName` to be unique. Value: `\(userName)`" {
                    descriptionofError = "The userName is already taken"
                    completion(false, result, descriptionofError)
                }
                
                if result["error"].stringValue == "Email already in use" {
                    descriptionofError = "Email is already taken"
                    completion(false, result, descriptionofError)
                }
                completion(false, result, descriptionofError)
            }
        }
    }
    // end
    
    
    //Facebook Registration
    func postFacebookRegistration(parameters:[String:String], completitionHandler: @escaping (_ status:Bool, _ json:JSON, _ error: String) -> ()){
        port = "/users"
        var error: String = ""
        Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
            let result: JSON = JSON(response.data)
            
            if result["description"].stringValue == "OK" {
                self.currentUser.set(true, forKey: "isRegistered")
                completitionHandler(true, result, "")
            }
            if result["description"].stringValue == "Created" {
                self.currentUser.set(true, forKey: "isRegistered")
                completitionHandler(true, result, "")
            }
            else if result["error"].stringValue == "Email already in use" {
                error = "Your email has been already used for another account"
                completitionHandler(false, result, error)
            }
            else if result["error"]["errors"]["userName"]["name"].stringValue == "ValidatorError" {
                error = "Your username is invalid"
                completitionHandler(false, result, error)
            }
            else if result["error"]["errors"]["email"]["name"].stringValue == "ValidatorError" {
                error = "Your email is invalid"
                completitionHandler(false, result, error)
            } else {
                error = "Your data is invalid"
                completitionHandler(false, result, error)
            }
        }
    }
    //end
    
    
    
    // send request to server in order to login User
    func loginUser(parameters: [String:String], completion: @escaping (_ status: Bool, _ result: JSON, _ descriptionOfError: String) -> Void) {
        port = "/users/login/manual"
        var descriptionofError: String = ""
        Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
            var result: JSON = JSON(response.data)
            if result["error"].stringValue == "Incorrect password" {
                descriptionofError = "Your password is incorrect"
                completion(false, result, descriptionofError)
            }
            
            if result["error"].stringValue == "Account doesn't exist" {
                descriptionofError = "Such username doesn't exist"
                completion(false, result, descriptionofError)
            } else {
                self.currentUser.set("\(result)", forKey: "userArray")
                self.currentUser.set(result["data"]["_id"].stringValue, forKey: "userId")
                self.currentUser.set(true, forKey: "isLogined")
                
                completion(true, result, "")
            }
        }
    }
    // end

    
    
    // send request to server in order to login User
    func loginUserViaFB(parameters: [String:String], completion: @escaping (_ status: Bool, _ result: JSON, _ error: String) -> Void) {
        self.port = "/users/login/facebook"
        var error: String = ""
        Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
            var result: JSON = JSON(response.data)
            if result["description"].stringValue == "OK" {
                self.currentUser.set("\(result)", forKey: "userArray")
                self.currentUser.set(result["data"]["_id"].stringValue, forKey: "userId")
                self.currentUser.set(true, forKey: "isLoginedViaFB")
                self.currentUser.set(true, forKey: "isLogined")
                completion(true, result, "")
            } else {
                error = "Such account doesn't exist. You have not registered this account yet"
                completion(false, result, error)
            }
        }
    }
    // end


}
