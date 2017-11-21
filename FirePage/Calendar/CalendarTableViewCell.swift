//
//  CalendarTableViewCell.swift
//  FirePage
//
//  Created by Robert Steilberg on 11/21/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var accentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add shadow to inner view
        let shadowPath = UIBezierPath(rect: titleView.layer.bounds)
        titleView.layer.masksToBounds = false
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleView.layer.shadowOpacity = 0.5
        titleView.layer.shadowPath = shadowPath.cgPath
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
