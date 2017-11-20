//
//  HelpLineViewController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/12/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import Firebase

class HelpLineViewController: UIViewController {
    private var handle: AuthStateDidChangeListenerHandle?
    private var originX = 0
    private var originY = 0
    private let radioButtonWidth = 100
    private let buttonWidth = 100
    private var buttonSpacing = 0
    private let buttonHeight = 30
    
    let fieldWidth = 200
    let fieldHeight = 30
    let fieldCeiling = 250
    let fieldSpacing = 35
    
    override func viewDidLoad() {
        originX = Int(self.view.bounds.width/2)
        originY = Int(self.view.bounds.height/2)
        buttonSpacing = Int(self.view.bounds.height/6)
        super.viewDidLoad()
        genButtons()
        genTextFields()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    private func genButtons(){
        
        let callButton = CustomButton(frame: CGRect(x: Int(originX-buttonWidth/2), y: originY + buttonSpacing, width: buttonWidth, height: buttonWidth), image: #imageLiteral(resourceName: "helpPhone"))
        self.view.addSubview(callButton)
        let raButton = CustomRadioButton(frame: CGRect(x: Int(originX-Int(1.5*Double(buttonWidth))), y: originY - buttonSpacing/4, width: radioButtonWidth, height: buttonHeight), title: "RA")
        self.view.addSubview(raButton)
        let dupdButton = CustomRadioButton(frame: CGRect(x: Int(originX-Int(0.5*Double(buttonWidth))), y: originY - buttonSpacing/4, width: radioButtonWidth, height: buttonHeight), title: "DUPD")
        self.view.addSubview(dupdButton)
        let emsButton = CustomRadioButton(frame: CGRect(x: Int(originX+Int(0.5*Double(buttonWidth))), y: originY - buttonSpacing/4, width: radioButtonWidth, height: buttonHeight), title: "EMS")
        self.view.addSubview(emsButton)
        //radioButtonController.setButtonsArray([button1!,button2!,button3!])
    }
    
    private func genTextFields(){
        let subjectField = CustomTextField(frame: CGRect(x: Int(originX-fieldWidth/2), y: originY + buttonSpacing/3, width: fieldWidth, height: fieldHeight), title: "Describe the Problem")
        self.view.addSubview(subjectField)
    }
    
    @IBAction func onCalendarButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarController") as! CalendarViewController
        self.present(controller, animated: true, completion: nil)
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
