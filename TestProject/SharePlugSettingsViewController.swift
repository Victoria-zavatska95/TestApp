//
//  SharePlugSettingsViewController.swift
//  TestApplication
//
//  Created by AzinecLLC on 4/10/17.
//  Copyright © 2017 AzinecLLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class SharePlugSettingsViewController: UIViewController {
let currentUser = UserDefaults.standard
    

    
    let myColor : UIColor = UIColor.white
    
    @IBOutlet weak var plugNameTextfield: UITextField!

    @IBOutlet weak var addressNameTextfield: UITextField!
    
    @IBOutlet weak var chargersTypeTextfield: UITextField!
    
    
    @IBOutlet weak var maximumChargingTimeTextfield: UITextField!
   
    @IBOutlet weak var descriptionAddressTextfield: UITextField!
    
    @IBOutlet weak var detailsTextfield: UITextField!
    
    
    @IBOutlet weak var savePlugButton: UIButton!
    
    var params : [String : String] = [:]
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   self.savePlugButton.layer.cornerRadius = 25.0
        self.savePlugButton.layer.borderWidth = 2.0
        self.savePlugButton.layer.borderColor = myColor.cgColor
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

    @IBAction func savePlugAction(_ sender: Any) {
        if plugNameTextfield.text?.isEmpty == true || addressNameTextfield.text?.isEmpty == true || chargersTypeTextfield.text?.isEmpty == true || maximumChargingTimeTextfield.text?.isEmpty == true || descriptionAddressTextfield.text?.isEmpty == true || detailsTextfield.text?.isEmpty == true {
            self.errorLabel.text = "All textfields should be fulfilled"
        }else{
        PrivateSpotsRequest().postCreatePrivareCharge(spotName: self.plugNameTextfield.text!, chargingTime: self.maximumChargingTimeTextfield.text!, address: self.addressNameTextfield.text!, addressDetail: self.descriptionAddressTextfield.text!, description: self.detailsTextfield.text!) { (response, status, paramsList) in
            if status == true {
                self.params = paramsList
                self.currentUser.set(response, forKey: "spotCreatedByUser")
                self.errorLabel.text = "Your plug was sucessfully created"

            }
            }
        }
    }
    
    
    
    
        

    
    
}
