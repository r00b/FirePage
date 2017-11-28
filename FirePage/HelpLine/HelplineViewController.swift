//
//  HelpLineViewController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/12/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class HelplineViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    // MARK: Horizontal Menu
    let cellID = "dormCell"
    @IBOutlet weak var dormMenu: UICollectionView!
    
    // MARK: button status
    private var dormClicked = false;
    private var campusClicked = false;
    private var callClicked = false;
    
    // MARK: Dorm info
    private var selectedDorm = "Epworth"
    private var eastDorms = ["Alspaugh","Bassett","Brown","Pegram","East House","Epworth","Giles","Jarvis","Wilson","Gilbert-Addoms","Southgate","Blackwell","Randolph","Bell Tower","Trinity"]
    //This will be replaced by firebase pull
    private var eastPhones = ["5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725","5857979725"]
    
    // MARK: Campus info
    private var selectedCampus = "East Campus"
    private var campusList = ["East Campus","West Campus"]
    
    // MARK: Outlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var subjectField: FireTextField!
    @IBOutlet weak var dormButton: UIButton!
    @IBOutlet weak var campusButton: UIButton!
    @IBOutlet weak var dormLabel: UILabel!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    
    // MARK: Actions
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.setValue(Float(lroundf(slider.value)), animated: true)
        currPhone = self.phoneList[Int(sender.value)]
    }
    
    @IBAction func campusClick(_ sender: Any) {
        self.campusClicked = !self.campusClicked
        self.dormMenu.isHidden = self.campusClicked
        let newImage = self.campusClicked ? #imageLiteral(resourceName: "contract") : #imageLiteral(resourceName: "expand")
        campusButton.setImage(newImage, for: .normal)
    }
    
    @IBAction func dormClick(_ sender: Any) {
        self.dormClicked = !self.dormClicked
        self.dormMenu.isHidden = self.dormClicked
        self.dormButton.imageView?.image = self.dormClicked ? #imageLiteral(resourceName: "contract") : #imageLiteral(resourceName: "expand")
        let newImage = self.dormClicked ? #imageLiteral(resourceName: "contract") : #imageLiteral(resourceName: "expand")
        dormButton.setImage(newImage, for: .normal)
    }

    @IBAction func callClick(_ sender: Any) {
        self.callClicked = !self.callClicked
        //let newImage = self.callClicked ?#imageLiteral(resourceName: "hangup"): #imageLiteral(resourceName: "helpPhone")
        //callButton.setImage(newImage, for: .normal)
        if let url = URL(string: "tel://\(currPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: Phone Setup
    private var phoneList = ["5857979725","5857979725","5857979725"]
    private var currPhone: String = ""
    private var handle: AuthStateDidChangeListenerHandle?
    let reuseIdentifier = "dormCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectField.useUnderline()
        updateLabels()
        self.currPhone = phoneList[1]
        // Do any additional setup after loading the view.
    }
    
    private func updateLabels(){
        dormLabel.text = self.selectedDorm
        campusLabel.text = self.selectedCampus
    }
    
    
    // MARK: Horizontal Menu functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eastDorms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DormCollectionViewCell
        cell.dorm = eastDorms[indexPath.row]
        cell.dormPhoto.image = #imageLiteral(resourceName: "Hot")
        cell.cellNum = "5857979725"
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        phoneList[0] = eastPhones[indexPath.row]
        //print(eastDorms[indexPath.row])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Handles Auth for HelpLine
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
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
