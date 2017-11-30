//
//  Database.swift
//  FirePage
//
//  Created by The Ritler on 11/23/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class DB{
    static var rootRef = Database.database().reference()
    static var HelpRequests = rootRef.child("HelpRequests")
    static var OnCallGroup = rootRef.child("OnCallGroup")
    static var RA = rootRef.child("RA")
    static var Dorms = rootRef.child("Dorms")
    
    static func testConnection(){
        rootRef.child("test").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            print(value!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func getHelpRequest(requestID: String, append: @escaping (HelpRequest) -> Void) {
        HelpRequests.child(requestID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let helpRequest = HelpRequest(dictionary: value!)
            append(helpRequest)
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    static func getDaysOnCall(RA: String, reloadFunction: @escaping ([String]) -> Void){
        rootRef.child("RA").child(RA).child("DaysOnCall").observe(DataEventType.value, with: { (snapshot) in
            var daysOnCall = [String]()
            daysOnCall = snapshot.value! as! [String]
            reloadFunction(daysOnCall)
        })
    }
    
    static func getCalendar(onCallGroup: String, reloadFunction: @escaping ([String:String]) -> Void){
        
        OnCallGroup.child(onCallGroup).child("Calendar").observe(DataEventType.value, with: { (snapshot) in
            var calendar = [String: String]()
            calendar = snapshot.value! as! [String: String]
            reloadFunction(calendar)
        })
    }
    
    static func getHelpRequests(onCallGroup: String, day: String, reloadFunction: @escaping ([HelpRequest]) -> Void){

        var helpRequests = [HelpRequest]()
        OnCallGroup.child(onCallGroup).child("HelpRequests").child(day).observe(DataEventType.value, with: { (snapshot) in
            let encodedHelpRequests = snapshot.value as? [String]
            for encodedHelpRequest in encodedHelpRequests!{
                
                HelpRequests.child(encodedHelpRequest).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let helpRequest = HelpRequest(dictionary: value!)
                    helpRequests.append(helpRequest)
                })
            }
            let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                reloadFunction(helpRequests)
            }
        })
    }
    
    static func getAllRAHelpRequests(RA: String, reloadFunction: @escaping ([String: [HelpRequest]]) -> Void){
        self.RA.child(RA).child("DaysOnCall").observeSingleEvent(of: .value, with: { (snapshot) in
            let daysOnCall = snapshot.value as? [String]
            //print(daysOnCall)
            var helpRequests = [String : [HelpRequest]]()
            for day in daysOnCall!{
            
            self.RA.child(RA).child("onCallGroup").observeSingleEvent(of: .value, with: { (snapshot) in
                let onCallGroup = snapshot.value as? String
                helpRequests[day] = []
                //print("\(onCallGroup!):\(day)")
                    OnCallGroup.child(onCallGroup!).child("HelpRequests").child(day).observeSingleEvent(of: .value, with: { (snapshot) in
                        //print(snapshot)
                    let encodedHelpRequests = snapshot.value as? [String]
                    print(encodedHelpRequests)
                    for encodedHelpRequest in encodedHelpRequests!{
                        
                        HelpRequests.child(encodedHelpRequest).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let helpRequest = HelpRequest(dictionary: value!)
                            helpRequests[day]!.append(helpRequest)
                        })
                    }
                        
                    
                    })
                })

                }
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                reloadFunction(helpRequests)
            }

        })
    }
    
    
    static func addHelpRequests(onCallGroup: String, day: String,  helpRequests: [HelpRequest]){
        for helpRequest in helpRequests{
            HelpRequests.child(helpRequest.getHash()).setValue(helpRequest.getDictionary())
        }
        OnCallGroup.child(onCallGroup).child("HelpRequests").child(day).setValue(convertHelpRequests(helpRequests: helpRequests))
    }
    
    static func getDormsMap(reloadFunction: @escaping ([String: String]) -> Void){
        Dorms.observeSingleEvent(of: .value, with: { (snapshot) in
            let dormsMap = snapshot.value as? [String: String]
            reloadFunction(dormsMap!)
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    static func convertHelpRequests(helpRequests: [HelpRequest]) -> [String]{
        var encodedHelpRequests = [String]()
        for helpRequest in helpRequests{
            encodedHelpRequests.append(helpRequest.getHash())
        }
        return encodedHelpRequests
    }
    
    
    

}
