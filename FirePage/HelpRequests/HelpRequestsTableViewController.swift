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
    
    let red: UIColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
    let white: UIColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
    let gray: UIColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
    
    // Constants for cell heights depending on expansion/collapse.
    let kCloseCellHeight: CGFloat = 46
    let kOpenCellHeight: CGFloat = 311
    
    // Keeps track of HelpRequest cell heights.
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    // These two variables facilitate resolving of HelpRequests, and store the selected HelpRequest.
    var indexPathOfSelectedRow: IndexPath!
    var selectedCell: HelpRequestCell!
    
    // TODO : Cell heights bug
    var RA: String = (SessionInfo.account?.getFirstName())!
    
    // Our entire data model
    var myHelpRequests: [String: [HelpRequest]] = [:]
    
    // Keys from the data model, which are ordered (helps pseudo-order a dictionary)
    var myHelpRequestsOrderedKeys: [String] = []
    
    override func viewDidLoad() {
        DB.getHelpRequests(RA: RA, reloadFunction: reloadTableViewData)
        super.viewDidLoad()

        styleNavigationBar()
        registerCellsAndXib()
        setupTableView()
    }
    
    private func styleNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func registerCellsAndXib() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateDisplayCell")
        self.tableView.register(UINib.init(nibName: "DateDisplayCell", bundle: nil), forCellReuseIdentifier: "DateDisplayCell")
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 231/255, alpha: 255/255)
    }
    
    func reloadTableViewData(requests: [String: [HelpRequest]]){
        myHelpRequests = requests
        myHelpRequestsOrderedKeys = orderDates(unorderedKeys: Array(myHelpRequests.keys))
        tableView.reloadData()
    }
    
    // Handler when a page is attempted to be resolved or saved.
    @IBAction func resolvePage(_ sender: UIButton) {
        // Safety check.
        if (indexPathOfSelectedRow != nil && selectedCell != nil) {
            // We will not resolve a page without a resolution.
            if (selectedCell.expansionResolution.text != nil && selectedCell.expansionResolution.text != "") {
                let day = getTransformedSection(indexPath: indexPathOfSelectedRow)
                let row = indexPathOfSelectedRow.row
                var helpRequests: [HelpRequest] = myHelpRequests[day]!
                helpRequests[indexPathOfSelectedRow.row].isResolved = true
                helpRequests[indexPathOfSelectedRow.row].resolution = selectedCell.expansionResolution.text
                DB.addHelpRequests(onCallGroup: helpRequests[row].onCallGroup, day: day, helpRequests: helpRequests)
            }
            else {
                let alert = UIAlertController(title: "Help Request not resolved.", message: "Please enter a resolution.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableView
extension HelpRequestsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("Number of sections \(myHelpRequestsOrderedKeys.count*2)")
        return myHelpRequestsOrderedKeys.count*2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Prevent IndexOutOfBounds
        if (myHelpRequestsOrderedKeys.count*2 <= section) {
            print("A \(section)")
            return 0
        }
        // Return 1 if we are dealing with DateDisplayCells in the section.
        if (section % 2 == 0) {
            print("1 \(section)")
            return 1
        }
        // HelpRequestCells
        if let numRows = myHelpRequests[myHelpRequestsOrderedKeys[(section - 1)/2]] {
            // No Help Request were found, so return 1 so we can make a fake HelpRequestCell to state none were found.
            // See createNoHelpRequestsCell
            if (numRows.count == 0) {
                print("C \(section)")
                return 1
            }
            // Otherwise return the number of HelpRequests found
            print("\(numRows) \(section)")
            return numRows.count
        } else {
            print("E \(section)")
            return 0
        }
    }
    
    // Handles folding animation.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section % 2 == 0 {
            return
        }
        print("WILLDISPLAY")
        print(cellHeights)
        print("\n")
        guard case let cell as HelpRequestCell = cell else {
            return
        }
        cell.backgroundColor = .clear
        if cellHeights[indexPath] == nil {
            cellHeights[indexPath] = kCloseCellHeight
            cell.unfold(false, animated: false, completion:nil)
        } else if cellHeights[indexPath] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion:nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        cell.isUserInteractionEnabled = true
    }
    
    // Creates a cell given the row, be it DateDisplayCell or HelpRequestCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CELLROWAT")
        print(cellHeights)
        print("\n")
        // Create header cell for date display if section number is even, since each section of help requests
        // has a corresponding DateDisplayCell as the header.
        if (indexPath.section % 2 == 0) {
            return createDateDisplayCell(tableView: tableView, indexPath: indexPath)
        }
        
        // If we reach this point in the code, we are handling the sections of the table view which contain
        // help requests to display, so we retreive our list of help requests from our model given the section
        let helpRequests: [HelpRequest] = myHelpRequests[getTransformedSection(indexPath: indexPath)]!
        
        // If the number of help requests is zero or nil, we must show in the table that there are no help requests.
        // We mask a regular HelpRequestCell and change the message.
        if (helpRequests.count == 0) {
            return createNoHelpRequestsCell(tableView: tableView, indexPath: indexPath)
        }
        
        // We can now handle all remaining individual normal HelpRequest cells, so retreive the specific HelpRequest.
        let helpRequest: HelpRequest = helpRequests[indexPath.row]
        cellHeights[indexPath] = kCloseCellHeight
        return createHelpRequestCell(tableView: tableView, indexPath: indexPath, helpRequest: helpRequest)
    }
    
    // Sets the height for DateDisplayCells to be 25 and HelpRequestCells based on whether they are collapsed or expanded.
    // Whether a HelpRequestCell is expanded or collapsed is saved in the cellHeights array.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section % 2 == 0) {
            return 25
        }
        if (cellHeights[indexPath] == nil) {
            cellHeights[indexPath] = kCloseCellHeight
        }
        return cellHeights[indexPath]!
    }
    
    // Handles the expansion/collapse of a HelpRequestCell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // DateDisplayCell
        if indexPath.section % 2 == 0 {
            return
        }
        print("SELECTROWMETHOD")
        print(cellHeights)
        print("\n")
        indexPathOfSelectedRow = indexPath
        let cell = tableView.cellForRow(at: indexPath) as! HelpRequestCell
        selectedCell = cell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let cellIsCollapsed = (cellHeights[indexPath] == kCloseCellHeight || cellHeights[indexPath] == nil)
        if cellIsCollapsed {
            cellHeights[indexPath] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.5
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        cell.isUserInteractionEnabled = true
    }
    
    /**
     Retrieves the HelpRequests key (date) which corresponds with the given table view section we are looking at.
     
     - Parameter indexPath:   The indexPath to retrieve the section number `indexPath.section`
     
     - Returns: Date string for the day of the section.
     */
    private func getTransformedSection(indexPath: IndexPath) -> String {
        return myHelpRequestsOrderedKeys[(indexPath.section - 1)/2]
    }
    
    /**
     Creates DateDisplayCell and styles it.
     */
    private func createDateDisplayCell(tableView: UITableView, indexPath: IndexPath) -> DateDisplayCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateDisplayCell", for: indexPath) as! DateDisplayCell
        cell.backgroundColor = .clear
        cell.dateLabel.text = humanReadableDate(dateString: myHelpRequestsOrderedKeys[indexPath.section/2])
        return cell
    }
    
    /**
     Creates HelpRequestCell which is hackingly used to display that there are no HelpRequests. Ensures that the
     cell does not expand.
     */
    private func createNoHelpRequestsCell(tableView: UITableView, indexPath: IndexPath) -> HelpRequestCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpRequestCell", for: indexPath) as! HelpRequestCell
        
        // Change background and edit message.
        cell.foregroundDescription.text = "No Help Requests"
        cell.foregroundBackground.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        cell.foregroundTime.text = ""
        cell.foregroundTimeBackground.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        cell.foregroundLabel.textColor = UIColor.white
        // Hack to stop user from being able to expand/unfold this cell like a normal HelpRequestCell.
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    /**
     Creates a HelpRequestCell and populates all the necessary information based on its HelpRequest.
     */
    private func createHelpRequestCell(tableView: UITableView, indexPath: IndexPath, helpRequest: HelpRequest) -> HelpRequestCell {
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
            if (helpRequest.resolution?.contains("Resident running around"))! {
                print("UM")
                print(indexPath.section)
                print(indexPath.row)
                print(helpRequest)
                print("CLOSE")
            }
        }
         if (helpRequest.isResolved) {
            cell.resolveButton.setTitle("SAVE", for: .normal)
            cell.foregroundBackground.backgroundColor = white
            cell.foregroundLabel.textColor = gray
            cell.foregroundTimeBackground.backgroundColor = white
            cell.foregroundTimeLabel.textColor = gray
            cell.barView.backgroundColor = white
            cell.expansionLabel.textColor = gray
            cell.backgroundTimeLabel.textColor = gray
        } else {
            cell.resolveButton.setTitle("RESOLVE", for: .normal)
            cell.foregroundBackground.backgroundColor = red
            cell.foregroundLabel.textColor = white
            cell.foregroundTimeBackground.backgroundColor = red
            cell.foregroundTimeLabel.textColor = white
            cell.barView.backgroundColor = red
            cell.expansionLabel.textColor = white
            cell.backgroundTimeLabel.textColor = white
        }
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    /**
     Converts the unordered dates for the help requests into descending order to display
     correctly in the user interface.
     
     - Parameter unorderedKeys:   The keys (dates) to order, each formatted as 12-07-2017.
     
     - Returns: A new string array with dates in descending order, each formatted as 12-07-2017.
     */
    private func orderDates(unorderedKeys: [String]) -> [String] {
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
    private func humanReadableDate(dateString: String) -> String {
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
    private func humanReadableTime(timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.date(from: timeString)
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time!)
    }
    
}
