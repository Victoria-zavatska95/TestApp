//  RequestForAuthorizationViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 3/28/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import CoreLocation
import ReachabilitySwift

class RequestForAuthorizationViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var button: UIButton!
    
    var currentUser = UserDefaults.standard
    
    
    @IBOutlet weak var findPlugButton: UIButton!
    
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var cancelRequestButton: UIButton!
    var spotownerId: String = ""
    
    @IBOutlet weak var deleteButton: UIButton!
    let reachability = Reachability()!
     let locationManager = CLLocationManager()
    
    var coordLongitude: CLLocationDegrees = 0.0
    
    var coordLatitude: CLLocationDegrees = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        cancelRequestButton.isHidden = true
        findPlugButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        findPlugButton.layer.borderWidth = 1.0
        findPlugButton.layer.cornerRadius = 35.0
        shareButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        shareButton.layer.borderWidth = 1.0
        shareButton.layer.cornerRadius = 35.0
        cancelRequestButton.layer.borderWidth = 1.0
        cancelRequestButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        cancelRequestButton.layer.cornerRadius = 35.0
        self.deleteButton.isHidden = true
        self.deleteButton.layer.cornerRadius = 35.0
        self.deleteButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        self.deleteButton.layer.borderWidth = 1.0
        
    }
    
    // cancel request
    @IBAction func cancelAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation { (json, status) in
                if status {
                    self.findPlugButton.isEnabled = true
                    self.cancelRequestButton.isHidden = true
                }
            }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
        }
    }
    // end
    
    
    // delete spot
    
    @IBAction func deleteAction(_ sender: Any) {
        if self.reachability.isReachable {
            PrivateSpotsRequest().deletePrivareCharge { (response, status, error) in
                if status {
                    Alert().creatingAlert(message: "Your charge was successfully deleted", controller: self)
                    self.deleteButton.isHidden = true
                    self.shareButton.isEnabled = true
                }else{
                    Alert().creatingAlert(message: "\(error)", controller: self)
                }
                
            }
            
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
        }
    }
    // end
    
    
    
    // find plug
    @IBAction func findAction(_ sender: Any) {
        if self.currentUser.object(forKey: "userLatitude") != nil && self.currentUser.object(forKey: "userLongitude") != nil {
            self.performSegue(withIdentifier: "toPointsdescriptionTableViewController", sender: self)
        }else{
            Alert().AlertToAllowNotifications(text: "To find a plug, you should allow geolocation usage by the program", controller: self)
        }
    }
    // end
    
    
    // share plug
    @IBAction func shareAction(_ sender: Any) {
        if self.currentUser.bool(forKey: "requestWasSent") {
            Alert().creatingAlert(message: "You cannot share a plug if you have already sent the request for charging. Please cancel the request first", controller: self)
            self.cancelRequestButton.isHidden = false
            self.findPlugButton.isEnabled = false
        }
        if self.currentUser.object(forKey: "userLatitude") == nil && self.currentUser.object(forKey: "userLongitude") == nil {
  Alert().AlertToAllowNotifications(text: "To share a plug, you should allow geolocation usage by the application", controller: self)
            
        }
        if self.currentUser.bool(forKey: "spotCreated") {
            self.spotownerId = "\(self.currentUser.value(forKey: "spotOwnerId")!)"
            if self.spotownerId == "\(self.currentUser.value(forKey: "userId")!)" {
                self.shareButton.isEnabled = false
                self.deleteButton.isHidden = false
                Alert().creatingAlert(message: "You cannot share the plug because you have already created one. If you wish to create another plug, please delete the previous one", controller: self)
                           }
            
        } else {
            self.performSegue(withIdentifier: "toSharePlugViewController", sender: self)
        }
    }
    // end
    
    
    // update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.coordLongitude = (manager.location?.coordinate.longitude)!
        
        self.coordLatitude = (manager.location?.coordinate.latitude)!
        self.currentUser.set(Double(self.coordLatitude), forKey: "userLatitude")
        self.currentUser.set(Double(self.coordLongitude), forKey: "userLongitude")
        self.locationManager.stopUpdatingLocation()
    }
    // end
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
