//
//  TweetCell.swift
//  Twitter
//
//  Created by Emily M Yang on 10/3/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet!{
        didSet {
            timestampLabel.text = tweet.createdAtString
            usernameLabel.text = tweet.user?.screenname
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            if (tweet.user?.profileImageUrl != nil){
               profilePictureImageView.setImageWithURL(NSURL(string:(tweet.user?.profileImageUrl)!))
            }
            profilePictureImageView.layer.cornerRadius = 3
            profilePictureImageView.clipsToBounds = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = 3
        profilePictureImageView.clipsToBounds = true
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
