//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import FoldingCell

class HelpRequestsTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 46
    let kOpenCellHeight: CGFloat = 311
    var cellHeights: [CGFloat] = []
    
    var indexPathOfSelectedRow: IndexPath!
    var selectedCell: HelpRequestCell!
    
    // TODO : Update hardcoded RA!
    // TODO : Cell heights bug
    var hardcodedRA: String = (SessionInfo.account?.getFirstName())!
    
    var myHelpRequests: [String: [HelpRequest]] = [:]
    var myHelpRequestsOrderedKeys: [String] = []
    
    @IBAction func resolvePage(_ sender: UIButton) {
        if (indexPathOfSelectedRow != nil && selectedCell != nil) {
            var helpRequests: [HelpRequest] = myHelpRequests[myHelpRequestsOrderedKeys[(indexPathOfSelectedRow.section - 1)/2]]!
            helpRequests[indexPathOfSelectedRow.row].isResolved = true
            helpRequests[indexPathOfSelectedRow.row].resolution = selectedCell.expansionResolution.text
            DB.addHelpRequests(onCallGroup: helpRequests[indexPathOfSelectedRow.row].onCallGroup, day: myHelpRequestsOrderedKeys[(indexPathOfSelectedRow.section - 1)/2], helpRequests: helpRequests)
        }
    }
    override func viewDidLoad() {
        
        DB.getHelpRequests(RA: hardcodedRA, reloadFunction: reloadTableViewData)
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateDisplayCell")
        self.tableView.register(UINib.init(nibName: "DateDisplayCell", bundle: nil), forCellReuseIdentifier: "DateDisplayCell")
        setup()
        
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: 100)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 231/255, alpha: 255/255)
    }
    
    func reloadTableViewData(requests: [String: [HelpRequest]]){
        myHelpRequests = requests
        myHelpRequestsOrderedKeys = orderDates(unorderedKeys: Array(myHelpRequests.keys))
        tableView.reloadData()
    }

    
}

// MARK: - TableView
extension HelpRequestsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2*myHelpRequestsOrderedKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (2*myHelpRequestsOrderedKeys.count <= section) {
            return 0
        }
        if (section % 2 == 0) {
            return 1
        }
        if let numRows = myHelpRequests[myHelpRequestsOrderedKeys[(section - 1)/2]] {
            if (numRows.count == 0) {
                return 1
            }
            return numRows.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.section % 2 == 0) {
            guard case let cell as DateDisplayCell = cell else {
                return
            }
            cell.backgroundColor = .clear
            return
        }
        guard case let cell as HelpRequestCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion:nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateDisplayCell", for: indexPath) as! DateDisplayCell
            cell.backgroundColor = .clear
            cell.dateLabel.text = humanReadableDate(dateString: myHelpRequestsOrderedKeys[(indexPath.section)/2])
            return cell
        }
        
        let helpRequests: [HelpRequest] = myHelpRequests[myHelpRequestsOrderedKeys[(indexPath.section - 1)/2]]!
        
        if (helpRequests.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelpRequestCell", for: indexPath) as! HelpRequestCell
            cell.foregroundDescription.text = "No Help Requests"
            cell.foregroundBackground.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            cell.foregroundTimeBackground.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            
            cell.foregroundTime.text = ""
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let helpRequest: HelpRequest = helpRequests[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpRequestCell", for: indexPath) as! HelpRequestCell
        
        cell.foregroundTime.text = humanReadableTime(timeString: helpRequest.time)
        cell.foregroundDescription.text = helpRequest.description
        cell.expansionTime.text = humanReadableTime(timeString: helpRequest.time)
        cell.expansionOnCallGroup.text = helpRequest.onCallGroup
        cell.expansionDescription.text = helpRequest.description
        cell.expansionSender.text = helpRequest.fromPerson
        cell.expansionLocation.text = helpRequest.location
        
        if (helpRequest.resolution != nil) {
            cell.expansionResolution.text = helpRequest.resolution!
            print("people")
        }
        
        if (helpRequest.isResolved) {
            cell.resolveButton.setTitle("SAVE", for: .normal)
        
            cell.foregroundBackground.backgroundColor = UIColor.white
            cell.foregroundLabel.textColor = UIColor(red:0.59, green:0.53, blue:0.53, alpha:1.0)
            cell.foregroundTimeBackground.backgroundColor = UIColor.white
            cell.foregroundTimeLabel.textColor = UIColor(red:0.59, green:0.53, blue:0.53, alpha:1.0)
            
            cell.barView.backgroundColor = UIColor.white
            cell.expansionLabel.textColor = UIColor(red:0.59, green:0.53, blue:0.53, alpha:1.0)
            cell.backgroundTimeLabel.textColor = UIColor(red:0.59, green:0.53, blue:0.53, alpha:1.0)
            print("peoplx")
        } else {
            cell.resolveButton.setTitle("RESOLVE", for: .normal)
            
            cell.foregroundBackground.backgroundColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
            cell.foregroundLabel.textColor = UIColor.white
            cell.foregroundTimeBackground.backgroundColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
            cell.foregroundTimeLabel.textColor = UIColor.white
            
            cell.barView.backgroundColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
            cell.expansionLabel.textColor = UIColor.white
            cell.backgroundTimeLabel.textColor = UIColor.white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section % 2 == 0) {
            return 25
        }
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section % 2 == 0) {
            let cell = tableView.cellForRow(at: indexPath) as! DateDisplayCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.isUserInteractionEnabled = false
            return
        }
        
        indexPathOfSelectedRow = indexPath
        
        let cell = tableView.cellForRow(at: indexPath) as! HelpRequestCell
        
        selectedCell = cell
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    
    /**
     Converts the unordered dates for the help requests into descending order to display
     correctly in the user interface.
     
     - Parameter unorderedKeys:   The keys (dates) to order, each formatted as 12-07-2017.
     
     - Returns: A new string array with dates in descending order, each formatted as 12-07-2017.
     */
    func orderDates(unorderedKeys: [String]) -> [String] {
        // First convert date strings to Date objects via a DateFormatter object
        var dates: [Date] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        for dateString in unorderedKeys {
            let date = formatter.date(from: dateString)
            if let date = date {
                dates.append(date)
            }
        }
        
        // Sort the dates
        let sortedDates = dates.sorted(by: { $0.compare($1) == .orderedDescending })
        
        // Reconstruct an ordered array of date strings from the sorted array of Date objects
        var orderedKeys: [String] = []
        for date in sortedDates {
            let dateString = formatter.string(from: date)
            orderedKeys.append(dateString)
        }
        
        // Return ordered array of date strings
        return orderedKeys
    }
    
    /**
     Converts the original date format into a decidely more human-readable format. In addition,
     if the string is on today or yesterday's date, it will return "TODAY" or "YESTERDAY"
     respectively.
     
     - Parameter dateString:   The date in string format, formatted as 12-07-2017.
     
     - Returns: The date in string format, formatted as 12.04, 12.17, or 08.17.
     */
    func humanReadableDate(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let date = formatter.date(from: dateString)
        
        if Calendar.current.isDateInToday(date!) {
            return "TODAY"
        } else if(Calendar.current.isDateInYesterday(date!)) {
            return "YESTERDAY"
        } else {
            formatter.dateFormat = "M.dd"
            return formatter.string(from: date!)
        }
    }
    
    /**
     Converts the original time format into a decidely more human-readable format.
     
     - Parameter dateString:   The time in string format, formatted as 23:55:21.
     
     - Returns: The time in string format, formatted as 11:55 PM.
     */
    func humanReadableTime(timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.date(from: timeString)
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time!)
    }
    
}
