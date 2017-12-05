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
    //Database references
    static var rootRef = Database.database().reference()
    static var HelpRequests = rootRef.child("HelpRequests")
    static var OnCallGroup = rootRef.child("OnCallGroup")
    static var RA = rootRef.child("RA")
    static var Dorms = rootRef.child("Dorms")
    static var Users = rootRef.child("Users")
    
    //Strings to be used in constructing database paths
    static let testDirectory = "test"
    static let RADirectory = "RA"
    static let daysOnCallDirectory = "DaysOnCall"
    static let calendar = "Calendar"
    static let helpRequestsDirectory = "HelpRequests"
    static let onCallGroupDirectory = "onCallGroup"
    static let phoneNumberDirectory = "phoneNumber"
    
    //lets developer see if they are connected to firebase
    static func testConnection(){
        //tests the connection to firebase and prints 
        rootRef.child(testDirectory).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            print(value!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //takes a helpreauest reference (encoded helpRequest) and gets the helprequest data it maps to
    static func getHelpRequest(requestID: String, append: @escaping (HelpRequest) -> Void) {
        HelpRequests.child(requestID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let helpRequest = HelpRequest(dictionary: value!)
            append(helpRequest)
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    //gets an RA's days on Call and passes them to the reload function responsibel for repopulating the vc
    static func getDaysOnCall(RA: String, reloadFunction: @escaping ([String]) -> Void){
        rootRef.child(RADirectory).child(RA).child(daysOnCallDirectory).observe(DataEventType.value, with: { (snapshot) in
            var daysOnCall = [String]()
            daysOnCall = snapshot.value! as! [String]
            reloadFunction(daysOnCall)
        })
    }
    
    // gets an onCallGroup's calendar and passes the dates to the reload function responsible for repopulating the vc
    static func getCalendar(prevGroup: String?, group: String, reloadFunction: @escaping ([String:String]) -> Void){
        // remove listener from previous onCallGroup
        if let prev = prevGroup {
            OnCallGroup.child(prev).child(calendar).removeAllObservers()
        }
        // set new listener
        OnCallGroup.child(group).child(calendar).observe(DataEventType.value, with: { (snapshot) in
            var calendar = [String: String]()
            calendar = snapshot.value! as! [String: String]
            reloadFunction(calendar)
        })
    }

    //gets an RA's days on Call and passes them to the reload function responsibel for repopulating the vc
    static func getAllRAHelpRequests(RA: String, reloadFunction: @escaping ([String: [HelpRequest]]) -> Void){
        self.RA.child(RA).child(daysOnCallDirectory).observeSingleEvent(of: .value, with: { (snapshot) in
            let daysOnCall = snapshot.value as? [String]
            //print(daysOnCall)
            var helpRequests = [String : [HelpRequest]]()
            for day in daysOnCall!{
            
            self.RA.child(RA).child(onCallGroupDirectory).observeSingleEvent(of: .value, with: { (snapshot) in
                let onCallGroup = snapshot.value as? String
                helpRequests[day] = []
                print("\(onCallGroup!):\(day)")
                    OnCallGroup.child(onCallGroup!).child(helpRequestsDirectory).child(day).observeSingleEvent(of: .value, with: { (snapshot) in
                        //print(snapshot)
                        let encodedHelpRequests = snapshot.value as? [String]
                        if(encodedHelpRequests != nil){
                        let numberOfEncodedHelpRequests: Int = encodedHelpRequests!.count
                        var encodedHelpRequest: String
                        for i in 0...(numberOfEncodedHelpRequests - 1 ){
                            encodedHelpRequest = encodedHelpRequests![i]
                            HelpRequests.child(encodedHelpRequest).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let helpRequest = HelpRequest(dictionary: value!)
                            helpRequests[day]!.append(helpRequest)
                            if( i == (numberOfEncodedHelpRequests - 1 )){
                                print("idk")
                                reloadFunction(helpRequests)
                            }
                            
                        })
                    }
                        }else{
                            
                        }
                        
                    
                    })
                })

                }
            

        })
    }
    
    //sets up listener for helprequests and calls function to reloadcells with helprequests data
    static func getHelpRequests(RA: String, reloadFunction: @escaping ([String: [HelpRequest]]) -> Void){
        self.RA.child(RA).child(onCallGroupDirectory).observeSingleEvent(of: .value, with: { (snapshot) in
            let onCallGroup = snapshot.value as? String
            OnCallGroup.child(onCallGroup!).child(helpRequestsDirectory).observe(DataEventType.value, with: { (snapshot) in
                getAllRAHelpRequests(RA: RA, reloadFunction: reloadFunction)
        })
        })
        
    }
    
    //adds an array of helprequest to the database
    static func addHelpRequests(onCallGroup: String, day: String,  helpRequests: [HelpRequest]){
        for helpRequest in helpRequests{
            HelpRequests.child(helpRequest.getHash()).setValue(helpRequest.getDictionary())
        }
 OnCallGroup.child(onCallGroup).child(helpRequestsDirectory).child(day).setValue(convertHelpRequests(helpRequests: helpRequests))
    }
    
    //adds one helprequest to the database
    static func addHelpRequest(onCallGroup: String, day: String,  helpRequest: HelpRequest){
        HelpRequests.child(helpRequest.getHash()).setValue(helpRequest.getDictionary())
    OnCallGroup.child(onCallGroup).child(helpRequestsDirectory).child(day).observeSingleEvent(of: .value, with: { (snapshot) in
            var helpRequests = snapshot.value as? [String]
        if(helpRequests == nil){
            helpRequests = [String]()
        }
            helpRequests!.append(helpRequest.getHash())
            OnCallGroup.child(onCallGroup).child(helpRequestsDirectory).child(day).setValue(helpRequests)
        })
    }
    
    //gets a mapping of dorm to onCallGroup and calls the function to reload that in the vc
    static func getDormsMap(reloadFunction: @escaping ([String: String]) -> Void){
        Dorms.observeSingleEvent(of: .value, with: { (snapshot) in
            let dormsMap = snapshot.value as? [String: String]
            reloadFunction(dormsMap!)
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    //takes an array of helprequests and converts it to a string of helprequest encodings to be used as references
    static func convertHelpRequests(helpRequests: [HelpRequest]) -> [String]{
        var encodedHelpRequests = [String]()
        for helpRequest in helpRequests{
            encodedHelpRequests.append(helpRequest.getHash())
        }
        return encodedHelpRequests
    }
    
    //creates an account in the database
    static func createAccount(account: Account){
        var userAttributes = [String: String]()
        userAttributes["firstName"] = account.getFirstName()
        userAttributes["lastName"] = account.getLastName()
        userAttributes["phoneNumber"] = account.getPhoneNumber()
        if(account.getRole() == FireRole.RA){
            userAttributes["role"] = "RA"
        }else if(account.getRole() == FireRole.RC){
            userAttributes["role"] = "RC"
        }else{
            userAttributes["role"] = "Student"
        }
        Users.child(account.getEmail().replacingOccurrences(of: ".", with: "-")).setValue(userAttributes)
    }
    
    //sets the account in sessionInfo and segue's to main part of the app
    static func getAccount(email: String, mainAppSegue: @escaping () -> Void){
        //this is done because firebase cannot accept values with $ # [ ] / or .
        let userEmail = email.replacingOccurrences(of: ".", with: "-")
        Users.child(userEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            let userMap = snapshot.value as? [String: String]
            if(userMap != nil){
                SessionInfo.account = Account(email: email, userAttributeDict: userMap!)
            }
            if(SessionInfo.account?.getRole() == FireRole.RA){
                RA.child((SessionInfo.account?.getFirstName())!).observeSingleEvent(of: .value, with: { (snapshot) in
                    SessionInfo.account?.setDaysOnCall(daysOnCall: snapshot.childSnapshot(forPath: daysOnCallDirectory).value as! [String])
                    let onCallGroup = snapshot.childSnapshot(forPath: onCallGroupDirectory).value as! String!
                    var onCallGroups = [String]()
                    onCallGroups.append(onCallGroup!)
                    SessionInfo.account?.setOnCallGroups(onCallGroups: onCallGroups)
                    mainAppSegue()
                }) { (error) in
                    print(error.localizedDescription)
                    
                }
            }else if(SessionInfo.account?.getRole() == FireRole.RC){
                Dorms.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dormsMap = snapshot.value as? [String: String]
                    SessionInfo.account?.setOnCallGroups(onCallGroups: Array(Set(dormsMap!.values)))
                    mainAppSegue()
                }) { (error) in
                    print(error.localizedDescription)
                    
                }
                
            }else{
                mainAppSegue()
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    //get phoneNumbers from each on call group in database
    static func getPhoneNumbersMap(reloadFunction: @escaping ([String: String]) -> Void){
        Dorms.observeSingleEvent(of: .value, with: { (snapshot) in
            let dormsMap = snapshot.value as! [String: String]
            var numbersMap = [String: String]()
            let onCallGroups = Array(Set(dormsMap.values))
            for onCallGroupName in onCallGroups{
                OnCallGroup.child(onCallGroupName).child(phoneNumberDirectory).observeSingleEvent(of: .value, with: { (snapshot) in
                   
                    let onCallGroupNumber = (snapshot.value as! Int).description
                    numbersMap[onCallGroupName] = onCallGroupNumber
                    if(onCallGroupName == onCallGroups[onCallGroups.count - 1]){
                        reloadFunction(numbersMap)
                    }
                })
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    

}
