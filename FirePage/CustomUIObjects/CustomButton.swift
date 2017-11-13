//
//  CustomButton.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/8/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton{
    var toggleImage: UIImage?
    required init(frame: CGRect, title:String) {
        super.init(frame:frame)
        backgroundColor = UIColor.red
        setTitleColor(UIColor.white, for: .normal)
        setTitle(title, for: .normal)
        layer.cornerRadius = frame.height/4
    }
    
    required init(frame: CGRect, image:UIImage){
        super.init(frame:frame)
        setImage(image, for: .normal)
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
    
    func toggleImageDisplayed(){
        setImage(toggleImage, for: .normal)
    }
    
}
