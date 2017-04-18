//
//  PointsDescriptionTableViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 3/23/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
class PointsDescriptionTableViewController: UITableViewController, CLLocationManagerDelegate {
//    let arrayOfPoints = [["latitude": 48.670457300000002, "longitude": 22.294567799999999], ["latitude": 48.609347300000003, "longitude": 22.321566499999999], ["latitude": 48.6146618, "longitude": 22.2937966]]
    
    var coordLongitudeForDestination: CLLocationDegrees = 0.0
    
    var coordLatitudeForDestination: CLLocationDegrees = 0.0
    var distance: String = ""
    
    var arrayOfDistances: [Double] = []
    var arrayOfKmInString: [String] = []
    var result: JSON = []
    var stringSome: String = ""
    //
    let locationManager = CLLocationManager()
    
    var coordLongitude: CLLocationDegrees = 0.0
    
    var coordLatitude: CLLocationDegrees = 0.0
    var index: Int = 0
    var indexForDestination: Int = 0
    var minElement: Double = 0.0
    var addressArray: [String] = []
    var currentUser = UserDefaults.standard
    var arrayForFirstSpot: [String:Double] = [:]
    var arrayForSpots: [[String:Double]] = [[:]]
    
    @IBOutlet weak var SettingsButton: UIBarButtonItem!
    
    
    @IBOutlet weak var cancellButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrayForSpots.remove(at: 0)
        PrivateSpotsRequest().getPrivateSpotList { (response) in
            print(response["data"].count)
            for i in 0..<response["data"].count {
                var k = response["data"][i]["location"][1].stringValue
                print(k)
                
                self.arrayForFirstSpot = ["latitude": Double(response["data"][i]["location"][0].stringValue)!, "longitude": Double(response["data"][i]["location"][1].stringValue)!]
                self.arrayForSpots.insert(self.arrayForFirstSpot, at: i)
                
                
            }
            print(self.arrayForSpots.count)
            //            var longitudeFirst = response["data"][0]["location"][1].stringValue
            //            for item in response {
            //            arrayOfPoints.append(item)
            //        }
            //print(latitideFirst)
            //            print(longitudeFirst)
        }
        
        

            }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        
        GoogleAPIRequest().requestToGoogle(self.coordLatitudeForDestination, self.coordLongitudeForDestination, self.arrayForSpots) { (json, kmArray, distancesArray, addressArray) in
            self.arrayOfKmInString = kmArray
            self.arrayOfDistances = distancesArray
            self.addressArray = addressArray
            print("self.addressArray\(self.addressArray)")
            self.tableView.reloadData()
            print(self.arrayOfDistances.count)
            if self.arrayOfDistances.count == self.arrayForSpots.count {
                self.minElement = self.arrayOfDistances.min()!
                for item in self.arrayOfDistances {
                    if item == self.minElement {
                        self.index = self.arrayOfDistances.index(of: item)!
                    }
                }
                var oldElementValue = self.arrayOfKmInString[0]
                self.arrayOfKmInString[0] = self.arrayOfKmInString[self.index]
                self.arrayOfKmInString[self.index] = oldElementValue
                
                
            }
            
        }
        
    }
    
    
    @IBAction func buttonSettingsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toSettingsViewController", sender: self)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        return self.arrayOfPoints.count
        return self.arrayForSpots.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

            let cell = tableView.dequeueReusableCell(withIdentifier: "chargingDevice", for: indexPath) as! ChargingTableViewCell
        print(self.arrayOfKmInString.count)
        print(self.arrayForSpots.count)
         if self.arrayOfKmInString.count == 2  && self.arrayOfKmInString.count == self.arrayForSpots.count {

                    cell.setUp(title: String(indexPath.row), distance: self.arrayOfKmInString[indexPath.row])
        }
        self.tableView.reloadData()
                return cell

    }
    
    
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexForDestination = indexPath.row
        print(self.addressArray[self.indexForDestination])
        if self.addressArray[self.indexForDestination] != nil {
            self.performSegue(withIdentifier: "toDetailedDescriptionViewController", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedDescriptionViewController" {
        let destination = segue.destination as! DetailedDescriptionForPointViewController
//            destination.titleLabel.text =
            destination.adress = self.addressArray[self.indexForDestination]
//            destination.typeOfChargers.text =
//            destination.maximumChargingTime.text =
//            destination.addressDescription.text =
//            destination.otherDesciption.text =
    self.currentUser.set(Double(self.arrayOfDistances[self.indexForDestination]), forKey: "distance")
        }
    }
    
    
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
