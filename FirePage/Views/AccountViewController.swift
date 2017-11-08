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
    
    // MARK: Determines whether signup button is viewable or not
    let buttonDisplay = true
    
    // MARK: Settings for field placement
    let fieldWidth = 200
    let fieldHeight = 30
    let fieldCeiling = 150
    let fieldSpacing = 35
    
    let buttonWidth = 100
    let buttonFieldSpacing = 50
    var fieldCenterX = 0.0;
    var buttonCenterX = 0.0;
    let labelsList:[String]=["First Name","Last Name","Username","Phone Number","Key","Password","Re-Enter Password"]
    private var textFieldMap:[String:UITextField] = [:]
    private var labelCounter = 0
    
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
    
    private func genAllButtons(){
        let calcY = labelCounter*fieldSpacing+fieldCeiling+buttonFieldSpacing
        let saveButton = CustomButton(frame: CGRect(x: Int(buttonCenterX), y: calcY, width: buttonWidth, height: fieldHeight),title:"Sign Up")
        saveButton.addTarget(self, action: #selector(signUpAction), for:.touchUpInside)
        let backButton = CustomButton(frame: CGRect(x: Int(buttonCenterX), y: calcY+fieldSpacing, width: buttonWidth, height: fieldHeight),title:"Return")
        backButton.addTarget(self, action: #selector(backAction), for:.touchUpInside)
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
        
    }
    
    // MARK: Actions when buttons are clicked
    
    @objc func signUpAction(sender: UIButton!){
        //init(_ first:String, _ last:String, _ phone:String, _ key:String, _ user:String)
        if(checkValidInputs()){
            let first = textFieldMap["First Name"]?.text
            let last = textFieldMap["Last Name"]?.text
            let username = textFieldMap["Username"]?.text
            let phone = textFieldMap["Phone Number"]?.text
            let key = textFieldMap["Key"]?.text
            let password = textFieldMap["Password"]?.text
            
            currAccount = Account(first!,last!,phone!,key!,username!)
            Auth.auth().createUser(withEmail: username!, password: password!) { (user, error) in
                // ...
            }
        }
        clearForm()
        
        self.performSegue(withIdentifier: "returnSignin", sender: self)
    }
    @objc func backAction(sender: UIButton!){
        self.performSegue(withIdentifier: "returnSignin", sender: self)
    }
    
    private func checkValidInputs()->Bool{
        for field in textFieldMap.keys{
            if textFieldMap[field]?.text == ""{
                return false
            }
        }
        return textFieldMap["Password"]?.text == textFieldMap["Re-Enter Password"]?.text
        
    }
    private func clearForm(){
        for field in textFieldMap.keys{
            //print(textFieldMap[field]?.text ?? "no value");
            textFieldMap[field]?.text = ""
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        fieldCenterX = Double(Float(self.view.bounds.width)/2)-Double(fieldWidth/2)
        buttonCenterX = Double(Float(self.view.bounds.width)/2)-Double(buttonWidth/2)
        genAllFields(labelsList)
        genAllButtons()
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
