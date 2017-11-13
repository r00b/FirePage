//
//  ViewController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/5/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController{
    
    private var textFieldMap:[String:UITextField] = [:]
    let labelsList:[String]=["Username","Password"]
    
    private var labelCounter = 0
    private var fieldCenterX = 0
    // MARK: Settings for field placement
    let fieldWidth = 200
    let fieldHeight = 30
    let fieldCeiling = 250
    let fieldSpacing = 35
    
    var buttonCounter = 0
    var buttonCenterX = 0
    
    let buttonWidth = 100
    let buttonSpacing = 35
    let buttonCeiling = 400
    let buttonHeight = 30
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        buttonCenterX = Int(Double(Float(self.view.bounds.width)/2)-Double(buttonWidth/2))
        fieldCenterX = Int(Double(Float(self.view.bounds.width)/2)-Double(fieldWidth/2))
        genAllButtons()
        genAllFields(labelsList)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Mark: Populate buttons
    private func genAllButtons(){
        let calcY = buttonCounter*buttonSpacing+buttonCeiling
        let saveButton = CustomButton(frame: CGRect(x: Int(buttonCenterX), y: calcY, width: buttonWidth, height: buttonHeight),title:"Login")
        saveButton.addTarget(self, action: #selector(signInAction), for:.touchUpInside)
        let backButton = CustomButton(frame: CGRect(x: Int(buttonCenterX), y: calcY+buttonSpacing, width: buttonWidth, height: buttonHeight),title:"Sign Up")
        backButton.addTarget(self, action: #selector(signUpAction), for:.touchUpInside)
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
        
    }
    
    // MARK: Populates text fields
    private func genTextField(text:String){
        let calcY = labelCounter*fieldSpacing+fieldCeiling
        let newTextField = CustomTextField(frame: CGRect(x: Int(fieldCenterX), y: calcY, width: fieldWidth, height: fieldHeight), title:text)
        if text.contains("Password"){
            newTextField.hideText()
        }
        self.view.addSubview(newTextField)
        textFieldMap[text]=newTextField
        labelCounter+=1
    }
    private func genAllFields(_ list:[String]){
        for name in list{
            genTextField(text: name)
        }
    }
    
    @objc private func signInAction(){
        let email = textFieldMap["Username"]?.text
        let password = textFieldMap["Password"]?.text
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            // ...
        }
        if Auth.auth().currentUser != nil {
            print("signed in")
            self.performSegue(withIdentifier: "signedIn", sender: self)
        } else {
            print("Invalid Password or Account")
        }
        
    }
    
    @objc private func signUpAction(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "loginToSignUp", sender: self)
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

