//
//  SharePlugSettingsViewController.swift
//  TestApplication
//
//  Created by AzinecLLC on 4/10/17.
//  Copyright © 2017 AzinecLLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReachabilitySwift
import CoreLocation

class SharePlugSettingsViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
let currentUser = UserDefaults.standard
    let locationManager = CLLocationManager()

    
    let myColor : UIColor = UIColor.white
    
    @IBOutlet weak var plugNameTextfield: UITextField!

    @IBOutlet weak var addressNameTextfield: UITextField!
    
    
    @IBOutlet weak var maximumChargingTimeTextfield: UITextField!
   
    @IBOutlet weak var descriptionAddressTextfield: UITextField!
    
    @IBOutlet weak var detailsTextfield: UITextField!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var savePlugButton: UIButton!
    
    var params : [String : String] = [:]
    

    var timeOptional: Int? = 0
    
    @IBOutlet weak var viewForFrame: UIView!
     let reachability = Reachability()!
    
    @IBOutlet weak var findAddressButton: UIButton!
var userCoordinate2D = CLLocationCoordinate2D()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
   self.savePlugButton.layer.cornerRadius = 7.5
        self.savePlugButton.layer.borderWidth = 1.0
        self.savePlugButton.layer.borderColor = myColor.cgColor
  self.clearButton.layer.borderColor = myColor.cgColor
        self.clearButton.layer.cornerRadius = 7.5
        self.clearButton.layer.borderWidth = 1.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SharePlugSettingsViewController.forFrameViewTapped))
        self.viewForFrame.addGestureRecognizer(tapGesture)
        self.findAddressButton.layer.cornerRadius = 7.5
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        

        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestAlwaysAuthorization()
            
        }
            
        else if CLLocationManager.authorizationStatus() == .denied {
            Alert().creatingAlert(message: "If you deny authorization, you will be not able to find or share a spot", controller: self)
        }
            
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        

    }

    @IBAction func findMyLocationAction(_ sender: Any) {
    AdditionalSharePlug().findMyAddress(self.userCoordinate2D) { (address) in
        self.addressNameTextfield.text! = address
        }
        }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // to clear Textfields
    @IBAction func clearAction(_ sender: Any) {
        plugNameTextfield.text = ""
        addressNameTextfield.text = ""
              maximumChargingTimeTextfield.text = ""
        descriptionAddressTextfield.text = ""
        detailsTextfield.text = ""
        
    }
    // end

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userCoordinate2D = (manager.location?.coordinate)!
        self.locationManager.stopUpdatingLocation()
    }
    
    // to save plug
    @IBAction func savePlugAction(_ sender: Any) {
        self.params = AdditionalSharePlug().sharePlugChecking(self.plugNameTextfield.text!, addressNameTextfield.text!,  self.maximumChargingTimeTextfield.text!, descriptionAddressTextfield.text!, detailsTextfield.text!)
                 if self.reachability.isReachable {
        PrivateSpotsRequest().postCreatePrivareCharge(parameters: self.params) { (response, status, paramsList, error) in
            if status {
                self.params = paramsList
                Alert().creatingAlert(message: "Your plug was sucessfully created", controller: self)
                

            }
            if !status {
                Alert().creatingAlert(message: error, controller: self)
            }
                    }
                 } else {
                     Alert().creatingAlert(message: "No Internet Connection", controller: self)
                }
    }
    
    // end
    
    
    
    // set up the view for TapGestureRecognizer
    func forFrameViewTapped() {
        self.view.endEditing(true)
    }
    // end
    
    
    
    }

