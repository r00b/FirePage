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
        
        
        let storyboardHelpLine = UIStoryboard(name: "Main", bundle: nil)
        let helpLineController = storyboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as! UINavigationController
        
        
        let storyboardCalendar = UIStoryboard(name: "Calendar", bundle: nil)
        let calendarController = storyboardCalendar.instantiateViewController(withIdentifier: "CalendarNavigationController") as! UINavigationController
        
        let storyboardHelpRequests = UIStoryboard(name: "HelpRequests", bundle: nil)
        let helpRequestsController = storyboardHelpRequests.instantiateViewController(withIdentifier: "MainTableViewController") as! MainTableViewController
        let helpRequestsController2 = storyboardHelpRequests.instantiateViewController(withIdentifier: "MainTableViewController") as! MainTableViewController

        
        
        let Contact = helpLineController
        let Calendar = calendarController
        let MyPages = helpRequestsController
        let Accounto = helpRequestsController2
//        let SuperPago = controller4
        
        let icon1 = UITabBarItem()
        
        icon1.title = "Contact"
        icon1.image = #imageLiteral(resourceName: "Contact")
        let icon2 = UITabBarItem()
        icon2.title = "Calendar"
        icon2.image = #imageLiteral(resourceName: "Calendar")
        let icon3 = UITabBarItem()
        icon3.title = "Resolve"
        icon3.image = #imageLiteral(resourceName: "Resolve")
        let icon4 = UITabBarItem()
        icon4.title = "Account"
        icon4.image = #imageLiteral(resourceName: "Settings")
        let icon5 = UITabBarItem()
        icon5.title = "Pages"
        icon5.image = #imageLiteral(resourceName: "Pages")
        
        
        
        
        Contact.tabBarItem = icon1
        
        Calendar.tabBarItem = icon2
        MyPages.tabBarItem = icon3
        Accounto.tabBarItem = icon4
//        SuperPago.tabBarItem = icon5
        
        var controllers = [UIViewController]()
        
        controllers = [Contact, Calendar, MyPages]
        
        // print(master.level)
        self.viewControllers = controllers
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
