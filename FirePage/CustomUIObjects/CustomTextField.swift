//
//  CustomTextField.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/7/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField{
    required init(frame: CGRect,title:String) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
        textColor = UIColor.black
        placeholder = title
        layer.cornerRadius = frame.height/4
        self.textAlignment = NSTextAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isFilled()->Bool{
        return !(self.text?.isEmpty)!
    }
    func setHighlightEmpty(){
        self.tintColor = UIColor.red
    }
    func setHighlightFilled(){
        self.tintColor = UIColor.white
    }
    func hideText(){
        self.isSecureTextEntry = true
    }
}

