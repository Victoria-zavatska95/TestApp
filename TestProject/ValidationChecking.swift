//
//  ValidationChecking.swift
//  TestProject
//
//  Created by Azinec LLC on 3/30/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JWT

class ValidationChecking: NSObject {
    var url: String = ""
    var port: String = ""
    var currentUser = UserDefaults.standard
    let usernameMinimumCharactersCount = 6
    let passwordMinimumCharactersCount = 8
    
    // validate data for registration before sending a request to server
    func checkingForRegistration(_ name: String, _ userName: String, _ userLabel: UILabel, _ email: String, _ emaillabel: UILabel, _ namelabel: UILabel, _ password: String, _ passwordlabel: UILabel, completitionHandler:@escaping (_ nameForDestination: String, _ userNameForDestination: String, _ passwordFor: String, _ emailFor: String, _ parameters: Parameters) -> Void) {
        
        var nameForDestination: String = ""
        var emailFor: String = ""
        var passwordFor: String = ""
        var userNameFoorDestination: String = ""
        var parameters: [String:String] = [:]
        
        
        
        if name.characters.count < usernameMinimumCharactersCount {
            namelabel.isHidden = false
            nameForDestination = "Name should contain at least 6 letters"
        }
        
        if userName.characters.count < usernameMinimumCharactersCount {
            userLabel.isHidden = false
            userNameFoorDestination = "Username should contain at least 6 letters"
        }
        if name.characters.count < usernameMinimumCharactersCount && self.isValidEmail(testStr: email) == false {
            namelabel.isHidden = false
            nameForDestination = "Name should contain at least 6 letters"
            emaillabel.isHidden = false
            emailFor = "email is invalid"
            
        }
        
        if password.characters.count < passwordMinimumCharactersCount && self.validate(password: password) == true {
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain at least 8 symbols including at least 1 number"
            emaillabel.isHidden = false
            emailFor = "email is invalid"
            
        }
        
        if name.characters.count < usernameMinimumCharactersCount && (password.characters.count) < passwordMinimumCharactersCount {
            namelabel.isHidden = false
            nameForDestination = "Name should contain at least 6 letters"
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain at least 8 symbols including at least 1 number"
            
        }
        
        if name.characters.count < usernameMinimumCharactersCount && (password.characters.count) < passwordMinimumCharactersCount && self.isValidEmail(testStr: email) == false {
            namelabel.isHidden = false
            nameForDestination = "Name should contain at least 6 letters"
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain at least 8 symbols including at least 1 number"
            emaillabel.isHidden = false
            emailFor = "email is invalid"
        }
        
        
        
        if self.isValidEmail(testStr: email) == false {
            emaillabel.isHidden = false
            emailFor = "email is invalid"
        }
        
        if password.characters.count < passwordMinimumCharactersCount || self.validate(password: password) == false {
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain at least 8 symbols including at least 1 number"
        }
        
        if name.characters.count >= usernameMinimumCharactersCount && userName.characters.count >= usernameMinimumCharactersCount && password.characters.count >= passwordMinimumCharactersCount && isValidEmail(testStr: email) == true && self.validate(password: password) == true {
            namelabel.isHidden = true
            emaillabel.isHidden = true
            passwordlabel.isHidden = true
            parameters = [
                "firstName": name,
                "email": email,
                "userName" : userName,
                "password": password,
                "gender": "Unknown",
                "birthday": "123213",
                "provider": "plugspot"
                
            ]
            
        }
        
        completitionHandler(nameForDestination, userNameFoorDestination, passwordFor, emailFor, parameters)
    }
    // end
    
    
    
    
    // validate data for loginization before sending a request to server
    func checkingForLoginization(_ name: String, _ namelabel: UILabel, _ password: String, _ passwordlabel: UILabel, completitionHandler:@escaping (_ nameForDestination: String, _ passwordFor: String, _ parameters: [String:String]) -> Void) {
        var nameForDestination: String = ""
        var passwordFor: String = ""
        var parameters: [String:String] = [:]
        
        
        if (name.characters.count) < usernameMinimumCharactersCount {
            namelabel.isHidden = false
            nameForDestination = "Name should contain at least 6 symbols"
        }
        
        
        
        if (password.characters.count) < passwordMinimumCharactersCount || self.validate(password: password) == false {
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain at least 8 symbols including at least 1 number"
        }
        
        
        
        if (password.characters.count) >= passwordMinimumCharactersCount && name.characters.count >= usernameMinimumCharactersCount  && self.validate(password: password) == true {
            CreateTokens().createTokenForManual(userName: name, password: password, deviceSignature: String(describing: self.currentUser.value(forKey: "DeviceToken")!)
            )
            parameters = ["token" : currentUser.value(forKey: "userToken") as! String]
        }
        completitionHandler(nameForDestination, passwordFor, parameters)
        
    }
    // end
    
    
    // validate a password
    func validate(password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Za-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else { return false }
        
        
        return true
    }
    // end
    
    
    // validate an email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    // end
    
    
    
    // send request to server in order to register User
    func registerUser(parameters: [String : String], password: String, userName: String, completion: @escaping (_ status: Bool, _ result: JSON, _ descriptionOfError: String) -> Void) {
        var descriptionofError: String = ""
        url = "http://188.166.110.248:"
        port = "3010/v1/users"
        Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
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
        url = "http://188.166.110.248:"
        port = "3010/v1/users"
        var error: String = ""
        let facebookId = parameters["facebookId"]
        let password = parameters["password"]
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
    func loginUserViaFB(parameters: [String:String], completion: @escaping (_ status: Bool, _ result: JSON, _ error: String) -> Void) {
        self.url = "http://188.166.110.248:"
        self.port = "3010/v1/users/login/facebook"
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
    
    // send request to server in order to login User
    func loginUser(parameters: [String:String], completion: @escaping (_ status: Bool, _ result: JSON, _ descriptionOfError: String) -> Void) {
        url = "http://188.166.110.248:"
        port = "3010/v1/users/login/manual"
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
    
    
    // set text for error Label and animate the label
    func warning(warningLabel : UILabel, warningLabelText : String){
        warningLabel.text = warningLabelText
        
        warningLabel.isHidden = false
        UIView.animate(withDuration: 7) {
            
            
        }
    }
    // end
    
    
    // cast String to JSON
    func stringToJSON(_ jsonString:String) -> JSON {
        do {
            if let data:Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false){
                if jsonString != "error" {
                    let jsonResult:JSON = JSON(data: data)
                    return jsonResult
                }
            }
        }
        catch _ as NSError {
            
        }
        
        return nil
    }
    // end
}





