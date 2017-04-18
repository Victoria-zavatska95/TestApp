//
//  RequestForAuthorizationViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 3/28/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import CoreLocation
class RequestForAuthorizationViewController: UIViewController, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var button: UIButton!
    let locationManager = CLLocationManager()
    
    var coordLongitude: CLLocationDegrees = 0.0
    
    var coordLatitude: CLLocationDegrees = 0.0
    var currentUser = UserDefaults.standard
  

    @IBOutlet weak var findPlugButton: UIButton!

    
    @IBOutlet weak var shareButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestAlwaysAuthorization()
            
        }
            
        if CLLocationManager.authorizationStatus() == .denied {
            
        }
            
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
                   locationManager.startUpdatingLocation()
        }
// Do any additional setup after loading the view.
        
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        findPlugButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        findPlugButton.layer.borderWidth = 1.0
        findPlugButton.layer.cornerRadius = 35.0
        shareButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        shareButton.layer.borderWidth = 1.0
        shareButton.layer.cornerRadius = 35.0
       
    }
    
    
    

    @IBAction func findAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toPointsdescriptionTableViewController", sender: self)
    }
 
    
  
    @IBAction func shareAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toSharePlugViewController", sender: self)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.coordLongitude = (manager.location?.coordinate.longitude)!
        
        self.coordLatitude = (manager.location?.coordinate.latitude)!
        print("self.coordLatitude \(self.coordLatitude)")
        currentUser.set(self.coordLatitude, forKey: "userLatitude")
        currentUser.set(self.coordLongitude, forKey: "userLongitude")
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPointsdescriptionTableViewController" {
            self.currentUser.set(Double(self.coordLatitude), forKey: "userLatitude")
            self.currentUser.set(Double(self.coordLongitude), forKey: "userLongitude")
           
            PointsDescriptionTableViewController().tableView.reloadData()

            print("self.coordLatitude\(self.coordLatitude)")
            
        }
    }

    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
