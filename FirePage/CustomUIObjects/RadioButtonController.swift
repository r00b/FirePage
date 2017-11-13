//
//  RadioButtonController.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/12/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import UIKit

class RadioButtonController{
    
    private var buttonList = [CustomRadioButton]()
    private var selectedButton: CustomRadioButton!
    
    init(_ buttons:[CustomRadioButton]) {
        buttonList = buttons
        if(buttonList.count > 0){
            selectedButton = buttonList[0]
        }
    }
    
}
