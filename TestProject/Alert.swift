//
//  Alert.swift
//  TestProject
//
//  Created by Azinec LLC on 3/24/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class Alert: NSObject {

    func creatingAlert(message: String, controller : UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
        
    }
//
//    func creatingAlertforTableView(message: String, view : UIView) {
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        view.present(alert, animated: true, completion: nil)
//        
//    }

    
    
    
}
