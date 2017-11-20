//
//  CalendarViewController.swift
//  FirePage
//
//  Created by Robert Steilberg on 11/13/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let formatter = DateFormatter()
    
    // color of date label when selected
    let selectedDayColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.0) // #F6F6F8
    // color of date label when not selected and current month
    let insideMonthColor = UIColor(red:0.48, green:0.52, blue:0.64, alpha:1.0) // #7B85A3
    // color of date label when not selected and not current month
    let outsideMonthColor = UIColor(red:0.88, green:0.89, blue:0.91, alpha:1.0) // #E0E3E7
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
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
            if (cellState.dateBelongsTo == .thisMonth) {
                validCell.selectedView.backgroundColor = insideMonthViewColor
            } else {
                validCell.selectedView.backgroundColor = outsideMonthViewColor
            }
        } else {
            validCell.selectedView.isHidden = true
            
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedDayColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = insideMonthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
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

