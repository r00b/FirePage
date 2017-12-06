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
    
    // calendar min and max dates
    var startDate: Date!
    var endDate: Date!
    
    var onCallGroups: [String]?
    var currOnCallGroup: String? {
        willSet(newOnCallGroup) {
            prevOnCallGroup = currOnCallGroup
        }
    }
    var prevOnCallGroup: String?
    var userDates = [Date : String]()
    var userColors = [String : UIColor]()
    var selectedUsers = [String : Bool]() // users that are currently highlighted
    var selectedUser = ""
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet var groupButtons: [UIButton]!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var onCallGroupLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initCalendarView()
        initTableView()
        initDatabase()
    }
    
    
    // MARK: Private functions
    
    func initNavigationBar() {
        // set navigation bar background and text color
        navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // set basic properties on the calendar UI, only called once
    func initCalendarView() {
        // selected view spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.visibleDates { (visibleDates) in
            self.setCalendarViewHeader(from: visibleDates)
        }
        // on default scroll to current date
        calendarView.scrollToDate(Date(), animateScroll: false)
    }
    
    func initTableView() {
        // set up "Show All" footer button in table view
        let footerGesture = UITapGestureRecognizer(target: self, action: #selector(resetSelectedUsers))
        footerView.addGestureRecognizer(footerGesture)
    }
    
    // set up initial listeners on OnCallGroup
    func initDatabase() {
        // get list of onCallGroups associated with current user
        self.onCallGroups = SessionInfo.account?.getOnCallGroups()!
        // show arrow buttons for onCallGroup only if user has more than 1
        if onCallGroups!.count > 1 {
            groupButtons = groupButtons.map { $0.isHidden = false; return $0 }
        } else {
            groupButtons = groupButtons.map { $0.isHidden = true; return $0 }
        }
        // default group is first in list
        self.currOnCallGroup = self.onCallGroups?[0]
        self.onCallGroupLabel.text = self.currOnCallGroup
        // set database listener
        DB.getCalendar(prevGroup: prevOnCallGroup, group: currOnCallGroup!, reloadFunction: receiveData)
    }
    
    // callback for getting data from the database
    func receiveData(calendar: [String : String]) {
        for (date, userName) in calendar {
            // create Date object and store it
            formatter.dateFormat = "MM-dd-yyyy"
            let generatedDate = formatter.date(from: date)
            userDates[generatedDate!] = userName
            
            // denote user as highlighted
            selectedUsers[userName] = true
            
            // assign a color to the user
            if userColors[userName] == nil { // don't reassign colors
                userColors[userName] = colors[userColors.count]
            }
        }
        reloadViews()
    }
    
    // sets month and year labels in calendar header, called on calendar scroll
    func setCalendarViewHeader(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func clearUserData() {
        userDates = [Date : String]()
        userColors = [String : UIColor]()
        selectedUsers = [String : Bool]()
        selectedUser = ""
    }
    
    // designate a user with userName as selected
    func selectUser(userName: String) {
        selectedUser = userName
        _ = selectedUsers.map({ (user: String, Bool) in
            // only selectedUser should be active
            selectedUsers[user] = (user == selectedUser)
        })
        reloadViews()
    }
    
    // reset all users to be selected
    @objc func resetSelectedUsers() {
        selectedUser = ""
        // user already selected, go to default view (select all)
        selectedUsers = selectedUsers.mapValues({(Bool) -> Bool in return true})
        reloadViews()
    }
    
    // scroll the calendar forward or backward by deltaMonth months
    func scrollCalendar(changeInMonth: Int) {
        let currDate = calendarView.visibleDates().monthDates.first!.date
        let currMonth = Calendar.current.component(.month, from: currDate)
        let currYear = Calendar.current.component(.year, from: currDate)
        
        let startMonth = Calendar.current.component(.month, from: startDate)
        let startYear = Calendar.current.component(.year, from: startDate)
        let endMonth = Calendar.current.component(.month, from: endDate)
        let endYear = Calendar.current.component(.year, from: endDate)
        
        if changeInMonth < 0 && currMonth == startMonth && currYear == startYear {
            presentAlert(title: "Earliest Month Reached", message: "You've reached the earliest stored month.")
        } else if changeInMonth > 0 && currMonth == endMonth && currYear == endYear {
            presentAlert(title: "Farthest Month Reached", message: "You've reached the farthest stored month.")
        } else {
            let newDate = Calendar.current.date(byAdding: .month, value: changeInMonth, to: currDate)
            calendarView.scrollToDate(newDate!)
        }
    }
    
    // present a popup alert
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeOnCallGroup() {
        clearUserData()
        self.onCallGroupLabel.text = self.currOnCallGroup
        // set new database listener for new onCallGroup
        DB.getCalendar(prevGroup: prevOnCallGroup, group: currOnCallGroup!, reloadFunction: receiveData)
    }
    
    func reloadViews() {
        // force UI reload on the main thread
        DispatchQueue.main.async {
            self.calendarView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func scrollCalendarLeft(_ sender: UIButton) {
        scrollCalendar(changeInMonth: -1)
    }
    
    @IBAction func scrollCalendarRight(_ sender: UIButton) {
        scrollCalendar(changeInMonth: 1)
    }
    
    @IBAction func scrollOnCallGroupLeft(_ sender: UIButton) {
        var nextGroupIdx = onCallGroups!.index(of: currOnCallGroup!)! - 1
        if nextGroupIdx == -1 {
            nextGroupIdx = onCallGroups!.count - 1
        }
        currOnCallGroup = onCallGroups![nextGroupIdx]
        changeOnCallGroup()
    }
    
    @IBAction func scrollOnCallGroupRight(_ sender: UIButton) {
        var nextGroupIdx = onCallGroups!.index(of: currOnCallGroup!)! + 1
        if nextGroupIdx == onCallGroups!.count {
            nextGroupIdx = 0
        }
        currOnCallGroup = onCallGroups![nextGroupIdx]
        changeOnCallGroup()
    }
    
}
