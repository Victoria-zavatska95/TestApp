//
//  DetailedDescriptionForPointViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 4/3/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReachabilitySwift

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
    
    
    @IBOutlet weak var deleteCharge: UIButton!
    
    let reachability = Reachability()!
    
    
    var spotId: String = ""
    var adress: String = ""
    var spotArray: [String:String] = [:]
    var arrayWithDetailedDescription: [String:String] = [:]
    var identifierOfRequestSentFromDetailedView: String = ""
    
    @IBOutlet weak var sendRequestButton: UIButton!
    
    var currentUser = UserDefaults.standard
    
    @IBOutlet weak var cancelRequestButton: UIButton!
    
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBarBar: UIToolbar!
    
    let myColor : UIColor = UIColor.white
    
    var variableTableView: PointsDescriptionTableViewController! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.identifierOfRequestSentFromDetailedView = ""
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.cancelRequestButton.layer.borderColor = myColor.cgColor
        self.cancelRequestButton.layer.cornerRadius = 20.0
        self.cancelRequestButton.layer.borderWidth = 2.0
        self.sendRequestButton.layer.borderColor = myColor.cgColor
        self.sendRequestButton.layer.cornerRadius = 20.0
        self.sendRequestButton.layer.borderWidth = 2.0
        self.deleteCharge.layer.cornerRadius = 20.0
        self.deleteCharge.layer.borderWidth = 2.0
        self.deleteCharge.layer.borderColor = myColor.cgColor
        self.titleLabelShow.text = spotArray["name"]
        self.timeLabelShow.text = arrayWithDetailedDescription["duration"]
        self.addressLabelShow.text = spotArray["address"]
        self.addressDetailesShow.text = arrayWithDetailedDescription["addressDetails"]
        self.othersShow.text = arrayWithDetailedDescription["description"]
        self.chargersTypeShow.text = arrayWithDetailedDescription["chargerTypes"]
        if self.titleLabelShow.text == "" {
            self.titleLabelShow.text = "-- : --"
        }
        if self.timeLabelShow.text == "" {
            self.timeLabelShow.text = "-- : --"
        }
        if self.addressLabelShow.text == "" {
            self.addressLabelShow.text = "-- : --"
        }
        if self.addressDetailesShow.text == "" {
            self.addressDetailesShow.text = "-- : --"
        }
        if self.othersShow.text == "" {
            self.othersShow.text = "-- : --"
        }
        if self.chargersTypeShow.text == "" {
            self.chargersTypeShow.text = "-- : --"
        }
                self.deleteCharge.isHidden = false
        if self.currentUser.bool(forKey: "requestWasSent")  {
            self.sendRequestButton.isHidden = true
            self.cancelRequestButton.isHidden = false
            
        }
        if self.currentUser.bool(forKey: "spotCreated") && self.currentUser.string(forKey: "plugIdSetWhenCreated")! != self.spotId {
            self.sendRequestButton.isHidden = true
            self.cancelRequestButton.isHidden = true
            self.deleteCharge.isHidden = true
        }
        if self.currentUser.bool(forKey: "spotCreated") && self.currentUser.string(forKey: "plugIdSetWhenCreated")! == self.spotId {
            self.sendRequestButton.isHidden = true
            self.cancelRequestButton.isHidden = true
            self.deleteCharge.isHidden = false
        }
        
        if !self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated") {
            self.sendRequestButton.isHidden = false
            self.cancelRequestButton.isHidden = true
            self.deleteCharge.isHidden = true
        }
        
        
        if self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated") && self.spotId == self.currentUser.value(forKey: "spotIDWhereRequestWasSent") as! String! {
            self.sendRequestButton.isHidden = true
            self.cancelRequestButton.isHidden = false
            self.deleteCharge.isHidden = true
        }
        if self.currentUser.bool(forKey: "requestWasSent") && !self.currentUser.bool(forKey: "spotCreated") && self.spotId != self.currentUser.value(forKey: "spotIDWhereRequestWasSent") as! String! {
            self.sendRequestButton.isHidden = true
            self.cancelRequestButton.isHidden = true
            self.deleteCharge.isHidden = true
        }
        
    }
    
    
    
    
    // reload table view
    func reloadingTableView(tableView: PointsDescriptionTableViewController){
        if tableView != nil {
            self.variableTableView = tableView
        }
    }
    // end
    
    // delete a charge
    @IBAction func deleteChargeAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().deletePrivareCharge { (response, status, error) in
                if status {
                    Alert().creatingAlert(message: "Your charge was successfully deleted", controller: self)
                    self.sendRequestButton.isHidden = true
                    self.deleteCharge.isHidden = true
                    self.variableTableView.tableView.reloadData()
                }else{
                    Alert().creatingAlert(message: "\(error)", controller: self)
                }
                
            }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
        }
    }
    // end
    
    
    // send a request for charging
    @IBAction func sendRequestAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().postSendRequestForAplug(spotId: self.spotId) { (json, status, statusOfSharing) in
                if status && !statusOfSharing {
                    self.currentUser.set(true, forKey: "requestWasSent")
                    self.currentUser.set(self.spotId, forKey: "spotIDWhereRequestWasSent")
                    self.sendRequestButton.isHidden = true
                    Alert().creatingAlert(message: "Your request was successfully sent", controller: self)
                    self.currentUser.set(true, forKey: "plugIsCreated")
                    self.identifierOfRequestSentFromDetailedView = "Success"
                    self.cancelRequestButton.isHidden = false
                    self.variableTableView.tableView.reloadData()
                    
                }
                if !status && !statusOfSharing {
                    self.sendRequestButton.isHidden = false
                    self.cancelRequestButton.isHidden = true
                    Alert().creatingAlert(message: "You should to complete previous session", controller: self)
                }
                if !status && statusOfSharing {
                    Alert().creatingAlert(message: "You cannot host yourself", controller: self)
                    self.sendRequestButton.isHidden = true
                    self.cancelRequestButton.isHidden = true
                }
            }
            self.reloadInputViews()
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
            
        }
    }
    // end
    
    
    // cancel the request for charging
    @IBAction func cancelAction(_ sender: Any) {
        if !self.currentUser.bool(forKey: "requestWasSent") {
            Alert().creatingAlert(message: "The request was not send. Please send the request first", controller: RequestForAuthorizationViewController())
        }
        if self.currentUser.bool(forKey: "requestWasSent") {
            if self.reachability.isReachable {
                PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation { (json, status) in
                    if status {
                        self.sendRequestButton.isHidden = false
                        self.cancelRequestButton.isHidden = true
                        Alert().creatingAlert(message: "Your request was successfully cancelled", controller: self)
                        
                    } else {
                        self.sendRequestButton.isHidden = true
                        self.cancelRequestButton.isHidden = false
                        Alert().creatingAlert(message: "Your request was not cancelled", controller: self)
                    }
                }
                self.reloadInputViews()
                
            } else {
                Alert().creatingAlert(message: "No Internet Connection", controller: self)
                
            }
        }
    }
    // end
    
    
    
    
    // prepare for segue to FindPlugPointsDescriptionTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFindPlugPointsDescriptionTableViewController" && self.identifierOfRequestSentFromDetailedView == "Success" {
            let destination = segue.destination as! PointsDescriptionTableViewController
            destination.identifier = self.identifierOfRequestSentFromDetailedView
            destination.spotIDfromDetailed = self.spotId
        }
        if segue.identifier == "toFindPlugPointsDescriptionTableViewController" && self.identifierOfRequestSentFromDetailedView == "" {
            let destination = segue.destination as! PointsDescriptionTableViewController
            destination.spotIDfromDetailed = self.spotId
        }
    }
    // end
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
