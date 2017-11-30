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
    
    let kCloseCellHeight: CGFloat = 179 - 110 - 10
    let kOpenCellHeight: CGFloat = 488 - 319 - 30 + 5 + 180
    let kRowsCount = 100
    var cellHeights: [CGFloat] = []
    
    // TODO : Update hardcoded RA!
    // TODO : Cell heights bug
    var hardcodedRA: String = "Harshil"
    
    var myHelpRequests: [String: [HelpRequest]] = [:]
    var myHelpRequestsOrderedKeys: [String] = []
    
    override func viewDidLoad() {
        DB.getAllRAHelpRequests(RA: hardcodedRA, reloadFunction: reloadTableViewData)
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    func reloadTableViewData(requests: [String: [HelpRequest]]){
        myHelpRequests = requests
        myHelpRequestsOrderedKeys = Array(myHelpRequests.keys)
        print(myHelpRequestsOrderedKeys)
        tableView.reloadData()
    }
    
}

// MARK: - TableView
extension MainTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return myHelpRequestsOrderedKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (myHelpRequestsOrderedKeys.count <= section) {
            return 0
        }
        if let numRows = myHelpRequests[myHelpRequestsOrderedKeys[section]] {
//            print("The section is \(section)")
//            print("\n")
//            for row in numRows {
//                let full: String = (row.time + row.fromPerson + row.onCallGroup + row.date + row.location + "\(row.isResolved)" + row.description)
//                print(full)
//            }
//            print("\n")
            return numRows.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
        
        let helpRequests: [HelpRequest] = myHelpRequests[myHelpRequestsOrderedKeys[indexPath.section]]!
        let helpRequest: HelpRequest = helpRequests[indexPath.row]
        
        cell.foregroundTime.text = helpRequest.time
        cell.foregroundDescription.text = helpRequest.description
        cell.expansionTime.text = helpRequest.time
        cell.expansionOnCallGroup.text = helpRequest.onCallGroup
        cell.expansionDescription.text = helpRequest.description
        cell.expansionSender.text = helpRequest.fromPerson
        cell.expansionLocation.text = helpRequest.location
        
        if (helpRequest.resolution == nil) {
            cell.expansionResolution.text = "Kill yourself"
        } else {
            cell.expansionResolution.text = helpRequest.resolution!
        }
        
        if (helpRequest.isResolved) {
            cell.resolveButton.titleLabel?.text = "SAVE"
        } else {
            cell.resolveButton.titleLabel?.text = "RESOLVE"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 10, y:10, width: UIScreen.main.bounds.width, height: 44)
        let myView = UIView(frame: rect)
        myView.backgroundColor = UIColor.cyan
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        myLabel.backgroundColor = UIColor.green
        myLabel.center = CGPoint(x: myView.frame.midX, y: myView.frame.midY)
        myLabel.text = "Poopyheads"
        myView.addSubview(myLabel)
        //let headerView = Bundle.main.loadNibNamed("HeaderViewCellTableViewCell", owner: self, options: nil)?.first as! HeaderViewCellTableViewCell
        //if (myHelpRequestsOrderedKeys.count > section) {
            //headerView.randomLabel.text = myHelpRequestsOrderedKeys[section]
        //}
        return myView
    }
    
    
}
