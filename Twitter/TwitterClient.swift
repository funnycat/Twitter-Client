//
//  TwitterClient.swift
//  Twitter
//
//  Created by Emily M Yang on 9/29/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

let twitterConsumerKey = "SNrvKsvgYm7wCA8iN5Pusizoq"
let twitterConsumerSecret = "cDqAiSDZd0YotzuwsOSKaxU0ujLNeVqE9AqXRhr2JExwvfTKp3"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

let newTweetCreated = "newTweetCreated"

class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion:((user:User?, error:NSError?)->())?
    
        static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey:twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(completion:(user:User?, error:NSError?)->()){
        loginCompletion = completion
        
        
        //fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            var authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                print("failed to get the request token")
                self.loginCompletion?(user:nil, error:error)
        }
        
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion:(tweets:[Tweet]?, error:NSError?) ->()){
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets:tweets, error:nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error getting home")
                completion(tweets:nil, error:error)
        })
    }
    
    func postNewTweet(tweetText: String, completion:(tweet:Tweet?, error:NSError?) ->()){
        let paramDictionary : NSDictionary = ["status":tweetText]
        
        POST("/1.1/statuses/update.json", parameters: paramDictionary, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!)-> Void in
                print("success posting new tweet tweet tweet")
                NSNotificationCenter.defaultCenter().postNotificationName(newTweetCreated, object: nil)
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error posting new tweet")
                completion(tweet:nil, error:error)
            })
    }
    
    func postFavorite(tweetID:NSNumber, completion:(tweet:Tweet?, error:NSError?) ->()){
        let paramDictionary : NSDictionary = ["id":tweetID]
        
        POST("/1.1/favorites/create.json", parameters: paramDictionary, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!)-> Void in
                print("success posting new favorite")
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error posting new favorite")
                completion(tweet:nil, error:error)
        })
    }
    
    func postRetweet(tweetID:NSNumber, completion:(tweet:Tweet?, error:NSError?) ->()){
        let paramDictionary : NSDictionary = ["id":tweetID]
        
        let newURL = "/1.1/statuses/retweet/\(tweetID).json"
        
        POST(newURL, parameters: paramDictionary, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!)-> Void in
            print("success posting new retweet")
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error posting new retweet")
                completion(tweet:nil, error:error)
        })
    }
    
    func postReply(tweetText:String, tweetID:NSNumber, completion:(tweet:Tweet?, error:NSError?) ->()){
        let paramDictionary : NSDictionary = ["status":tweetText, "in_reply_to_status_id":tweetID]
        
        POST("/1.1/statuses/update.json", parameters: paramDictionary, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!)-> Void in
            print("success posting new reply")
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error posting new reply")
                completion(tweet:nil, error:error)
        })
    }
    
    func openURL(url:NSURL){
            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString:url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("got access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                // print("user:\(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("just set current user:\(user)")
                self.loginCompletion!(user:user, error:nil)
                }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user:nil, error:error)
                    
            })
            

            
            }) { (error:NSError!) -> Void in
                print("failed to get access token")
                self.loginCompletion?(user:nil, error:error)
        }

    }

}
