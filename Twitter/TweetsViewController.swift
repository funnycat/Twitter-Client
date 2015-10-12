//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Emily M Yang on 10/3/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    
    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var segueToUser: User?
    
    var type : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchTweets", name: newTweetCreated, object: nil)
        
        segueToUser = User.currentUser!
        
        fetchTweets()
        
    }
    
    func fetchTweets(){
        
        if(type==nil){
            type = "tweets"
        }
        
        if(type == "tweets"){
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion:{(tweets, error)->() in
                dispatch_async(dispatch_get_main_queue(), {
                    self.tweets = tweets
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
                
            })
        }
        else if(type == "mentions"){
            TwitterClient.sharedInstance.mentionsTimelineWithParams(nil, completion:{(tweets, error)->() in
                dispatch_async(dispatch_get_main_queue(), {
                    self.tweets = tweets
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
                
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.delegate = self
        
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets!.count
        }else{
            return 0
        }
    }
    
    func tweetCellController(tweetCellController: TweetCell, didClickImage user: User){
        
        self.segueToUser = user
        performSegueWithIdentifier("showProfileSegue", sender: self)
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailsSegue" {

            let tweetsDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            let tweet = tweets![indexPath!.row]
            tweetsDetailsViewController.tweet = tweet
        }
        
        if segue.identifier == "showProfileSegue" {
            if (sender?.title == "profile"){
                segueToUser = User.currentUser!
            }
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
         //   let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
        //    let assignedUser = tweets![indexPath!.row].user!

            profileViewController.profileUser = segueToUser
        
        }
        
//        if segue.identifier == "showProfileFromFeedSegue" {
//            let profileViewController = segue.destinationViewController as! ProfileViewController
//            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
//            
//            let assignedUser = tweets![indexPath!.row].user!
//            
//            profileViewController.profileUser = assignedUser
//            
//        }
        
        
        
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
