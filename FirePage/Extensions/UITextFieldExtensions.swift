//
//  UITextFieldExtensions.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/21/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
