//
//  Alert.swift
//  TestProject
//
//  Created by Azinec LLC on 3/24/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class Alert: NSObject {

    // create Alert
    func creatingAlert(message: String, controller : UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
           }
    // end

    // allow notification
    func AlertToAllowNotifications(text : String, controller: UIViewController){
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
 UIApplication.openAppSettings()
        }))
        controller.present(alert, animated: true, completion: nil)
    }
// end
    
    
    
}
