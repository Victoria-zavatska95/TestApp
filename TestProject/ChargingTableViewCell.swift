//
//  ChargingTableViewCell.swift
//  TestProject
//
//  Created by Azinec LLC on 3/28/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

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
    
    
    
    
    override func awakeFromNib() {
        designSet()
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUp(title: String, distance: String, address: String) {
    self.titleLabel.adjustsFontSizeToFitWidth = true
    self.titleLabel.text = title
    self.titleWithDistanceLabel.text = distance
        self.addressLabel.text = address
}
    
    @IBAction func sendRequestAction(_ sender: Any) {
    PrivateSpotsRequest().postSendRequestForAplug(spotId: self.spotID) { (json, status) in
        if status == true {
            self.sendRequestButton.isHidden == true
            self.cancelRequest.isHidden == false
        }else{
            Alert().creatingAlert(message: "Your request was failed", controller: RequestForAuthorizationViewController())
        }
        print(json.debugDescription)
        }
    }
    
    
    

    
    
    func designSet() {
        self.viewForImage.layer.cornerRadius = 35.0
        self.viewForImage.layer.borderWidth = 2.0
        self.viewForImage.layer.borderColor = myColor.cgColor
        self.viewForPortrait.layer.cornerRadius = 35.0
        self.sendRequestButton.frame = CGRect(x: 103 , y: 5, width: 264, height: 65)
        self.sendRequestButton.layer.borderColor = myColor.cgColor
        self.sendRequestButton.layer.cornerRadius = 32.5
        self.sendRequestButton.layer.borderWidth = 2.0
        self.cancelRequest.frame = CGRect(x: 103 , y: 80, width: 264, height: 65)
        self.cancelRequest.layer.borderColor = myColor.cgColor
        self.cancelRequest.layer.cornerRadius = 32.5
        self.cancelRequest.layer.borderWidth = 2.0
           self.viewForPortrait.layer.masksToBounds = true
self.titleWithDistanceLabel.adjustsFontSizeToFitWidth = true
        self.addressLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    @IBAction func cancelRequestAction(_ sender: Any) {
        if !self.currentUser.bool(forKey: "requestWasSent") {
        Alert().creatingAlert(message: "The request was not send. Please send the request first", controller: RequestForAuthorizationViewController())
        }
        if self.currentUser.bool(forKey: "requestWasSent") {
        PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation { (json, status) in
            if status == true {
                self.sendRequestButton.isHidden == false
                self.cancelRequest.isHidden == true
            }else{
                Alert().creatingAlert(message: "Cancelling the request was failed", controller: RequestForAuthorizationViewController())
            }
                       }
            
        }
    
    
    
    
}
}

