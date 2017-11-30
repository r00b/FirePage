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

    // MARK: Global Variables
    private var cells = [DormCollectionViewCell]()
    private var dormDic = [String:String]()
    private var currDorm = ""
    
    // MARK: Horizontal Menu
    let cellID = "dormCell"
    @IBOutlet weak var dormMenu: UICollectionView!
    
    // MARK: button status
    private var dormClicked = false;
    private var campusClicked = false;
    private var callClicked = false;
    
    // MARK: Dorm info
    private var selectedDorm = "Epworth"
    private var eastDorms = ["Epworth","East","Randolph","Bell Tower"]

    //This will be replaced by firebase pull
    private var eastPhones = [String]()
    
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
    @IBOutlet weak var locationField: FireTextField!
    
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
        locationField.useUnderline()
        updateLabels()
        self.currPhone = phoneList[1]
        DB.getDormsMap(reloadFunction: setDormDic)
        /*
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.dormDic = ["Epworth":"N2Group"]
            print("reload me")
            self.eastDorms = []
            self.dormMenu.reloadData()
        }
         */
        dormMenu.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setDormDic(dictionary: [String: String]){
        dormDic = dictionary
        print(dictionary)
        eastDorms = Array(dormDic.keys)
        dormMenu.reloadData()
        cells = [DormCollectionViewCell]()
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
        print("reloaded")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DormCollectionViewCell
        cell.dorm = eastDorms[indexPath.row]
        cell.dormPhoto.image = #imageLiteral(resourceName: "Hot")
        cell.dormPhoto.layer.borderWidth = 0
        cell.dormPhoto.layer.masksToBounds = false
        cell.dormPhoto.layer.borderColor = UIColor.black.cgColor
        cell.dormPhoto.layer.cornerRadius = cell.dormPhoto.frame.height/2
        cell.dormPhoto.clipsToBounds = true
        cell.cellNum = "5857979725"
        cell.dormLabel.text = eastDorms[indexPath.row]
        cells.append(cell);
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //phoneList[0] = eastPhones[indexPath.row]
        phoneList[0] = "5857979725"
        clearSelected()
        cells[indexPath.row].dormPhoto.layer.borderWidth = 4.0
        cells[indexPath.row].dormPhoto.layer.borderColor = UIColor.white.cgColor
        currDorm = cells[indexPath.row].dorm
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
        dormMenu.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    private func clearSelected(){
        for cell in cells{
            cell.dormPhoto.layer.borderWidth = 0
        }
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
