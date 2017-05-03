//
//  AppDelegate.swift
//  TestProject
//
//  Created by Azinec LLC on 3/21/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import SwiftyJSON
import FacebookCore
import FBSDKCoreKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var distance: Double = 70.0
    var window: UIWindow?
    var currentUser = UserDefaults.standard
    let reachability = Reachability()!
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reinstateBackgroundTask), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var coordLongitude = (manager.location?.coordinate.longitude)!
        
        var coordLatitude = (manager.location?.coordinate.latitude)!
        GoogleAPIRequest().requestToGoogleInAppDelegate(coordLatitude, coordLongitude) { (json, distance) in
            self.currentUser.set(distance, forKey: "distance")
            self.locationManager.stopUpdatingLocation()
        }
        
        
    }
    // end
    
    // creating alert while monitoring the battery state and distance
    func reinstateBackgroundTask() {
        var state = UIDevice.current.batteryState
        
        if state == .unplugged {
            
            locationManager.delegate = self
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.startUpdatingLocation()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        
        if self.currentUser.value(forKey: "distance") != nil {
            self.distance = self.currentUser.value(forKey: "distance") as! Double
        }
        if state == .charging && self.currentUser.bool(forKey: "requestWasSent") && distance <= 0.005 {
            Alert().creatingAlert(message: "Device is charging within 50 m.", controller: UIApplication.topViewController()!)
            self.currentUser.set(false, forKey: "ChargeIsCompleted")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideCancel"), object: nil)
        }
        
        if state == .full && self.currentUser.bool(forKey: "requestWasSent") && distance <= 0.005 {
            Alert().creatingAlert(message: "Device fulled", controller: UIApplication.topViewController()!)
            self.currentUser.set(false, forKey: "ChargeIsCompleted")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideCancel"), object: nil)
            
        }
        
        if state == .unplugged && self.currentUser.bool(forKey: "requestWasSent") && distance <= 0.005 && !self.currentUser.bool(forKey: "ChargeIsCompleted") {
            
            Alert().creatingAlert(message: "The charging is completed within 50 m.", controller: UIApplication.topViewController()!)
            self.currentUser.set(true, forKey: "ChargeIsCompleted")
            if self.reachability.isReachable {
                PrivateSpotsRequest().putCanceledPrivateHostRequestBeforeConfirmation(completitionHandler: { (json, status) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                })
                
            } else {
                Alert().creatingAlert(message: "No Internet connection", controller: UIApplication.topViewController()!)
            }
        }
        
    }
    // end
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        currentUser.set(deviceTokenString, forKey: "DeviceToken")

        
        // Persist it in your backend in case it's new
    }
    // end
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }
    // end
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
