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
    
    
    
    let outsideMonthColor = UIColor(red:0.88, green:0.89, blue:0.91, alpha:1.0) // #E0E3E7
    let unselectedMonthColor = UIColor(red:0.48, green:0.52, blue:0.64, alpha:1.0) // #7B85A3
    let selectedMonthColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.0) // #F6F6F8
    let selectedDayColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.0) // #F6F6F8
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendarView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
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
                validCell.dateLabel.textColor = unselectedMonthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func initCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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

