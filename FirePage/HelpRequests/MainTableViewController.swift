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

class MainTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 179 - 110 - 20 - 3
    let kOpenCellHeight: CGFloat = 488 - 319 - 30 + 5 + 170 - 3
    let kRowsCount = 100
    var cellHeights: [CGFloat] = []
    
    var indexPathOfSelectedRow: IndexPath!
    var selectedCell: DemoCell!
    
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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "xdcell")
        self.tableView.register(UINib.init(nibName: "HeaderViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: "xdcell")
        setup()
        
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
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
extension MainTableViewController {
    
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
            guard case let cell as HeaderViewCellTableViewCell = cell else {
                return
            }
            cell.backgroundColor = .clear
            return
        }
        guard case let cell as DemoCell = cell else {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "xdcell", for: indexPath) as! HeaderViewCellTableViewCell
            cell.backgroundColor = .clear
            cell.dateLabel.text = humanReadableDate(dateString: myHelpRequestsOrderedKeys[(indexPath.section)/2])
            return cell
        }
        
        let helpRequests: [HelpRequest] = myHelpRequests[myHelpRequestsOrderedKeys[(indexPath.section - 1)/2]]!
        
        if (helpRequests.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
            cell.foregroundDescription.text = "No Help Requests"
            cell.foregroundBackground.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            cell.foregroundTimeBackground.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            
            cell.foregroundTime.text = ""
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let helpRequest: HelpRequest = helpRequests[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
        
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
            let cell = tableView.cellForRow(at: indexPath) as! HeaderViewCellTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.isUserInteractionEnabled = false
            return
        }
        
        indexPathOfSelectedRow = indexPath
        
        let cell = tableView.cellForRow(at: indexPath) as! DemoCell
        
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
    
    func orderDates(unorderedKeys: [String]) -> [String] {
        var dates: [Date] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        for dateString in unorderedKeys {
            let date = formatter.date(from: dateString)
            if let date = date {
                dates.append(date)
            }
        }
        
        let sortedDates = dates.sorted(by: { $0.compare($1) == .orderedDescending })
        
        var orderedKeys: [String] = []
        for date in sortedDates {
            let dateString = formatter.string(from: date)
            orderedKeys.append(dateString)
        }
        
        return orderedKeys
    }
    
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
    
    func humanReadableTime(timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.date(from: timeString)
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time!)
        
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let rect = CGRect(x: 10, y:10, width: UIScreen.main.bounds.width, height: 44)
//        let myView = UIView(frame: rect)
//        myView.backgroundColor = UIColor.cyan
//        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//        myLabel.backgroundColor = UIColor.green
//        myLabel.center = CGPoint(x: myView.frame.midX, y: myView.frame.midY)
//        myLabel.text = "Poopyheads"
//        myView.addSubview(myLabel)
//        //let headerView = Bundle.main.loadNibNamed("HeaderViewCellTableViewCell", owner: self, options: nil)?.first as! HeaderViewCellTableViewCell
//        //if (myHelpRequestsOrderedKeys.count > section) {
//            //headerView.randomLabel.text = myHelpRequestsOrderedKeys[section]
//        //}
//        return myView
//    }
    
    
}
