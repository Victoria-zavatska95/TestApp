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
import SwiftyJSON
class PointsDescriptionTableViewController: UITableViewController, CLLocationManagerDelegate {
//    let arrayOfPoints = [["latitude": 48.670457300000002, "longitude": 22.294567799999999], ["latitude": 48.609347300000003, "longitude": 22.321566499999999], ["latitude": 48.6146618, "longitude": 22.2937966]]
    
    var coordLongitudeForDestination: Double = 0.0
    
    var coordLatitudeForDestination: Double = 0.0
    var distance: String = ""
    
    var arrayOfDistances: [Double] = []
    var arrayOfKmInString: [String] = []
    var result: JSON = []
    var stringSome: String = ""
    //
    let locationManager = CLLocationManager()
    

    var index: Int = 0
    var indexForDestination: Int = 0
    var minElement: Double = 0.0
    var addressArray: [String] = []
    var currentUser = UserDefaults.standard
    var arrayForFirstSpot: [String:String] = [:]
    var arrayForDetailedDescription : [String:String] = [:]
    var arrayForSpots: [[String:String]] = [[:]]
    var arrayWithSpots: [String] = []
    var dictionaryForDetaileddesciption: [[String:String]] = [[:]]
    var arrayForStringChargersType: [String] = []
    var string: String = ""
    @IBOutlet weak var SettingsButton: UIBarButtonItem!
    
    
    @IBOutlet weak var cancellButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coordLatitudeForDestination = self.currentUser.value(forKey: "userLatitude") as! Double
        self.coordLongitudeForDestination = self.currentUser.value(forKey: "userLongitude") as! Double
        print(self.coordLatitudeForDestination)
        print(self.coordLongitudeForDestination)
                self.arrayForSpots.remove(at: 0)
        PrivateSpotsRequest().getPrivateSpotList { (response) in
            for i in 0..<response["data"].count {
                
                
            
                self.arrayForFirstSpot = ["latitude": response["data"][i]["location"][0].stringValue, "longitude": response["data"][i]["location"][1].stringValue, "address": response["data"][i]["address"].stringValue, "spotId": response["data"][i]["_id"].stringValue, "name": response["data"][i]["name"].stringValue]
                self.arrayForDetailedDescription = ["addressDetails": response["data"][i]["addressDetail"].stringValue, "duration": response["data"][i]["duration"].stringValue, "description": response["data"][i]["description"].stringValue]
                if response["data"][i]["chargerTypes"].count != 0 {
                for i in 0..<response["data"][i]["chargerTypes"].count {
                    self.arrayForStringChargersType.insert(response["data"][i]["chargerTypes"][i]["name"].stringValue, at: i)
                    
                }
                    print(self.arrayForStringChargersType)
                    for item in self.arrayForStringChargersType {
                        self.string += "\(item)"
                    }
                    print(self.string)
                self.arrayForDetailedDescription = ["addressDetails": response["data"][i]["addressDetail"].stringValue, "duration": response["data"][i]["duration"].stringValue, "description": response["data"][i]["description"].stringValue, "chargerTypes": self.string]
                }else{
                   self.arrayForDetailedDescription = ["addressDetails": response["data"][i]["addressDetail"].stringValue, "duration": response["data"][i]["duration"].stringValue, "description": response["data"][i]["description"].stringValue, "chargerTypes": ""]
                }
         print(self.arrayForDetailedDescription)
                self.dictionaryForDetaileddesciption.insert(self.arrayForDetailedDescription, at: i)
                self.arrayForSpots.insert(self.arrayForFirstSpot, at: i)
                
                self.arrayWithSpots.insert(response["data"][i]["_id"].stringValue, at: i)
            
            print(self.arrayForSpots.count)
            //            var longitudeFirst = response["data"][0]["location"][1].stringValue
            //            for item in response {
            //            arrayOfPoints.append(item)
            //        }
            //print(latitideFirst)
            //            print(longitudeFirst)
        }
        

            }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
//        self.tableView.reloadData()
        
        GoogleAPIRequest().requestToGoogle(self.coordLatitudeForDestination, self.coordLongitudeForDestination, self.arrayForSpots, self.arrayWithSpots, self.dictionaryForDetaileddesciption) { (json, kmArray, distancesArray, addressArray, deletedArray, status, arrayWithDeletedSpots, dictionaryDeleted) in
            if status == false {
                self.arrayWithSpots = arrayWithDeletedSpots
                self.arrayForSpots = deletedArray
                self.dictionaryForDetaileddesciption = dictionaryDeleted
                self.tableView.reloadData()
            } else {
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
         if self.arrayOfKmInString.count == self.arrayForSpots.count {

            cell.setUp(title: self.arrayForSpots[indexPath.row]["name"]!, distance: self.arrayOfKmInString[indexPath.row], address: arrayForSpots[indexPath.row]["address"]!)
            cell.spotID = self.arrayWithSpots[indexPath.row]
        }
                return cell

    }
    
    
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexForDestination = indexPath.row
        print(indexPath.row)
        print(self.indexForDestination)
        print(self.arrayWithSpots[self.indexForDestination])
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
            self.currentUser.set(self.arrayForSpots[self.indexForDestination]
, forKey: "spotSelectedDictionary")
    destination.spotArray = self.arrayForSpots[self.indexForDestination]
            destination.spotId = self.arrayWithSpots[self.indexForDestination]
self.currentUser.set(dictionaryForDetaileddesciption[self.indexForDestination], forKey: "detailedDictionary")
            destination.arrayWithDetailedDescription = self.dictionaryForDetaileddesciption[self.indexForDestination]
        }
    }
    
    
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
