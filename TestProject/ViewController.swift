//  ViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 3/21/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
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

    
    @IBOutlet weak var viewForFrame: UIView!
    
    
    
    override func viewDidLoad() {
        self.errorLabel.isHidden = true
        if self.currentUser.bool(forKey: "isRegistered") {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowLoginizationView", sender: self)
            }
        }
        super.viewDidLoad()
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "forFrameViewTapped")
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
    }
    
    
    @IBAction func logInBarAction(_ sender: Any) {
        if self.currentUser.bool(forKey: "isRegistered") {
        self.performSegue(withIdentifier: "ShowLoginizationView", sender: self.logInBar)
    }
    }
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.nameLabel.isHidden = true
        self.userNameLabel.isHidden = true
        self.emailLabelSecond.isHidden = true
        self.passwordLabel.isHidden = true
    }
    
    
    @IBAction func registrationAction(_ sender: Any) {
        ValidationChecking().checkingForRegistration(nameTextField.text!, userNameTextField.text!, userNameLabel, emailTextfield.text!, emailLabelSecond, nameLabel, passwordTextfield.text!, passwordLabel) { (name, userName, password, email, parameters) in
          
            if parameters.count == 0 {
            self.nameLabel.text = name
                self.userNameLabel.text = userName
            self.passwordLabel.text = password
            self.emailLabelSecond.text = email
                self.errorLabel.text! = "Data is incorrect"
        } else {
                 self.parameters = parameters as! [String : String]
                print(self.parameters)
                ValidationChecking().registerUser(parameters: self.parameters, password: self.passwordTextfield.text!, userName: self.userNameTextField.text!, completion: { (status, json, error) in
                    if status == true {
                        self.currentUser.set(true, forKey: "isRegistered")
                        self.performSegue(withIdentifier: "ShowLoginizationView", sender: self)
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

    }

}
