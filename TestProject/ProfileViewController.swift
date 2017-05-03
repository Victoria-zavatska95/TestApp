//
//  ProfileViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 4/18/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON


class ProfileViewController: UIViewController {
    var currentUser = UserDefaults.standard
    
    @IBOutlet weak var plugNameLabel: UILabel!
    
    @IBOutlet weak var maximumTimelabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var viewRight: UIView!
    
    
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var userLabel: UILabel!
    
    
    @IBOutlet weak var viewForPortrait: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    var spotownerId: String = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.currentUser.value(forKey: "pictureURL") == nil || self.currentUser.object(forKey: "pictureURL") == nil || self.currentUser.string(forKey: "pictureURL") == nil {
            self.profilePicture.image = UIImage(named: "davidbeckham")
        } else {
            var pictureString: String = self.currentUser.string(forKey: "pictureURL")!
            if let imageData: NSData = NSData(contentsOf: URL(string: pictureString)!) {
                self.profilePicture.image = UIImage(data: imageData as Data)
            }
        }
        if self.currentUser.string(forKey: "userArray") != nil {
            let userArray: String = self.currentUser.string(forKey: "userArray")!
            let jsonFromUserArray: JSON = ValidationChecking().stringToJSON(userArray)
            self.userLabel.text = jsonFromUserArray["data"]["firstName"].stringValue
            self.emailLabel.text = jsonFromUserArray["data"]["email"].stringValue
            if self.currentUser.object(forKey: "spotOwnerId") != nil &&  self.currentUser.bool(forKey: "spotCreated") {
                self.spotownerId = "\(self.currentUser.value(forKey: "spotOwnerId")!)"
                if self.spotownerId == "\(self.currentUser.value(forKey: "userId")!)" {
                    self.plugNameLabel.text = "\(self.currentUser.value(forKey: "plugNameForProfile")!)"
                    self.maximumTimelabel.text = "\(self.currentUser.value(forKey: "maximumTimeProfile")!)"
                    self.addressLabel.text = "\(self.currentUser.value(forKey: "plugAddress")!)"
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewForPortrait.layer.cornerRadius = 49.0
        self.viewForPortrait.layer.borderWidth = 2.0
        self.viewForPortrait.layer.borderColor = UIColor(white: 1, alpha: 0.4).cgColor
        self.profilePicture.layer.cornerRadius = 49.0
        
        self.profilePicture.layer.masksToBounds = true
        self.viewLeft.layer.borderColor = UIColor(white: 1, alpha: 0.4).cgColor
        self.viewRight.layer.borderColor = UIColor(white: 1, alpha: 0.4).cgColor
        self.viewLeft.layer.borderWidth = 1.0
        self.viewRight.layer.borderWidth = 1.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
