//
//  DataModel.swift
//  FirePage
//
//  Created by Theodore Franceschi on 11/7/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation


enum FireRole : String{
    case RA = "RA"
    case RC = "RC"
    case GR = "GR"
    case Student = "Student"
}
class Account{
    
    private var firstName = "Harshil"
    private var lastName = "Garg"
    private var userName = "EggsD"
    private var phoneNumber = "6666666666"
    private var keyNum = "git idiot"
    private var role = FireRole.Student
    
    init(_ first:String, _ last:String, _ phone:String, _ key:String, _ user:String) {
        firstName = first
        lastName = last
        userName = user
        phoneNumber = phone
        keyNum = key
    }
    
    func getFirstName()->String{
        return firstName
    }
    
    func getLastName()->String{
        return lastName
    }
    
    func getUserName()->String{
        return userName
    }
    
    func getPhoneNumber()->String{
        return phoneNumber
    }
    
    func getkeyNum()->String{
        return keyNum
    }
}

struct PhoneCall{
    private var subject = "none"
    private var caller: String
    private var campus: String
    private var dorm: String
    
    init(_ subj:String,_ calling:String,_ camp:String,_ dorm:String) {
        self.subject = subj
        self.caller = calling
        self.campus = camp
        self.dorm = dorm
    }
}
