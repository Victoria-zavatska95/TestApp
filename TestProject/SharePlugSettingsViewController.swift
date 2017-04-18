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
    
    @IBOutlet weak var createSpotButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    name : String,
    //    geoCoords : Number,
    //    userId : ObjectId
    //    chargerType : [{type: ObjectId, ref: 'ChargerType' }], status : Boolean,
    //    address : String,
    //    addressDetails : String,
    //    description : String,
    //    duration : Number (Seconds),
    //    condition : String,
    //   
    
    
    
//    let paramsList:[String:String] = [
    //        "name": spotName,
    //        "duration": APPRequest().getDataFromLocalTable("availableTime\(plugOwnerId)"),
    //        "description": APPRequest().getDataFromLocalTable("chargingConditions\(plugOwnerId)"),
    //        "address": APPRequest().getDataFromLocalTable("sharePlugAddress\(plugOwnerId)"),
    //        "addressDetail": APPRequest().getDataFromLocalTable("sharePlugAddressDetais\(plugOwnerId)"),
    //        "location[0]":userLat,
    //        "location[1]":userLong
    //    ]
    
   
    let params : [String : String] = [
        "name": "FirstSa",
                "duration": "50",
                "description": "descriptionSa",
                "address": "addressSa",
                "addressDetail": "addressDetailSa",
                "location[0]":"48.6092829",
                "location[1]":"22.3006987"

    ]
    
//    self.currentUser.set(userid, forKey: "userid")
    
    
    @IBAction func createSpotAction(_ sender: Any) {
HelperAlamofires().postCreatePrivateChargerPoint(params: self.params, hostId: currentUser.string(forKey: "userid")!) { (status, responenseJson) in
    print("111")
        }
    }
        
        

    
    
}
