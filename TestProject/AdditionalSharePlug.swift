//
//  AdditionalSharePlug.swift
//  TestProject
//
//  Created by Azinec LLC on 4/28/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import ReachabilitySwift

class AdditionalSharePlug: NSObject {
    let currentUser = UserDefaults.standard
    let reachability = Reachability()!
    var parameters : [String : String] = [:]

    func findMyAddress(_ userLocation: CLLocationCoordinate2D, completitionHandler : @escaping (_ address : String) -> ()) {
        let userCoordinatesString : String = "\(userLocation.latitude),\(userLocation.longitude)"
        if self.reachability.isReachable {
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(userCoordinatesString)&key=AIzaSyCorsqzOPXyDassV5BAFNujLqEGYO6o0ng", method: .get).responseJSON { (response) in
            let json : JSON = JSON(response.data)
            let address = json["results"][0]["formatted_address"].stringValue
            completitionHandler (address)
        }
        } else {
            Alert().creatingAlert(message: "No Internet Connection", controller: UIApplication.topViewController()!)
        }
    }
    
        func sharePlugChecking(_ plugName: String, _ addressName: String, _ chargersType: String, _ maximumChargingTimeTextfield: String, _ descriptionAddressTextfield: String, _ detailsTextfield: String)-> [String : String] {
        var stringTime: String = maximumChargingTimeTextfield
        var timeOptional: Int? = Int(stringTime)
        var userLatitudeAnother = currentUser.value(forKey: "userLatitude") as! CLLocationDegrees
        var userLongitudeAnother = currentUser.value(forKey: "userLongitude") as! CLLocationDegrees
        if plugName == "" || addressName == "" || chargersType == "" || maximumChargingTimeTextfield == "" || descriptionAddressTextfield == "" || detailsTextfield == "" {
            Alert().creatingAlert(message: "All textfields should be fulfilled", controller: UIApplication.topViewController()!)
        }
        else if timeOptional == nil {
            Alert().creatingAlert(message: "You should enter only numbers in the maximum charging time textfield", controller: UIApplication.topViewController()!)
        }
        if plugName != "" && addressName != "" && chargersType != "" && maximumChargingTimeTextfield != "" && descriptionAddressTextfield != "" && detailsTextfield != "" && timeOptional != nil {
            self.parameters = [
                "name": plugName,
                "duration": maximumChargingTimeTextfield,
                "description": detailsTextfield,
                "address": addressName,
                "addressDetail": descriptionAddressTextfield,
                "location[0]": "\(userLatitudeAnother)",
                "location[1]": "\(userLongitudeAnother)"
            ]
        }
        return self.parameters	 
    }
}
