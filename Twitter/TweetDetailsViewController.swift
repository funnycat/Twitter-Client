//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Emily M Yang on 10/4/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var numFavoritesLabel: UILabel!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var replyTextField: UITextView!
    var tweet:Tweet!
    @IBOutlet weak var tweetReplyButton: UIButton!
    @IBOutlet weak var cancelReplyButton: NSLayoutConstraint!
    @IBOutlet weak var replyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numFavoritesLabel.text = tweet.favoriteCount
        numRetweetsLabel.text = tweet.retweetCount
        timestampLabel.text = tweet.createdAtString
        tweetTextLabel.text = tweet.text
        usernameLabel.text = tweet.user?.screenname
        nameLabel.text = tweet.user?.name
        profilePictureImageView.setImageWithURL(NSURL(string:(tweet.user?.profileImageUrl)!))
        
   
        if(tweet.favorited == true){
            //disable button
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState:  UIControlState.Normal)
        }
        
        if(tweet.retweeted == true){
            //disable button
            favoriteButton.setImage(UIImage(named: "retweet_on"), forState:  UIControlState.Normal)
        }
        
        replyView.hidden = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyPressed(sender: AnyObject) {
        replyView.hidden = false
        replyButton.enabled = false
        replyTextField.text = tweet.user!.screenname!
    }
    
    
    @IBAction func onRetweetPressed(sender: AnyObject) {
        //if I haven't retweeted
        if(tweet.retweeted == false){
            TwitterClient.sharedInstance.postRetweet(tweet.id!) { (tweet, error) -> () in
                if(error == nil){
                    print("retweeted successfully")

                }
            }
            retweetButton.setImage(UIImage(named: "retweet_on"), forState:  UIControlState.Normal)
            tweet?.augmentRetweets()
            numRetweetsLabel.text = tweet.retweetCount
       
        }
        //to unretweet
    }

    @IBAction func onFavoritePressed(sender: AnyObject) {
        //to favorite
        if(tweet.favorited == false){
            TwitterClient.sharedInstance.postFavorite(tweet.id!) { (tweet, error) -> () in
                if(error == nil){
                    print("favorited successfully")
                }
                
            }
            favoriteButton.setImage(UIImage(named: "favorite_on"), forState:  UIControlState.Normal)
            tweet?.augmentFavorites()
            numFavoritesLabel.text = tweet.favoriteCount
   
        }
        //to unfavorite
    }
    @IBAction func onReplyCancelled(sender: AnyObject) {
        replyView.hidden = true
        replyButton.enabled = true
    }
    @IBAction func onTweetReplyPosted(sender: AnyObject) {
        var newText = replyTextField.text 
        TwitterClient.sharedInstance.postReply(newText, tweetID: tweet.id!) { (tweet, error) -> () in
            print("successfully replied")
        }
        replyView.hidden = true
        replyButton.enabled = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
