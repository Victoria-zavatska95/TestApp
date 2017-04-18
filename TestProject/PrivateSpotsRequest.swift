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
    //get private spot list
    
    
    func getPrivateSpotList(completitionHandler: @escaping (_ json: JSON) -> ()){
        url = "http://188.166.110.248:"
        port = "3010/v1/private-spots?token=\(token)"
        Alamofire.request("\(url)\(port)", method: .get).responseJSON { (response) in
            let json = JSON(response.data)
            print(json.debugDescription)
            completitionHandler(json)
        }
    }
    
    //end
    
    
    
    func postSendRequestForAplug(spotId: String, completitionHandler: @escaping (_ response: JSON, _ status:Bool) -> ()){
        var lat = currentUser.value(forKey: "userLatitude") as! CLLocationDegrees
        self.userLatitude = "\(lat)"
        var long = currentUser.value(forKey: "userLongitude") as! CLLocationDegrees
        self.userLongitude = "\(long)"
        if !(connection?.isReachable)! {
            Alert().creatingAlert(message: "device is not connected to the Internet. Make sure your device is connected to the internet", controller: DetailedDescriptionForPointViewController())
        }
        if connection?.isReachable == true {
            print(currentUser.value(forKey: "userId"))
            self.userId = currentUser.value(forKey: "userId")! as! String
            print(self.userId)
            self.url = "http://188.166.110.248:"
            self.port = "3010/v1/users/\(self.userId)/private-history?token=\(self.token)"
            print(self.token)
            print(self.userLatitude)
            print(spotId)
            print(self.userLongitude)
            self.paramsList = [
                "spot": spotId,
                "location[0]": self.userLatitude,
                "location[1]": self.userLongitude
            ]
            print(self.paramsList)
            //        print("111111\(self.dictionaryOfSpot["spotId"]!)")
            print("\(self.url)\(self.port)")
            print("\(self.url)\(self.port)")
            Alamofire.request("\(self.url)\(self.port)", method: .post, parameters: self.paramsList).responseJSON { (response) in
                var json:JSON = JSON(response.data)
                if json["code"].stringValue == "400" {
                    print(json.debugDescription)
                    print(json["code"].stringValue)
                    completitionHandler(json, false)
                }
                  if json["code"].stringValue == "200" {
                    print(json["code"].stringValue)
                    print(json.debugDescription)
                    self.currentUser.set(json["data"]["host"]["_id"].stringValue, forKey: "hostID")
                    self.currentUser.set(json["data"]["user"]["_id"].stringValue, forKey: "userID")
                    self.currentUser.set(json["data"]["_id"].stringValue, forKey: "historyID")
                    self.currentUser.set(true, forKey: "requestWasSent")
                    self.currentUser.set(json["data"]["spot"]["location"][0].stringValue, forKey: "requestForPlugJSONLatitude")
                    self.currentUser.set(json["data"]["spot"]["location"][1].stringValue, forKey: "requestForPlugJSONLongitude")
                    completitionHandler(json, true)
  
                } else {
                    print(json.debugDescription)
                    completitionHandler(json, false)
                }
            }
            
            
            
            }
    }


    
    
    
    
    //                    let username = json["data"]["host"]["firstName"].stringValue
    //                    APPPush().cleareScheduleNotificationByType("waitingTime")
    //                    APPPush().setUpScheduledLocalNotification("PlugSpot", alertBody: "\(username) doesn’t seem to respond. Would you like to search a different spot?", timeInterval: 300, type: "waitingTime")
    //                    APPCharging().savePendingRequestPRIVATE(json["data"])
    //
    //                    APPPush().sendPushAboutPendingConfirmedRequest(plugOwnerId, json: json["data"], message: APPPushMessages().getChargeRequestMessageUSER(APPUser().getUserDataById(userId)["firstName"].stringValue), viewController: "RequestorDetailsTableViewController")
    //            APPPush().sendPushToUser(plugOwnerId, message: APPPushMessages().getChargeRequestMessageUSER(APPUser().getUserDataById(userId)["firstName"].stringValue), options: "", type: "pendingRequest", requestId: json["data"]["_id"].stringValue )
    
    
    
    
    // send request for a private spot
    
    
    func postCreatePrivareCharge(spotName:String, chargingTime: String, address:String, addressDetail: String, description: String, completionHandler:@escaping (_ response: JSON, _ status: Bool, _ paramsList: [String:String]) -> ()){
        var userLatitudeAnother = currentUser.value(forKey: "userLatitude") as! CLLocationDegrees
        var userLongitudeAnother = currentUser.value(forKey: "userLongitude") as! CLLocationDegrees
        print(userLatitudeAnother)
        let plugOwnerId:String = currentUser.value(forKey: "userId")! as! String
        port = "3010/v1/users/\(plugOwnerId)/spots?token=\(self.token)"
        paramsList = [
            "name": spotName,
            "duration": chargingTime,
            "description": description,
            "address": address,
            "addressDetail": addressDetail,
            "location[0]": "\(userLatitudeAnother)",
            "location[1]": "\(userLongitudeAnother)"
        ]
        Alamofire.request("\(url)\(port)", method: .post, parameters: paramsList).responseJSON { (response) in
            let json: JSON = JSON(response.data)
            print(json.debugDescription)
            print(json.debugDescription)
            completionHandler(json, true, self.paramsList)
        }
    }
    
    
    
    
    
    
    /*
     User declined the request before confimation [user]
     */
    func putCanceledPrivateHostRequestBeforeConfirmation(completitionHandler:@escaping (_ response:JSON, _ status:Bool) -> ()){
        var userIdNotString = self.currentUser.value(forKey: "userID")
        userId = "\(userIdNotString!)"
//        var hostIdAny = self.currentUser.value(forKey: "hostID")
//        var hostId: String = "\(hostIdAny!)"
       var id = self.currentUser.value(forKey: "historyID")
        var historyId: String = "\(id!)"
//        print("hostId\(hostId)")
        print("userID\(userId)")
        print("historyId\(historyId)")
        port = "3010/v1/users/\(self.userId)/private-history/\(historyId)/canceled-before-confirmation?token=\(self.token)"
        print("\(self.url)\(self.port)")
        Alamofire.request("\(self.url)\(self.port)", method: .put, parameters: nil).responseJSON { (response) in
            let json:JSON = JSON(response.data)
            
            print(json)
            if let err = response.error {
                print("error \(err)")
                completitionHandler(json, false)
            }else{
                //                APPPush().cleareScheduleNotificationByType("waitingTime")
                //
                //                APPPush().sendPushToUser(hostId, message: APPPushMessages().getCancleMessageUSER(APPUser().getUserDataById(userId)["firstName"].stringValue), options: "")
                //                APPRequest().getPrivateUserChargingRequestsHistoryForListView { (response) -> () in
                //
                //                }
                //                completitionHandler(response:"ok", status: true, history: json["data"])
                //            }
                //            operationQueue.addOperation(opt)
                //        } catch {
                //            completitionHandler(response:"nope", status: false, history: nil)
                //        }
                completitionHandler(json, true)
            }
            //end
            
            
        }
    
    }
    
    

    
    
    
    
}
