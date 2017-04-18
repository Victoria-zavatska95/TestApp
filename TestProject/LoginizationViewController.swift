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

class LoginizationViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
var currentUser = UserDefaults.standard
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var loginizationButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
   
  
    @IBOutlet weak var passwordLabel: UILabel!
    
    var parameters: [String:String] = [:]
    

    @IBOutlet weak var viewForFrame: UIView!
    
    
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.isHidden = true
        var tapGesture = UITapGestureRecognizer(target: self, action: "forFrameViewTapped")
        self.viewForFrame.addGestureRecognizer(tapGesture)
    
    passwordConfirmTextField.delegate = self
          self.username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.white])
         self.passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        if self.currentUser.bool(forKey: "isLogined") {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toRequesrForAuthorization", sender: self)
            }

           }
    }
 

    
    @IBAction func loginizationAction(_ sender: Any) {
        
             ValidationChecking().checkingForLoginization(username.text!, usernameLabel, passwordConfirmTextField.text!, passwordLabel) { (userLabel, passwordlabel, parameters) in
                
                if parameters.isEmpty == true {
                self.usernameLabel.text = userLabel
                self.passwordLabel.text = passwordlabel
                
        } else {
               self.parameters = parameters
                    ValidationChecking().loginUser(parameters: parameters, completion: { (status, response, error) in
                        if status == true {
                            print(response.debugDescription)
                            self.currentUser.set(response["data"]["_id"].stringValue, forKey: "userId")
                            print(response["data"]["_id"].stringValue)
                        self.currentUser.set(true, forKey: "isLogined")
                            self.performSegue(withIdentifier: "toRequesrForAuthorizationSecond", sender: self)
                        } else {
                            ValidationChecking().warning(warningLabel: self.errorLabel, warningLabelText: error)
                        }
                    })
                    
                }

    }
    }




func forFrameViewTapped() {
    self.view.endEditing(true)
}



    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
