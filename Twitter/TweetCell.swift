//
//  TweetCell.swift
//  Twitter
//
//  Created by Emily M Yang on 10/3/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCellController(tweetCellController: TweetCell, didClickImage user: User)
}

let imageWasTappedNotification = "imageWasTappedNotification"

class TweetCell: UITableViewCell {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?
    
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
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
            
            // add it to the image view;
            profilePictureImageView.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            profilePictureImageView.userInteractionEnabled = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = 3
        profilePictureImageView.clipsToBounds = true
        
        
        // Initialization code
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let profilePictureImageView = gesture.view as? UIImageView {
            print("Image Tapped")
            delegate?.tweetCellController?(self, didClickImage: self.tweet.user!)
           //  NSNotificationCenter.defaultCenter().postNotificationName(imageWasTappedNotification, object: nil)
             //performSegueWithIdentifier("showTweetProfileSegue", sender: self)
            //Here you can initiate your new ViewController
            
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
