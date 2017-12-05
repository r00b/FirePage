//
//  SessionInfo.swift
//  FirePage
//
//  Created by The Ritler on 12/4/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class SessionInfo{
    //holds current user
    static var account: Account?
    
    //sets current user
    static func login(user: Account){
        account = user
    }
    
    //logs the current user out
    static func logout(){
        account = nil
        let storyboardHelpLine = UIStoryboard(name: "Main", bundle: nil)
        let helpLineController = storyboardHelpLine.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
    }
}
