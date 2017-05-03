//
//  ChargingTableViewCell.swift
//  TestProject
//
//  Created by Azinec LLC on 3/28/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ChargingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleWithDistanceLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    var spotID: String = ""
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var sendRequestButton: UIButton!
    
    @IBOutlet weak var cancelRequest: UIButton!
    
    @IBOutlet weak var viewForImage: UIView!
    
    @IBOutlet weak var viewForPortrait: UIImageView!
    
    var currentUser = UserDefaults.standard
    
    let myColor : UIColor = UIColor.green
    
    var variableTableView: PointsDescriptionTableViewController! = nil
    
    var identifier: String = ""
    let reachability = Reachability()!
    
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideCancel), name: NSNotification.Name(rawValue: "hideCancel"), object: nil)
        
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // set up the information from the Table View Controller (PointsDescriptionTableViewController)
    func setUp(title: String, distance: String, address: String, tableView: PointsDescriptionTableViewController! = nil) {
        if tableView != nil {
            self.variableTableView = tableView
        }
        
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.text = title
        self.titleWithDistanceLabel.text = distance
        self.addressLabel.text = address
        self.sendRequestButton.isHidden = false
        self.cancelRequest.isHidden = true
        if self.currentUser.value(forKey: "pictureURL") == nil || self.currentUser.object(forKey: "pictureURL") == nil || self.currentUser.string(forKey: "pictureURL") == nil {
            self.viewForPortrait.image = UIImage(named: "davidbeckham")
        }else {
            var pictureString: String = self.currentUser.string(forKey: "pictureURL")!
            if let imageData: NSData = NSData(contentsOf: URL(string: pictureString)!) {
                self.viewForPortrait.image = UIImage(data: imageData as Data)
            }
        }
        designSet()
    }
    // end
    
    
    func hideCancel() {
        self.cancelRequest.isHidden = true
        self.sendRequestButton.isHidden = true
    }
    
    // send request for charging
    @IBAction func sendRequestAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().postSendRequestForAplug(spotId: self.spotID) { (json, status, statusOfSharing) in
                if status && !statusOfSharing {
                    self.identifier = self.spotID
                    self.currentUser.set(self.spotID, forKey: "spotIDWhereRequestWasSent")
                    self.sendRequestButton.isHidden = true
                    self.cancelRequest.isHidden = false
                    self.variableTableView.tableView.reloadData()
                    
                }
                if !status && !statusOfSharing {
                    Alert().creatingAlert(message: "You should to complete the previous session", controller: self.variableTableView)
                }
                if !status && statusOfSharing {
                    Alert().creatingAlert(message: "You can't host yourself", controller: self.variableTableView)
                    self.sendRequestButton.isHidden = true
                    self.cancelRequest.isHidden = true
                }
                
                
            }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self.variableTableView)
        }
        
    }
    // end
    
    
    // set design for PointsDescriptionTableViewController
    func designSet() {
        self.viewForImage.layer.cornerRadius = 35.0
        self.viewForImage.layer.borderWidth = 2.0
        self.viewForImage.layer.borderColor = myColor.cgColor
        self.viewForPortrait.layer.cornerRadius = 35.0
        self.sendRequestButton.frame = CGRect(x: 103 , y: 5, width: 264, height: 65)
        self.sendRequestButton.layer.borderColor = myColor.cgColor
        self.sendRequestButton.layer.cornerRadius = 27.5
        self.sendRequestButton.layer.borderWidth = 2.0
        self.cancelRequest.frame = CGRect(x: 103 , y: 80, width: 264, height: 65)
        self.cancelRequest.layer.borderColor = myColor.cgColor
        self.cancelRequest.layer.cornerRadius = 27.5
        self.cancelRequest.layer.borderWidth = 2.0
        self.viewForPortrait.layer.masksToBounds = true
        self.titleWithDistanceLabel.adjustsFontSizeToFitWidth = true
        self.addressLabel.adjustsFontSizeToFitWidth = true
        
    }
    // end
    
    
    // cancel request
    @IBAction func cancelRequestAction(_ sender: Any) {
        if !self.currentUser.bool(forKey: "requestWasSent") {
            Alert().creatingAlert(message: "The request was not send. Please send the request first", controller: RequestForAuthorizationViewController())
        }
        if self.currentUser.bool(forKey: "requestWasSent") {
            if self.reachability.isReachable {
                PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation { (json, status) in
                    if status {
                        self.identifier = self.spotID
                        self.cancelRequest.isHidden = true
                        self.variableTableView.tableView.reloadData()
                        
                    }else{
                        Alert().creatingAlert(message: "Cancelling the request was failed", controller: self.variableTableView)
                        
                    }
                }
                
                
            } else {
                Alert().creatingAlert(message: "No Internet Connection", controller: self.variableTableView)
            }
            
        }
        // end
        
        
    }
}


