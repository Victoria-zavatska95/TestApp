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
    func checkingForRegistration(_ name: String, _ userName: String, _ userLabel: UILabel, _ email: String, _ emaillabel: UILabel, _ namelabel: UILabel, _ password: String, _ passwordlabel: UILabel) -> (error :[String : String], parameters : [String : String]) {
        
        var errors: [String:String] = ["name" : "", "username" : "", "email" : "", "password" : ""]
        var parameters: [String:String] = [:]
        
        if name.characters.count < usernameMinimumCharactersCount {
            namelabel.isHidden = false
            errors["name"] = "Name should contain at least 6 letters"
        }
        
        if userName.characters.count < usernameMinimumCharactersCount {
            userLabel.isHidden = false
            errors["username"] = "Username should contain at least 6 letters"
        }

        if !self.isValidEmail(testStr: email) {
            emaillabel.isHidden = false
            errors["email"] = "Email is invalid"
        }

        if password.characters.count < passwordMinimumCharactersCount || !self.validate(password: password){
            passwordlabel.isHidden = false
            errors["password"] = "Your password should contain at least 8 symbols including at least 1 number"
        }
        
        if name.characters.count >= usernameMinimumCharactersCount && userName.characters.count >= usernameMinimumCharactersCount && password.characters.count >= passwordMinimumCharactersCount && isValidEmail(testStr: email) && self.validate(password: password) {
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
        
        
        return (error : errors, parameters : parameters)
    }
    // end

    
    // validate data for loginization before sending a request to server
   
    func checkingForLoginization(_ name: String, _ namelabel: UILabel, _ password: String, _ passwordlabel: UILabel) -> (error : [String : String], parameters : [String : String]) {
        
        var errors: [String:String] = ["name" : "", "password" : ""]
        var parameters: [String:String] = [:]
        
        
        if name.characters.count < usernameMinimumCharactersCount {
            namelabel.isHidden = false
            errors["name"] = "Name should contain at least 6 symbols"
        }
                
        
        if password.characters.count < passwordMinimumCharactersCount || !self.validate(password: password) {
            passwordlabel.isHidden = false
            errors["password"] = "Your password should contain at least 8 symbols including at least 1 number"
        }
        
        
        
        if password.characters.count >= passwordMinimumCharactersCount && name.characters.count >= usernameMinimumCharactersCount  && self.validate(password: password){
            CreateTokens().createTokenForManual(userName: name, password: password, deviceSignature: String(describing: self.currentUser.value(forKey: "DeviceToken")!)
            )
            parameters = ["token" : currentUser.value(forKey: "userToken") as! String]
        }
        
       
        return (error : errors, parameters : parameters) 
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





