//
//  CreateTokens.swift
//  TestProject
//
//  Created by Azinec LLC on 4/27/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import JWT

class CreateTokens: NSObject {
    var currentUser = UserDefaults.standard
    
//createTokenForFacebook
    func createTokenForFacebook(facebookId:String, password:String, deviceSignature:String)->String{

        let token:String = JWT.encode(.hs512("secret".data(using: .utf8)!)) { builder in
        
            builder["facebookId"]      = facebookId
            
            builder["password"]        = password
            
            builder["deviceSignature"] = deviceSignature
            
        }
        
        currentUser.set(token, forKey: "userTokenFaceboook")
        
        return token
        
    }
    // end
    
    // create token manually for sending a request to server
    func createTokenForManual(userName:String, password:String, deviceSignature:String)->String {
        
        let token:String = JWT.encode(.hs512("secret".data(using: .utf8)!)) { (builder) in
            builder["userName"]        = userName
            builder["password"]        = password
            builder["deviceSignature"] = deviceSignature
            
        }
        
        currentUser.set(token, forKey: "userToken")
        return token
    }
    // end


}
