//
//  CustomRadioButton.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/12/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class CustomRadioButton: UIButton{
    var toggleImage: UIImage?
    var clicked = false
    required init(frame: CGRect, title:String) {
        super.init(frame:frame)
        backgroundColor = UIColor.white
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        setTitleColor(UIColor.lightGray, for: .normal)
        setTitle(title, for: .normal)
        layer.cornerRadius = frame.height/8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setToggleImage(image:UIImage){
        toggleImage = image
    }
    
    func disable(){
        self.isUserInteractionEnabled = false
    }
    
    func reEnable(){
        self.isUserInteractionEnabled = true
    }
    
    func clickButton(){
        self.clicked = !self.clicked
    }
    
    
}
