//
//  CalendarViewController.swift
//  FirePage
//
//  Created by Robert Steilberg on 11/13/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase

class CalendarViewController: UIViewController {
    
    // MARK: Instance variables
    
    let formatter = DateFormatter()
    
    // NOTE: more than 10 users in an OnCallGroup will trigger an ArrayIndexOutOfBounds
    let colors: [UIColor] = [
        UIColor(red:1.00, green:0.69, blue:0.00, alpha:1.0),
        UIColor(red:0.36, green:0.91, blue:0.40, alpha:1.0),
        UIColor(red:0.55, green:0.54, blue:1.00, alpha:1.0),
        UIColor(red:0.76, green:0.36, blue:0.92, alpha:1.0),
        UIColor(red:0.65, green:0.22, blue:0.38, alpha:1.0),
        UIColor(red:0.38, green:0.23, blue:0.35, alpha:1.0),
        UIColor(red:0.98, green:0.45, blue:0.78, alpha:1.0),
        UIColor(red:0.03, green:0.30, blue:0.38, alpha:1.0),
        UIColor(red:0.54, green:0.92, blue:1.00, alpha:1.0),
        UIColor(red:0.89, green:0.71, blue:0.02, alpha:1.0)
    ]
    
    let selectedDayLabelColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.0) // #F6F6F8
    let insideMonthLabelColor = UIColor(red:0.48, green:0.52, blue:0.64, alpha:1.0) // #7B85A3
    let outsideMonthLabelColor = UIColor(red:0.69, green:0.70, blue:0.72, alpha:1.0) // #B0B3B7
    let insideMonthViewColor = UIColor(red:0.55, green:0.54, blue:1.00, alpha:1.0) // #8C8AFF
    let outsideMonthViewColor = UIColor(red:0.77, green:0.77, blue:1.00, alpha:1.0); // #C5C4FF
    
    var startDate: Date!
    var endDate: Date!
    
    var onCallGroups: [String]?
    var currOnCallGroup: String?
    var userDates = [Date : String]()
    var userColors = [String : UIColor]()
    var activeUsers = [String : Bool]() // users that are currently highlighted
    var selectedUser = ""
    
    let ref : DatabaseReference! = Database.database().reference()
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var onCallGroupLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendarView()
        initTableView()
        initDatabase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // clean up observers
        ref.child("OnCallGroup").child(currOnCallGroup!).child("Calendar").removeAllObservers()
    }
    
    
    // MARK: Private functions
    
    // set basic properties on the calendar UI, only called once
    func initCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.visibleDates { (visibleDates) in
            self.setCalendarViewHeader(from: visibleDates)
        }
        calendarView.scrollToDate(Date(), animateScroll: false)
    }
    
    func initTableView() {
        // set navigation bar background and text color
        navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        // set up "Show All" footer button in table view
        let footerGesture = UITapGestureRecognizer(target: self, action: #selector(resetActiveUsers))
        footerView.addGestureRecognizer(footerGesture)
    }
    
    // set up initial listeners on OnCallGroup
    func initDatabase() {
        // get names of all OnCallGroups
        ref.child("OnCallGroup").observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
            let groups = snapshot.value as? [String : AnyObject] ?? [:]
            self.onCallGroups = Array(groups.keys)
            // default group set to first in list from database
            self.currOnCallGroup = self.onCallGroups?[0]
            self.renderUserData()
        })
    }
    
    // sets month and year labels in calendar header, called on calendar scroll
    func setCalendarViewHeader(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    // populate cells with colors for the selected OnCallGroup
    func renderUserData() {
        // clear out data structures
        userDates = [Date : String]()
        userColors = [String : UIColor]()
        activeUsers = [String : Bool]()
        
        self.onCallGroupLabel.text = self.currOnCallGroup
        self.ref.child("OnCallGroup").child(self.currOnCallGroup!).child("Calendar").observe(DataEventType.value, with: { (snapshot) in
            let dates = snapshot.value as? [String : String] ?? [:]
            self.storeUserData(dates: dates)
            self.calendarView.reloadData()
            self.tableView.reloadData()
        })
    }
    
    // store user data from the database in accessible data structures
    func storeUserData(dates: [String : String]) {
        for (date, userName) in dates {
            // create Date object and store it
            formatter.dateFormat = "MM-dd-yyyy"
            let generatedDate = formatter.date(from: date)
            userDates[generatedDate!] = userName
            
            // denote user as highlighted
            activeUsers[userName] = true
            
            // assign a color to the user
            if userColors[userName] == nil { // don't reassign colors
                userColors[userName] = colors[userColors.count]
            }
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // designate a user with userName as selected
    func selectUser(userName: String) {
        selectedUser = userName
        _ = activeUsers.map({ (user: String, Bool) in
            // only selectedUser should be active
            activeUsers[user] = (user == selectedUser)
        })
        calendarView.reloadData() // push changes to calendar view
        tableView.reloadData() // push changes to table view
    }
    
    // reset all users to be active/selected
    @objc func resetActiveUsers() {
        selectedUser = ""
        // user already selected, go to default view (select all)
        activeUsers = activeUsers.mapValues({(Bool) -> Bool in return true})
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    
    // MARK: IBActions
    
    @IBAction func scrollCalendarLeft(_ sender: UIButton) {
        let currDate = calendarView.visibleDates().monthDates.first!.date
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currDate)
        
        let startMonth = Calendar.current.component(.month, from: startDate)
        let newMonth = Calendar.current.component(.month, from: newDate!)
        let startYear = Calendar.current.component(.year, from: startDate)
        let newYear = Calendar.current.component(.year, from: newDate!)
        if newMonth < startMonth && newYear <= startYear {
            presentAlert(title: "Earliest Month Reached", message: "You've reached the earliest stored month.")
        } else {
            calendarView.scrollToDate(newDate!)
        }
    }
    
    @IBAction func scrollCalendarRight(_ sender: UIButton) {
        let currDate = calendarView.visibleDates().monthDates.first!.date
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currDate)
        
        let endMonth = Calendar.current.component(.month, from: endDate)
        let newMonth = Calendar.current.component(.month, from: newDate!)
        let endYear = Calendar.current.component(.year, from: endDate)
        let newYear = Calendar.current.component(.year, from: newDate!)
        if newMonth > endMonth && newYear >= endYear {
            presentAlert(title: "Farthest Month Reached", message: "You've reached the farthest stored month.")
        } else {
            calendarView.scrollToDate(newDate!)
        }
    }
    
    @IBAction func scrollOnCallGroupLeft(_ sender: UIButton) {
        ref.child("OnCallGroup").child(self.currOnCallGroup!).child("Calendar").removeAllObservers()
        var nextGroupIdx = onCallGroups!.index(of: currOnCallGroup!)! - 1
        if nextGroupIdx == -1 {
            nextGroupIdx = onCallGroups!.count - 1
        }
        currOnCallGroup = onCallGroups![nextGroupIdx]
        renderUserData()
    }
    
    @IBAction func scrollOnCallGroupRight(_ sender: UIButton) {
        ref.child("OnCallGroup").child(self.currOnCallGroup!).child("Calendar").removeAllObservers()
        var nextGroupIdx = onCallGroups!.index(of: currOnCallGroup!)! + 1
        if nextGroupIdx == onCallGroups!.count {
            nextGroupIdx = 0
        }
        currOnCallGroup = onCallGroups![nextGroupIdx]
        renderUserData()
    }
    
}
