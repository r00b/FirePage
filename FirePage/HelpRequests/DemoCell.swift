//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell

class DemoCell: FoldingCell {
    
    var expanded: Bool = false
    
    @IBOutlet weak var foregroundTime: UILabel!
    @IBOutlet weak var foregroundDescription: UILabel!
    @IBOutlet weak var expansionTime: UILabel!
    @IBOutlet weak var expansionOnCallGroup: UILabel!
    @IBOutlet weak var expansionDescription: UITextView!
    @IBOutlet weak var expansionSender: UILabel!
    @IBOutlet weak var expansionLocation: UILabel!
    @IBOutlet weak var expansionResolution: UITextView!
    @IBOutlet weak var resolveButton: UIButton!
    
    override func awakeFromNib() {
    //foregroundView.layer.cornerRadius = 10
    //foregroundView.layer.masksToBounds = true
    super.awakeFromNib()
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
    let durations = [0.15, 0.14, 0.13, 0.12, 0.11, 0.1]
    return durations[itemIndex]
  }
  
}

// MARK: - Actions ⚡️
extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
  }
  
}
