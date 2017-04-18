//
//  SettingsViewController.swift
//  TestProject
//
//  Created by Azinec LLC on 4/4/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    var currentUser = UserDefaults.standard
    
    @IBOutlet weak var deleteAcountButton: UIButton!
    var myColor = UIColor.white
    
    
    override func viewDidLoad() {
        self.logoutButton.layer.cornerRadius = 25.0
        self.deleteAcountButton.layer.cornerRadius = 25.0
        self.logoutButton.layer.borderWidth = 2.0
        self.deleteAcountButton.layer.borderColor = myColor.cgColor
        super.viewDidLoad()
//     if !self.currentUser.bool(forKey: "isLogined") {
//        DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "fromLogouttoLoginizationViewController", sender: self)
//            }
//        }
        // Do any additional setup after loading the view.
   
    }
    
    

    @IBAction func deleteAcountAction(_ sender: Any) {
        self.currentUser.set(false, forKey: "isRegistered")
               self.currentUser.set(false, forKey: "isLogined")
    self.performSegue(withIdentifier: "fromdeleteAccountToRegistrationViewController", sender: self)
    }
    
   
    @IBAction func logoutAction(_ sender: Any) {
        self.currentUser.set(false, forKey: "isLogined")
    self.performSegue(withIdentifier: "fromLogouttoLoginizationViewController", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
