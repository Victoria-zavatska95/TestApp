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
    
    
    func checkingForRegistration(_ name: String, _ userName: String, _ userLabel: UILabel, _ email: String, _ emaillabel: UILabel, _ namelabel: UILabel, _ password: String, _ passwordlabel: UILabel, completitionHandler:@escaping (_ nameForDestination: String, _ userNameForDestination: String, _ passwordFor: String, _ emailFor: String, _ parameters: Parameters) -> Void) {
        
        var nameForDestination: String = ""
        var emailFor: String = ""
        var passwordFor: String = ""
        var userNameFoorDestination: String = ""
        var parameters: [String:String] = [:]
        
        
        
        if (name.characters.count) < 5 {
            namelabel.isHidden = false
            nameForDestination = "Name should contain atleast 5 letters"
        }
        
        if (userName.characters.count) < 5 {
            userLabel.isHidden = false
            userNameFoorDestination = "Username should contain atleast 5 letters"
        }
        if (name.characters.count) < 5 && self.isValidEmail(testStr: email) == false {
            namelabel.isHidden = false
            nameForDestination = "Name should contain atleast 5 letters"
            emaillabel.isHidden = false
            emailFor = "email is invalid"
            
        }
        
        if (password.characters.count) < 8 && self.validate(password: password) == true {
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain atleast 8 symbols including atleast 1 number"
            emaillabel.isHidden = false
            emailFor = "email is invalid"
            
        }
        
        if (name.characters.count) < 5 && (password.characters.count) < 8 {
            namelabel.isHidden = false
            nameForDestination = "Name should contain atleast 5 letters"
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain atleast 8 symbols including atleast 1 number"
            
        }
        
        if (name.characters.count) < 5 && (password.characters.count) < 8 && self.isValidEmail(testStr: email) == false {
            namelabel.isHidden = false
            nameForDestination = "Name should contain atleast 5 letters"
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain atleast 8 symbols including atleast 1 number"
            emaillabel.isHidden = false
            emailFor = "email is invalid"
        }
        
        
        
        if self.isValidEmail(testStr: email) == false {
            emaillabel.isHidden = false
            emailFor = "email is invalid"
        }
        
        if password.characters.count < 8 || self.validate(password: password) == false {
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain atleast 8 symbols including atleast 1 number"
        }
        
        if name.characters.count > 5 && userName.characters.count > 5 && password.characters.count > 8 && isValidEmail(testStr: email) == true && self.validate(password: password) == true {
            print(self.validate(password: password))
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
    
    
    
    func createTokenForManual(userName:String, password:String, deviceSignature:String)->String {
        
        let token:String = JWT.encode(.hs512("secret".data(using: .utf8)!)) { (builder) in
            builder["userName"]        = userName
            builder["password"]        = password
            builder["deviceSignature"] = deviceSignature

        }
       
        currentUser.set(token, forKey: "userToken")
        return token
    }
    
    
    func checkingForLoginization(_ name: String, _ namelabel: UILabel, _ password: String, _ passwordlabel: UILabel, completitionHandler:@escaping (_ nameForDestination: String, _ passwordFor: String, _ parameters: [String:String]) -> Void) {
        var nameForDestination: String = ""
        var passwordFor: String = ""
        var parameters: [String:String] = [:]
        
        
        if (name.characters.count) < 5 {
            namelabel.isHidden = false
            nameForDestination = "Name should contain atleast 8 symbols"
        }
        
        
        
        if (password.characters.count) < 8 || self.validate(password: password) == false {
            passwordlabel.isHidden = false
            passwordFor = "Your password should contain atleast 8 symbols including atleast 1 number"
        }
        
        
        
        if (password.characters.count) > 8 && name.characters.count > 5  && self.validate(password: password) == true {
            print(self.currentUser.value(forKey: "DeviceToken"))
            createTokenForManual(userName: name, password: password, deviceSignature: String(describing: self.currentUser.value(forKey: "DeviceToken")!)
)
            parameters = ["token" : currentUser.value(forKey: "userToken") as! String]
        }
        completitionHandler(nameForDestination, passwordFor, parameters)
        
    }
    
    
    
    
    func validate(password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Za-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else { return false }

        
        return true
    }
    
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    
    
    func registerUser(parameters: [String : String], password: String, userName: String, completion: @escaping (_ status: Bool, _ result: JSON, _ descriptionOfError: String) -> Void) {
        print(parameters)
        var descriptionofError: String = ""
        url = "http://188.166.110.248:"
        port = "3010/v1/users"
        var sum = "\(url)\(port)"
        print(sum)
           Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
            let result: JSON = JSON(response.data)
            print(result.debugDescription)
            if result["description"].stringValue == "Created" {
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
                print(descriptionofError)
                           }
    }
    }

    func loginUser(parameters: [String:String], completion: @escaping (_ status: Bool, _ result: JSON, _ descriptionOfError: String) -> Void) {
        url = "http://188.166.110.248:"
        port = "3010/v1/users/login/manual"
var descriptionofError: String = ""
        Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
            var result: JSON = JSON(response.data)
            print(result.debugDescription)
            if result["error"].stringValue == "Incorrect password" {
               descriptionofError = "Your password is incorrect"
                 completion(false, result, descriptionofError)
            }

            if result["error"].stringValue == "Account doesn't exist" {
                 descriptionofError = "Such username doesn't exist"
                completion(false, result, descriptionofError)
                } else {
//                self.currentUser.set(result, forKey: "userArray")
                print(result.debugDescription)
                completion(true, result, "")
                         }
        }
    }

    
    
    func warning(warningLabel : UILabel, warningLabelText : String){
        warningLabel.text = warningLabelText
        warningLabel.alpha = 100
        warningLabel.isHidden = false
        UIView.animate(withDuration: 7) {
            warningLabel.alpha = 0
        
    }
}

}

