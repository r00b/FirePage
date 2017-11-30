//
//  FireButton.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/29/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class FireButton: UIButton{
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.lightGray
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        
    }
}

