//
//  JTAppleCalendarExtension.swift
//  FirePage
//
//  Created by Robert Steilberg on 11/13/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import JTAppleCalendar

// MARK: JTAppleCalendarViewDataSource

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
}


// MARK: JTAppleCalendarViewDelegate

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    // MARK: Delegate functions
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let customCell = cell as! CalendarCell
        calendarCell(customCell, cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let newCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        return calendarCell(newCell, cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    // called on scroll to new month
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setCalendarViewHeader(from: visibleDates)
    }
    
    // MARK: Private functions
    
    @discardableResult
    func calendarCell(_ cell: CalendarCell, _ cellState: CellState) -> CalendarCell {
        cell.dateLabel.text = cellState.text
        cell.selectedView.isHidden = true
        
        // set up default label colors
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = insideMonthLabelColor
        } else {
            cell.dateLabel.textColor = outsideMonthLabelColor
        }
        
        // check if a user is assigned to this date
        guard let userName = userDates[cellState.date] else { return cell }
        
        // color each CalendarCell as necessary
        if activeUsers[userName]! {
            cell.selectedView.isHidden = false
            if cellState.dateBelongsTo == .thisMonth {
                cell.selectedView.backgroundColor = userColors[userName]
                cell.dateLabel.textColor = selectedDayLabelColor
            } else {
                cell.selectedView.backgroundColor = userColors[userName]?.withAlphaComponent(0.35)
                cell.dateLabel.textColor = outsideMonthLabelColor
            }
        }
        return cell
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        if let userName = userDates[cellState.date] {
            if selectedUser == userName {
                selectedUser = ""
                // user already selected, go to default view (select all)
                activeUsers = activeUsers.mapValues({(Bool) -> Bool in return true})
            } else {
                // user not selected
                selectedUser = userName
                _ = activeUsers.map({ (user: String, Bool) in
                    // only selectedUser is active
                    activeUsers[user] = (user == selectedUser)
                })
            }
        }
        calendarView.reloadData()
    }
}

