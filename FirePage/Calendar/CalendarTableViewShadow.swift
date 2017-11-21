//
//  CalendarTableViewFooterView.swift
//  FirePage
//
//  Created by Robert Steilberg on 11/21/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit

class CalendarTableViewShadow: UIView {

    override func draw(_ rect: CGRect) {
        // draw shadow on inner view
        let shadowPath = UIBezierPath(rect: layer.bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }

}
