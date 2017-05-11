import UIKit
import ReachabilitySwift
import SwiftyJSON
import Alamofire
import ReachabilitySwift
import CoreLocation


class PrivateSpotsRequest: NSObject {
    
    let connection = Reachability()
    var url : String = "http://188.166.110.248:"
    var port: String = ""
    var token: String = "1"
    var userLatitude: String = ""
    var userLongitude: String = ""
    var dictionaryOfSpot: [String:String] = [:]
    var paramsList:[String: String] = [:]
    var currentUser = UserDefaults.standard
    var userId: String = ""
    var spotId: String = ""
    var plugOwnerId: String = ""
    
    //get private spot list
    func getPrivateSpotList(completitionHandler: @escaping (_ json: JSON) -> ()){
        url = "http://188.166.110.248:"
        port = "3010/v1/private-spots?token=\(token)"
        Alamofire.request("\(url)\(port)", method: .get).responseJSON { (response) in
            let json = JSON(response.data)
            completitionHandler(json)
        }
    }
    //end
    
    // post send request
    func postSendRequestForAplug(spotId: String, completitionHandler: @escaping (_ response: JSON, _ status:Bool, _ statusOfSharing: Bool) -> ()){
        var lat = currentUser.value(forKey: "userLatitude") as! CLLocationDegrees
        self.userLatitude = "\(lat)"
        var long = currentUser.value(forKey: "userLongitude") as! CLLocationDegrees
        self.userLongitude = "\(long)"
        if !(connection?.isReachable)! {
            Alert().creatingAlert(message: "device is not connected to the Internet. Make sure your device is connected to the internet", controller: DetailedDescriptionForPointViewController())
        }
        if connection?.isReachable == true {
            self.userId = currentUser.value(forKey: "userId")! as! String
            self.url = "http://188.166.110.248:"
            self.port = "3010/v1/users/\(self.userId)/private-history?token=\(self.token)"
            self.paramsList = [
                "spot": spotId,
                "location[0]": self.userLatitude,
                "location[1]": self.userLongitude
            ]
            Alamofire.request("\(self.url)\(self.port)", method: .post, parameters: self.paramsList).responseJSON { (response) in
                var json:JSON = JSON(response.data)
                if json["code"].stringValue == "400" && json["error"].stringValue != "You can't host yourself" {
                    completitionHandler(json, false, false)
                }
                if json["code"].stringValue == "200" {
                    self.currentUser.set(json["data"]["host"]["_id"].stringValue, forKey: "hostID")
                    self.currentUser.set(json["data"]["user"]["_id"].stringValue, forKey: "userID")
                    self.currentUser.set(json["data"]["_id"].stringValue, forKey: "historyID")
                    self.currentUser.set(true, forKey: "requestWasSent")
                    self.currentUser.set(json["data"]["spot"]["location"][0].stringValue, forKey: "requestForPlugJSONLatitude")
                    self.currentUser.set(json["data"]["spot"]["location"][1].stringValue, forKey: "requestForPlugJSONLongitude")
                    completitionHandler(json, true, false)
                }
                if json["error"].stringValue == "You can't host yourself"{
                    completitionHandler(json, false, true)
                }
            }
            
            
            
        }
    }
    // end
    
    
    func postCreatePrivareCharge(parameters: [String:String], completionHandler:@escaping (_ response: JSON, _ status: Bool, _ paramsList: [String:String], _ error: String) -> ()){
        
        let plugOwnerId:String = currentUser.value(forKey: "userId")! as! String
        port = "3010/v1/users/\(plugOwnerId)/spots?token=\(self.token)"
        var error: String = ""
        Alamofire.request("\(url)\(port)", method: .post, parameters: parameters).responseJSON { (response) in
            let json: JSON = JSON(response.data)
            if json["code"].stringValue == "201" {
                
                self.currentUser.set(json["data"]["owner"]["_id"].stringValue, forKey: "spotOwnerId")
                self.currentUser.set(json["data"]["_id"].stringValue, forKey: "plugIdSetWhenCreated")
                self.currentUser.set(true, forKey: "spotCreated")
                self.currentUser.set(json["data"]["name"].stringValue, forKey: "plugNameForProfile")
                self.currentUser.set(json["data"]["duration"].stringValue, forKey: "maximumTimeProfile")
                self.currentUser.set(json["data"]["address"].stringValue, forKey: "plugAddress")
                
                completionHandler(json, true, self.paramsList, error)
            }
            else if json["error"].stringValue == "User can be owner only one spot" {
                error = "You can be owner of only one spot"
                completionHandler(json, false, [:], error)
            }
           else if json["error"].stringValue == "This location already reserved" {
                error = "This location already reserved"
                completionHandler(json, false, [:], error)
            } else {
                error = "You did not create the spot"
                completionHandler(json, false, [:], error)
            }
            
        }
    }
    // end
    
    // cancel request
    func putCanceledPrivateHostRequestBeforeConfirmation(completitionHandler:@escaping (_ response:JSON, _ status:Bool) -> ()){
        let userIdNotString = self.currentUser.value(forKey: "userID")
        userId = "\(userIdNotString!)"
        var id = self.currentUser.value(forKey: "historyID")
        var historyId: String = "\(id!)"
        port = "3010/v1/users/\(self.userId)/private-history/\(historyId)/canceled-before-confirmation?token=\(self.token)"
        Alamofire.request("\(self.url)\(self.port)", method: .put, parameters: nil).responseJSON { (response) in
            let json:JSON = JSON(response.data)
            if json["code"].stringValue == "400" {
                completitionHandler(json, false)
            }
            if json["code"].stringValue == "200" {
                
                self.currentUser.set(false, forKey: "requestWasSent")
                
                completitionHandler(json, true)
            }else{
                completitionHandler(json, false)
                
            }
            
            
        }
        
    }
    //end
    
    //remove private Spot
    func deletePrivareCharge(completitionHandler:@escaping (_ response: JSON, _ status:Bool, _ error: String) -> ()){
        var error: String = ""
        if self.currentUser.bool(forKey: "spotCreated") {
            var spotIdNotString = self.currentUser.value(forKey: "plugIdSetWhenCreated") as! String
            self.spotId = "\(spotIdNotString)"
            var plugOwnerId:String = self.currentUser.value(forKey: "userId")! as! String
            self.port = "3010/v1/users/\(plugOwnerId)/spots/\(self.spotId)/?token=\(self.token)"
            Alamofire.request("\(self.url)\(self.port)", method: .delete, parameters: nil).responseJSON { (response) in
                let json:JSON = JSON(response.data)
                if json["code"].stringValue == "400" {
                    error = "Deleting a charge was failed"
                    completitionHandler(json, false, error)
                }
                if json["code"].stringValue == "200" {
                    self.currentUser.set(false, forKey: "spotCreated")
                    completitionHandler(json, true, "")
                }
                if json["code"].stringValue == "401" {
                    error = "You are not owner of this spot"
                    completitionHandler(json, false, error)
                    
                }
                
                
            }
        } else {
            error = "You cannot delete the spot because you are not owner of this spot"
            completitionHandler([], false, error)
            
        }
        
    }
    //end}
    
}
