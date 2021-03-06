//
//  extensionUIApplication.swift
//  TestProject
//
//  Created by Azinec LLC on 3/24/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication {
    // define top View Controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller!
    }
    // end
    
    // open Settings
        class func openAppSettings() {
            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
        }
    // end
    }


