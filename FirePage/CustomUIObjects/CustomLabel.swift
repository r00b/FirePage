//
//  CustomLabel.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/8/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class CustomLabel:UILabel{
    required init(frame: CGRect,title:String) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        textAlignment = NSTextAlignment.center
        text=title
        textColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(newText: String){
        text = newText
    }
}

