//
//  AccountViewController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/7/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    var currAccount:Account?
    
    // MARK: Firebase linking
    let ref = Database.database().reference()
    
    
    // MARK: UIComponents from storyboard
    
    @IBOutlet weak var usernameField: LeftFireField!
    @IBOutlet weak var phoneField: LeftFireField!
    @IBOutlet weak var keyField: LeftFireField!
    @IBOutlet weak var passwordField: LeftFireField!
    @IBOutlet weak var confirmField: LeftFireField!
    
    @IBOutlet weak var firstnameField: LeftFireField!
    @IBOutlet weak var lastnameField: LeftFireField!
    
    @IBOutlet weak var login: FireButton!
    @IBOutlet weak var back: FireButton!
    var textFieldList = [UITextField]()
    
    // MARK: UIComponent Actions
    
    @IBAction func loginAction(_ sender: Any) {
        if(validInput()){
            let username = usernameField.text
            let password = passwordField.text
            //currAccount = Account(first!,last!,phone!,key!,username!)
            Auth.auth().createUser(withEmail: username!, password: password!) { (user, error) in
                // ...
            }
            ref.child("users").child(user!.uid).setValue(["Provider": self.txtPassword.text!,"Email": self.txtEmail.text!,"Firstname": self.txtFName.text!,"Lastname": self.txtLname.text!,"Phone": self.txtPhone.text!,])
        }
        self.performSegue(withIdentifier: "returnSignin", sender: self)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.performSegue(withIdentifier: "returnSignin", sender: self)
    }
    
    // MARK: Determines whether signup button is viewable or not
    let buttonDisplay = true
    
    
    private func underLineFields(){
        self.usernameField.useUnderline()
        self.phoneField.useUnderline()
        self.keyField.useUnderline()
        self.passwordField.useUnderline()
        self.confirmField.useUnderline()
        self.firstnameField.useUnderline()
        self.lastnameField.useUnderline()
    }
    
    private func validInput()->Bool{
        for field in textFieldList{
            if field.text==""{
                return false
            }
        }
        return passwordField.text == confirmField.text
    }
    
    private func consolidateFields(){
        textFieldList = [usernameField,phoneField,keyField,passwordField,confirmField,firstnameField,lastnameField];
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        underLineFields()
        consolidateFields()
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


