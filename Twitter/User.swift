//
//  User.swift
//  Twitter
//
//  Created by Emily M Yang on 10/3/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        screenname = "@\(screenname!)"
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    
    class var currentUser: User? {
        get{
            if (_currentUser==nil){
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey)
                if (data != nil){
                    do{
                        var dictionary = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options:[]) as! NSDictionary
                        _currentUser = User(dictionary:dictionary)
                    }
                    catch let error as NSError{
                        print(error)
                    }
                    
                
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            if(_currentUser != nil){
                do{
                    var data = try NSJSONSerialization.dataWithJSONObject((user?.dictionary)!, options:[])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                }
                catch let error as NSError{
                    print(error)
                }
            }else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
    }

}
