//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Emily M Yang on 10/6/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profileUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = profileUser.screenname
        nameLabel.text = profileUser.name
        numFollowersLabel.text = profileUser.numFollowers
        numFollowingLabel.text = profileUser.numFollowing
        numTweetsLabel.text = profileUser.numTweets
        
        bannerImageView.setImageWithURL(NSURL(string:profileUser.coverPhotoImageUrl!))
        profileImageView.setImageWithURL(NSURL(string:profileUser.profileImageUrl!))
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
