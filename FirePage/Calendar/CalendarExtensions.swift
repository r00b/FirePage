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
                resetActiveUsers()
            } else {
                // user not already selected
                selectUser(userName: userName)
            }
        }
        tableView.reloadData()
    }
}


// MARK: UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        let user = Array(activeUsers.keys)[indexPath.row]
        cell.title.text = user
        
        if user == selectedUser {
            cell.title.textColor = UIColor.white
            cell.titleView.backgroundColor = userColors[user]
        } else {
            cell.title.textColor = userColors[user]
            cell.titleView.backgroundColor = UIColor.white
        }
        cell.accentView.backgroundColor = userColors[user]
        return cell
    }
    
    
}


// MARK: UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CalendarTableViewCell
        let chosenUser = cell.title.text!
        
        if selectedUser == chosenUser {
            resetActiveUsers()
            // color cell to show deselection
            cell.titleView.backgroundColor = UIColor.white
            cell.title.textColor = userColors[chosenUser]
        } else {
            // user not already selected
            selectUser(userName: chosenUser)
            // color cell to show selection
            cell.titleView.backgroundColor = userColors[chosenUser]
            cell.title.textColor = UIColor.white
        }
    }
    
}

