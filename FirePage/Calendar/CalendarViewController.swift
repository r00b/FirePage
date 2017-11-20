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
    
    let formatter = DateFormatter()
    
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
    
    // color of date label when selected
    let selectedDayColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.0) // #F6F6F8
    // color of date label when not selected and current month
    let insideMonthColor = UIColor(red:0.48, green:0.52, blue:0.64, alpha:1.0) // #7B85A3
    // color of date label when not selected and not current month
    let outsideMonthColor = UIColor(red:0.69, green:0.70, blue:0.72, alpha:1.0) // #B0B3B7
    
    let insideMonthViewColor = UIColor(red:0.55, green:0.54, blue:1.00, alpha:1.0) // #8C8AFF
    let outsideMonthViewColor = UIColor(red:0.77, green:0.77, blue:1.00, alpha:1.0); // #C5C4FF
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var startDate: Date!
    var endDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendarView()
        
        let ref : DatabaseReference! = Database.database().reference()
        ref.child("OnCallGroup").child("BlackwellGroup").child("Calendar").observe(DataEventType.value, with: { (snapshot) in
            let dates = snapshot.value as? [String : String] ?? [:]
            self.renderDates(dates: dates)
        })
        
    }
    
    var userDates = [Date : String]()
    var userColors = [String : UIColor]()
    
    func renderDates(dates: [String : String]) {
        for (date, userName) in dates {
            formatter.dateFormat = "MM-dd-yyyy"
            let generatedDate = formatter.date(from: date)
            userDates[generatedDate!] = userName
            if userColors[userName] == nil {
                userColors[userName] = colors[userColors.count]
            }
        }
        calendarView.reloadData()
    }
    
    func renderCell(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if let userName = userDates[cellState.date] {
            validCell.selectedView.isHidden = false
            
            
            if cellState.dateBelongsTo == .thisMonth {
                validCell.selectedView.backgroundColor = userColors[userName]
                validCell.dateLabel.textColor = selectedDayColor
            } else {
                validCell.selectedView.backgroundColor = userColors[userName]?.withAlphaComponent(0.5)
                validCell.dateLabel.textColor = outsideMonthColor
            }
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = insideMonthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        //        if validCell.isSelected {
        //            validCell.selectedView.isHidden = false
        //            let userName = userDates[cellState.date]
        //            validCell.selectedView.backgroundColor = userColors[userName]
        ////            if (cellState.dateBelongsTo == .thisMonth) {
        ////                validCell.selectedView.backgroundColor = insideMonthViewColor
        ////            } else {
        ////                validCell.selectedView.backgroundColor = outsideMonthViewColor
        ////            }
        //        } else {
        //            validCell.selectedView.isHidden = true
        //
        //        }
    }
    
    func initCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.visibleDates { (visibleDates) in
            self.initViewsOfCalendar(from: visibleDates)
        }
        
        calendarView.scrollToDate(Date(), animateScroll: false)
    }
    
    func initViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    @IBAction func scrollLeft(_ sender: UIButton) {
        let currDate = calendarView.visibleDates().monthDates.first!.date
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currDate)
        
        let startMonth = Calendar.current.component(.month, from: startDate)
        let newMonth = Calendar.current.component(.month, from: newDate!)
        let startYear = Calendar.current.component(.year, from: startDate)
        let newYear = Calendar.current.component(.year, from: newDate!)
        if newMonth < startMonth && newYear <= startYear {
            let alert = UIAlertController(title: "Earliest Month Reached", message: "You've reached the earliest stored month.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            calendarView.scrollToDate(newDate!)
        }
    }
    
    @IBAction func scrollRight(_ sender: UIButton) {
        let currDate = calendarView.visibleDates().monthDates.first!.date
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currDate)
        
        let endMonth = Calendar.current.component(.month, from: endDate)
        let newMonth = Calendar.current.component(.month, from: newDate!)
        let endYear = Calendar.current.component(.year, from: endDate)
        let newYear = Calendar.current.component(.year, from: newDate!)
        if newMonth > endMonth && newYear >= endYear {
            
            let alert = UIAlertController(title: "Farthest Month Reached", message: "You've reached the farthest stored month.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            calendarView.scrollToDate(newDate!)
        }
    }
    
}

