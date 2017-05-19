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
import ReachabilitySwift
class PointsDescriptionTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var coordLongitudeForDestination: Double = 0.0
    
    var coordLatitudeForDestination: Double = 0.0
    var distance: String = ""
    
    var arrayOfDistances: [Double] = []
    var arrayOfKmInString: [String] = []
    var result: JSON = []
    var stringSome: String = ""
    let locationManager = CLLocationManager()
    var identifier: String = "no"
    var spotIDfromDetailed: String = ""
    
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
    var arrayForStringChargersTypeStringOfAllElements: String = ""
    @IBOutlet weak var SettingsButton: UIBarButtonItem!
    
    
    @IBOutlet weak var cancellButton: UIBarButtonItem!
    let reachability = Reachability()!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "reload"), object: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.coordLatitudeForDestination = self.currentUser.value(forKey: "userLatitude") as! Double
        self.coordLongitudeForDestination = self.currentUser.value(forKey: "userLongitude") as! Double
        self.arrayForSpots.remove(at: 0)
        if self.reachability.isReachable {
            PrivateSpotsRequest().getPrivateSpotList { (response) in
                for i in 0..<response["data"].count {
                    self.arrayForFirstSpot = ["latitude": response["data"][i]["location"][0].stringValue, "longitude": response["data"][i]["location"][1].stringValue, "address": response["data"][i]["address"].stringValue, "spotId": response["data"][i]["_id"].stringValue, "name": response["data"][i]["name"].stringValue]
                    self.arrayForDetailedDescription = ["addressDetails": response["data"][i]["addressDetail"].stringValue, "duration": response["data"][i]["duration"].stringValue, "description": response["data"][i]["description"].stringValue]
                    
                        self.arrayForDetailedDescription = ["addressDetails": response["data"][i]["addressDetail"].stringValue, "duration": response["data"][i]["duration"].stringValue, "description": response["data"][i]["description"].stringValue]

                    if response["data"][i]["owner"] != nil && response["data"][i]["name"].stringValue != "FirstSa" {
                        self.dictionaryForDetaileddesciption.append(self.arrayForDetailedDescription)
                        self.arrayForSpots.append(self.arrayForFirstSpot)
                        
                        self.arrayWithSpots.append(response["data"][i]["_id"].stringValue)  
                    }
                }
            }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: self)
        }
        
    }
    // end
    
    override func viewDidAppear(_ animated: Bool) {
        
        GoogleAPIRequest().requestToGoogle(self.coordLatitudeForDestination, self.coordLongitudeForDestination, self.arrayForSpots, self.arrayWithSpots, self.dictionaryForDetaileddesciption) { (json, kmArray, distancesArray, addressArray, deletedArray, status, arrayWithDeletedSpots, dictionaryDeleted) in
            if !status {
                self.arrayWithSpots = arrayWithDeletedSpots
                self.arrayForSpots = deletedArray
                self.dictionaryForDetaileddesciption = dictionaryDeleted
            } else {
                self.arrayOfKmInString = kmArray
                self.arrayOfDistances = distancesArray
                self.addressArray = addressArray
                self.tableView.reloadData()
                if self.arrayOfDistances.count == self.arrayForSpots.count {
                    self.minElement = self.arrayOfDistances.min()!
                    for item in self.arrayOfDistances {
                        if item == self.minElement {
                            self.index = self.arrayOfDistances.index(of: item)!
                        }
                    }
                    let oldElementValue = self.arrayOfKmInString[0]
                    self.arrayOfKmInString[0] = self.arrayOfKmInString[self.index]
                    self.arrayOfKmInString[self.index] = oldElementValue
                }
            }
            
        }
        
    }
    // end
    
    // reload Table
    func reloadTable() {
        self.tableView.reloadData()
    }
    // end
    
    
    @IBAction func buttonSettingsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toSettingsViewController", sender: self)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayForSpots.count
    }
    // end
    
    
    // set up the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chargingDevice", for: indexPath) as! ChargingTableViewCell
        if self.arrayOfKmInString.count != self.arrayForSpots.count {
        } else {
            cell.setUp(title: self.arrayForSpots[indexPath.row]["name"]!, distance: self.arrayOfKmInString[indexPath.row], address: arrayForSpots[indexPath.row]["address"]!, tableView: self)
            cell.hideButtons(indexPath: indexPath.row, arrayWithSpots: self.arrayWithSpots, spotIDfromDetailed: spotIDfromDetailed, identifierFromTableViewController: self.identifier)
            
            cell.spotID = self.arrayWithSpots[indexPath.row]
            
        }
        return cell
        
    }
    // end
    
    
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexForDestination = indexPath.row
            self.performSegue(withIdentifier: "toDetailedDescriptionViewController", sender: self)
    }
    // end
    
    
    // prepare for seques to DetailedDescriptionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedDescriptionViewController" {
            
            let destination = segue.destination as! DetailedDescriptionForPointViewController
            destination.reloadingTableView(tableView: self)
            destination.spotArray = self.arrayForSpots[self.indexForDestination]
            destination.spotId = self.arrayWithSpots[self.indexForDestination]
            destination.arrayWithDetailedDescription = self.dictionaryForDetaileddesciption[self.indexForDestination]
        }
    }
    // end
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
