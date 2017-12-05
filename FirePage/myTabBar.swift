//
//  TabBar.swift
//  FirePage
//
//  Created by The Ritler on 12/30/16.
//  Copyright © 2016 The Ritler. All rights reserved.
//
// import FireBase
import Foundation
import UIKit
import Firebase

class myTabBar: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.tintColor = .red
        
        
        //Get all the view controllers
        
        let storyboardHelpLine = UIStoryboard(name: "Main", bundle: nil)
        let helpLineController = storyboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as! UINavigationController
        
        let storyboardSignOut = UIStoryboard(name: "Main", bundle: nil)
        let signOutController = storyboardHelpLine.instantiateViewController(withIdentifier: "SignOutViewController") as! UIViewController
        
        
        let storyboardCalendar = UIStoryboard(name: "Calendar", bundle: nil)
        let calendarController = storyboardCalendar.instantiateViewController(withIdentifier: "CalendarNavigationController") as! UINavigationController
        
        let storyboardHelpRequests = UIStoryboard(name: "HelpRequests", bundle: nil)
        let helpRequestsController = storyboardHelpRequests.instantiateViewController(withIdentifier: "HelpRequestsNavigationController") as! UINavigationController
        
        let storyboardMessaging = UIStoryboard(name: "Messaging", bundle: nil)
        let chatNavController = storyboardMessaging.instantiateViewController(withIdentifier: "ChatNavigationController") as! UINavigationController
        
        let Contact = helpLineController
        let Calendar = calendarController
        let MyPages = helpRequestsController
        let account = signOutController
        
        //set view controller tab bar icons
        
        let icon1 = UITabBarItem()
        icon1.title = "Contact"
        icon1.image = #imageLiteral(resourceName: "Contact")
        
        let icon2 = UITabBarItem()
        icon2.title = "Calendar"
        icon2.image =  #imageLiteral(resourceName: "Calendar")
        let icon3 = UITabBarItem()
        icon3.title = "Resolve"
        icon3.image =  #imageLiteral(resourceName: "Resolve")
        
        let icon4 = UITabBarItem()
        icon4.title = "Account"
        icon4.image =  #imageLiteral(resourceName: "Settings")
        
        Contact.tabBarItem = icon1
        Calendar.tabBarItem = icon2
        MyPages.tabBarItem = icon3
        account.tabBarItem = icon4
        
        var controllers = [UIViewController]()
        
        //add view controllers based on role
        
        if(SessionInfo.account?.getRole() == FireRole.RA){
            controllers = [Contact, Calendar, MyPages, account]
            //controllers = [Contact, Calendar, MyPages, Chat]
        }else if(SessionInfo.account?.getRole() == FireRole.RC){
            controllers = [Contact, Calendar, account]
        }else{
            controllers = [Contact, account]
        }
        
        
        self.viewControllers = controllers
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true;
    }
}

