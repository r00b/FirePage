//
//  ViewController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/5/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{
    
    // MARK: UI Outlets
    @IBOutlet weak var usernameField: LeftFireField!
    @IBOutlet weak var passwordField: LeftFireField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var forgotUsername: UIButton!
    
    // MARK: UI Actions
    
    @IBAction func loginClick(_ sender: Any) {
        let email = usernameField.text
        let password = passwordField.text
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            // ...
        }
        if Auth.auth().currentUser != nil {
            print("signed in")
            DB.getAccount(email: email!, mainAppSegue: performSegue)
            //self.performSegue(withIdentifier: "signedIn", sender: self)
        } else {
            print("Invalid Password or Account")
        }
    }
    
    func performSegue() -> Void{
        self.performSegue(withIdentifier: "signedIn", sender: self)
    }
    
    @IBAction func signupClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "loginToSignUp", sender: self)
    }
    
    @IBAction func forgotPasswordClick(_ sender: Any) {
        let email = usernameField.text
        if email != ""{
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                // ...
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        usernameField.useUnderline()
        passwordField.useUnderline()
    }
    
    @objc func dismissBoard(){
        view.endEditing(true)
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

