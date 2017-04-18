//
//  DetailedDescriptionForPointViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 4/3/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailedDescriptionForPointViewController: UIViewController {

    @IBOutlet weak var addressLabelShow: UILabel!
    @IBOutlet weak var titleLabelShow: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var typeOfChargers: UILabel!
    
    @IBOutlet weak var maximumChargingTime: UILabel!
    
    @IBOutlet weak var addressDescription: UILabel!
    
    @IBOutlet weak var otherDesciption: UILabel!
    
    @IBOutlet weak var chargersTypeShow: UILabel!
    
    
    @IBOutlet weak var timeLabelShow: UILabel!
    
    
    @IBOutlet weak var addressDetailesShow: UILabel!
    
    @IBOutlet weak var othersShow: UILabel!
    
    
    var spotId: String = ""
    var adress: String = ""
    var spotArray: [String:String] = [:]
    var arrayWithDetailedDescription: [String:String] = [:]
    
    @IBOutlet weak var sendRequestButton: UIButton!
    
    var currentUser = UserDefaults.standard
    
    @IBOutlet weak var cancelRequestButton: UIButton!
  
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBarBar: UIToolbar!
    
    let myColor : UIColor = UIColor.white

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         self.navigationController?.hidesBarsOnTap = true
//        // Do any additional setup after loading the view.
//        toolBarBar.isHidden = false
//        toolBarBar.isTranslucent = false
//        settingsButton.isEnabled = true
//        toolBarBar.frame = self.view.bounds
       
    }

    override func viewDidAppear(_ animated: Bool) {
        self.cancelRequestButton.layer.borderColor = myColor.cgColor
        self.cancelRequestButton.layer.cornerRadius = 32.5
        self.cancelRequestButton.layer.borderWidth = 2.0
        self.sendRequestButton.layer.borderColor = myColor.cgColor
        self.sendRequestButton.layer.cornerRadius = 32.5
        self.sendRequestButton.layer.borderWidth = 2.0
        self.titleLabelShow.text = spotArray["name"]
        self.titleLabelShow.text = arrayWithDetailedDescription["duration"]
        self.addressLabelShow.text = spotArray["address"]
        self.addressDetailesShow.text = arrayWithDetailedDescription["addressDetails"]
        self.othersShow.text = arrayWithDetailedDescription["description"]
            self.chargersTypeShow.text = arrayWithDetailedDescription["chargerTypes"]
    }
    
    
    @IBAction func sendRequestAction(_ sender: Any) {
      self.currentUser.set(true, forKey: "requestWasSent")
        PrivateSpotsRequest().postSendRequestForAplug(spotId: self.spotId) { (json, status) in
            if status == true {
            print(json.debugDescription)
            self.currentUser.set(json.arrayValue, forKey: "spotRequest")
                self.sendRequestButton.isHidden == true
                self.cancelRequestButton.isHidden == false
                Alert().creatingAlert(message: "Your request was successfully sent", controller: self)
            } else {
        Alert().creatingAlert(message: "Your request was failed", controller: self)
        }
//
    }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        if !self.currentUser.bool(forKey: "requestWasSent") {
            Alert().creatingAlert(message: "The request was not send. Please send the request first", controller: RequestForAuthorizationViewController())
        }
        if self.currentUser.bool(forKey: "requestWasSent") {
    PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation { (json, status) in
        if status == true {
            self.sendRequestButton.isHidden == false
            self.cancelRequestButton.isHidden == true
            Alert().creatingAlert(message: "Your request was successfully cancelled", controller: self)
        } else {
        print(json.debugDescription)
        Alert().creatingAlert(message: "Your request was not cancelled", controller: self)
        }
    }
    }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFindPlugPointsDescriptionTableViewController" {
//             PointsDescriptionTableViewController().tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
