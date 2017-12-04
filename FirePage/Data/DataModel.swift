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
    private var email = "harshil@firepage.com"
    private var phoneNumber = "9726559320"
    private var role = FireRole.RA
    private var daysOnCall: [String]?
    private var onCallGroups: [String]?
    
    init(_ first:String, _ last:String, _ phone:String, _ userRole:String, _ userEmail:String) {
        firstName = first
        lastName = last
        email = userEmail
        phoneNumber = phone
        if(userRole == "RA"){
            role = FireRole.RA
        }else if(userRole == "RC"){
            role = FireRole.RC
        }else{
            role = FireRole.Student
        }
    }
    
    init(email: String, userAttributeDict: [String: String]){
        firstName = userAttributeDict["firstName"]!
        lastName = userAttributeDict["lastName"]!
        self.email = email
        phoneNumber = userAttributeDict["phoneNumber"]!
        let userRole = userAttributeDict["role"]
        if(userRole == "RA"){
            role = FireRole.RA
        }else if(userRole == "RC"){
            role = FireRole.RC
        }else{
            role = FireRole.Student
        }
    }
    
    func getFirstName()->String{
        return firstName
    }
    
    func getLastName()->String{
        return lastName
    }
    
    func getEmail()->String{
        return email
    }
    
    func getPhoneNumber()->String{
        return phoneNumber
    }
    
    func getRole()->FireRole{
        return role
    }
    
    func setDaysOnCall(daysOnCall: [String]){
        self.daysOnCall = daysOnCall
    }
    
    func getDaysOnCall()->[String]?{
        return self.daysOnCall
    }
    
    func setOnCallGroups(onCallGroups: [String]){
        self.onCallGroups = onCallGroups
    }
    
    func getOnCallGroups()->[String]?{
        return self.onCallGroups
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

struct HelpRequest: CustomStringConvertible{
    public var time: String
    public var fromPerson: String
    public var onCallGroup: String
    public var date: String
    public var location: String
    public var isResolved: Bool
    public var description: String
    public var resolution: String?
    
    init(dictionary: NSDictionary){
        print(dictionary)
        self.time = dictionary.object(forKey: "time") as! String
        self.fromPerson = dictionary.object(forKey: "fromPerson") as! String
        self.onCallGroup = dictionary.object(forKey: "onCallGroup") as! String
        self.date = dictionary.object(forKey: "date") as! String
        self.location = dictionary.object(forKey: "Location") as! String
        if(dictionary.object(forKey: "isResolved") as? Bool == false){
            self.isResolved = false
        }else{
        if(dictionary.object(forKey: "isResolved") as! String == "true"){
            self.isResolved = true
        }else{
            self.isResolved = false
        }
        }
        if(dictionary.object(forKey: "resolution") != nil){
            self.resolution = dictionary.object(forKey: "resolution") as! String
        }
        self.description = dictionary.object(forKey: "description") as! String
    }
    
    init(){
        self.time = ""
        self.fromPerson = ""
        self.onCallGroup = ""
        self.date = ""
        self.location = ""
        self.isResolved = false
        self.description = ""
    }
    
    public func getHash() -> String{
        let full: String = (self.time + self.fromPerson + self.onCallGroup + self.date + self.location + "\(self.isResolved)" + self.description)
        return full.sha256()
    }
    
    public func getDictionary() -> [String: String]{
        var dictionary = [String: String]()
        dictionary["time"] = self.time
        dictionary["fromPerson"] = self.fromPerson
        dictionary["onCallGroup"] = self.onCallGroup
        dictionary["date"] = self.date
        dictionary["Location"] = self.location
        dictionary["isResolved"] = "\(self.isResolved)"
        dictionary["description"] = self.description
        if(resolution != nil && resolution != "Kill yourself"){
            dictionary["resolution"] = self.resolution
        }
        return dictionary
    }
}

