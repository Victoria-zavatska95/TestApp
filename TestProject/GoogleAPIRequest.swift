//
//  GoogleAPIRequest.swift
//  TestProject
//
//  Created by Azinec LLC on 3/30/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire
var currentUser = UserDefaults.standard
class GoogleAPIRequest: NSObject {
    
    // request to Google API in order to find the distance
    func requestToGoogle(_ coordinateLatitude: Double, _ coordinateLongitude: Double, _ arrayWithPointsFromServer: [[String: String]], _ arrayWithSpotsInitial: [String], _ dictionaryWithSpotsInitial: [[String: String]], completitionHandler:@escaping (_ json:JSON, _ arrayOfKm: [String], _ arrayDistances: [Double], _ addressArray: [String], _ deletedArray: [[String:String]], _ status: Bool, _ arrayForSpotsFinal: [String], _ dictionaryWithDetailedSpots: [[String: String]]) -> Void) {
        var arrayOfKm: [String] = []
        var arrayOfDistances: [Double] = []
        var stringWithoutLettters: String = ""
        var addressArray: [String] = []
        var stringFirst: String = ""
        var deletedArray: [[String:String]] = [[:]]
        var dictionaryWithDetailedSpots : [[String:String]] = [[:]]
        var arrayForSpotsFinal: [String] = []
        for item in arrayWithPointsFromServer {
            
            var coordinate₀ = CLLocationCoordinate2DMake(Double(item["latitude"]!)!, Double(item["longitude"]!)!)
            var coordinate₁ = CLLocationCoordinate2DMake(coordinateLatitude, coordinateLongitude)
            
            var anotherCoordinate : String = "\(coordinate₀.latitude),\(coordinate₀.longitude)"
            var meCoordinate: String = "\(coordinate₁.latitude),\(coordinate₁.longitude)"
            
            Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?origin=\(meCoordinate)&destination=\(anotherCoordinate)&sensor=true&mode=walking&language=en&key=AIzaSyCorsqzOPXyDassV5BAFNujLqEGYO6o0ng", method: .get).responseJSON { (response) in
                let rezul = JSON(response.data)
                if rezul["status"].stringValue == "ZERO_RESULTS" {
                    deletedArray = arrayWithPointsFromServer
                    dictionaryWithDetailedSpots = dictionaryWithSpotsInitial
                    arrayForSpotsFinal = arrayWithSpotsInitial
                    for (index, dict) in arrayWithPointsFromServer.enumerated() {
                        if dict == item {
                            deletedArray.remove(at: index)
                            arrayForSpotsFinal.remove(at: index)
                            dictionaryWithDetailedSpots.remove(at: index)
                        }
                    }
                    completitionHandler(rezul, arrayOfKm, arrayOfDistances, addressArray, deletedArray, false, arrayForSpotsFinal, dictionaryWithDetailedSpots)
                    
                } else {
                    var distance = rezul["routes"][0]["legs"][0]["distance"]["text"].stringValue
                    
                    arrayOfKm.append(distance)
                    var address = rezul["routes"][0]["legs"][0]["end_address"].stringValue
                    
                    addressArray.append(address)
                    
                    var stringSome = String(distance.characters.dropLast(1))
                    if stringSome.characters.last == "k" {
                        stringWithoutLettters = String(stringSome.characters.dropLast(2))
                        arrayOfDistances.append(Double(stringWithoutLettters)!)
                    }
                    if stringSome.characters.last == " " {
                        stringWithoutLettters = String(stringSome.characters.dropLast(1))
                        stringWithoutLettters = String(Double(stringWithoutLettters)! / 1000)
                        arrayOfDistances.append(Double(stringWithoutLettters)!)
                    }
                    
                    completitionHandler(rezul, arrayOfKm, arrayOfDistances, addressArray, deletedArray, true, [""], [["":""]])
                }
            }
        }
    }
    // end
    
    
    // request to Google API from AppDelegate in order to find the distance
    func requestToGoogleInAppDelegate(_ coordinateLatitude: CLLocationDegrees, _ coordinateLongitude: CLLocationDegrees, completitionHandler:@escaping (_ result:JSON, _ distanceinDouble: Double) -> Void) {
        var distanceinDouble: Double = 0.0
        var plugJSONLatitude: String = currentUser.value(forKey: "requestForPlugJSONLatitude")! as! String
        
        var coordinateOfPlugLongitude: String = currentUser.value(forKey: "requestForPlugJSONLongitude")! as! String
        var coordinate₀ = CLLocationCoordinate2DMake(Double(plugJSONLatitude)!, Double(coordinateOfPlugLongitude)!)
        var coordinate₁ = CLLocationCoordinate2DMake(coordinateLatitude, coordinateLongitude)
        
        var anotherCoordinate : String = "\(coordinate₀.latitude),\(coordinate₀.longitude)"
        var meCoordinate: String = "\(coordinate₁.latitude),\(coordinate₁.longitude)"
        Alamofire.request("http://maps.googleapis.com/maps/api/directions/json?origin=\(meCoordinate)&destination=\(anotherCoordinate)&sensor=true&mode=walking&language=en", method: .get).responseJSON { (response) in
            var result = JSON(response.data)
            if result["status"].stringValue == "ZERO_RESULTS" {
                completitionHandler(result, 0.0)
                
            }else {
                var distance = result["routes"][0]["legs"][0]["distance"]["text"].stringValue
                
                var stringSome = String(distance.characters.dropLast(1))
                if stringSome.characters.last == "k" {
                    var stringOfDistance = String(stringSome.characters.dropLast(2))
                    distanceinDouble = Double(stringOfDistance)!
                }
                if stringSome.characters.last == " " {
                    var stringWithoutLettters = String(stringSome.characters.dropLast(1))
                    stringWithoutLettters = String(Double(stringWithoutLettters)! / 1000)
                    distanceinDouble = Double(stringWithoutLettters)!
                    
                }
                completitionHandler(result, distanceinDouble)
                
            }
        }
    }
    // end
    
    
    
}
