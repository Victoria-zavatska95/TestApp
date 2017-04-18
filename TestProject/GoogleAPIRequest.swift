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
    func requestToGoogle(_ coordinateLatitude: Double, _ coordinateLongitude: Double, _ arrayWithPointsFromServer: [[String: String]], _ arrayWithSpotsInitial: [String], _ dictionaryWithSpotsInitial: [[String: String]], completitionHandler:@escaping (_ json:JSON, _ arrayOfKm: [String], _ arrayDistances: [Double], _ addressArray: [String], _ deletedArray: [[String:String]], _ status: Bool, _ arrayForSpotsFinal: [String], _ dictionaryWithDetailedSpots: [[String: String]]) -> Void) {
        var arrayOfKm: [String] = []
        var arrayOfDistances: [Double] = []
        var stringWithoutLettters: String = ""
        var addressArray: [String] = []
        print(addressArray.count)
        var stringFirst: String = ""
        var deletedArray: [[String:String]] = [[:]]
        var dictionaryWithDetailedSpots : [[String:String]] = [[:]]
        var arrayForSpotsFinal: [String] = []
        for item in arrayWithPointsFromServer {
            
            var coordinate₀ = CLLocationCoordinate2DMake(Double(item["latitude"]!)!, Double(item["longitude"]!)!)
            var coordinate₁ = CLLocationCoordinate2DMake(coordinateLatitude, coordinateLongitude)
            
            var anotherCoordinate : String = "\(coordinate₀.latitude),\(coordinate₀.longitude)"
            var meCoordinate: String = "\(coordinate₁.latitude),\(coordinate₁.longitude)"
            
            Alamofire.request("http://maps.googleapis.com/maps/api/directions/json?origin=\(meCoordinate)&destination=\(anotherCoordinate)&sensor=true&mode=walking&language=en", method: .get).responseJSON { (response) in
                let rezul = JSON(response.data)
                print(rezul["status"].stringValue)
                if rezul["status"].stringValue == "ZERO_RESULTS" {
                    deletedArray = arrayWithPointsFromServer
                    dictionaryWithDetailedSpots = dictionaryWithSpotsInitial
                    print(self.index(ofAccessibilityElement: item))
arrayForSpotsFinal = arrayWithSpotsInitial
                    for (index, dict) in arrayWithPointsFromServer.enumerated() {
                        if dict == item {
                            deletedArray.remove(at: index)
                       arrayForSpotsFinal.remove(at: index)
                          dictionaryWithDetailedSpots.remove(at: index)
                    }
                    }
                            print(deletedArray)
                            completitionHandler(rezul, arrayOfKm, arrayOfDistances, addressArray, deletedArray, false, arrayForSpotsFinal, dictionaryWithDetailedSpots)

                } else {
                    //                print(response.debugDescription)
                    var distance = rezul["routes"][0]["legs"][0]["distance"]["text"].stringValue
    
                    arrayOfKm.append(distance)
                    var address = rezul["routes"][0]["legs"][0]["end_address"].stringValue
                    print(address)
                    
                    addressArray.append(address)
                    print(addressArray)
            
                    var stringSome = String(distance.characters.dropLast(1))
                    if stringSome.characters.last == "k" {
                        stringWithoutLettters = String(stringSome.characters.dropLast(2))
                    }
                    if stringSome.characters.last == " " {
                        stringWithoutLettters = String(stringSome.characters.dropLast(1))
                        stringWithoutLettters = String(Double(stringWithoutLettters)! / 1000)
                     arrayOfDistances.append(Double(stringWithoutLettters)!)
                    }
                    arrayOfDistances.append(Double(stringWithoutLettters)!)
                    print("arrayOfDistances\(arrayOfDistances)")
                    completitionHandler(rezul, arrayOfKm, arrayOfDistances, addressArray, deletedArray, true, [""], [["":""]])
                }
            }
        }
    }
    
    
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
            print(result["status"].stringValue)
            if result["status"].stringValue == "ZERO_RESULTS" {
                print("error")
completitionHandler(result, 0.0)
        
    }else {
            //                print(response.debugDescription)
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
}
