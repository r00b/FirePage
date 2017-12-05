//
//  AccountViewController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/7/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import Firebase

class AccountController: UIViewController {
    
    var currAccount:Account?
    
    // MARK: UIComponents from storyboard
    
    @IBOutlet weak var usernameField: LeftFireField!
    @IBOutlet weak var phoneField: LeftFireField!
    @IBOutlet weak var keyField: LeftFireField!
    @IBOutlet weak var passwordField: LeftFireField!
    @IBOutlet weak var confirmField: LeftFireField!
    @IBOutlet weak var firstnameField: LeftFireField!
    @IBOutlet weak var lastnameField: LeftFireField!
    
    // MARK: Determines whether signup button is viewable or not
    let buttonDisplay = true
    
    // MARK: Actions when buttons are clicked
    
    @objc func signUpAction(sender: UIButton!){
        //init(_ first:String, _ last:String, _ phone:String, _ key:String, _ user:String)
        if(true){
            
            let username = ""
            let password = ""
            //currAccount = Account(first!,last!,phone!,key!,username!)
            Auth.auth().createUser(withEmail: username, password: password) { (user, error) in
                // ...
            }
        }
        self.performSegue(withIdentifier: "returnSignin", sender: self)
    }
    @objc func backAction(sender: UIButton!){
        self.performSegue(withIdentifier: "returnSignin", sender: self)
    }
    
    private func underLineFields(){
        self.usernameField.useUnderline()
        self.phoneField.useUnderline()
        self.keyField.useUnderline()
        self.passwordField.useUnderline()
        self.confirmField.useUnderline()
        self.firstnameField.useUnderline()
        self.lastnameField.useUnderline()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        underLineFields()
        // Do any additional setup after loading the view.
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

