//
//  ViewController.swift
//  Twitter
//
//  Created by Emily M Yang on 9/29/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user:User?, error:NSError?) in
            if user != nil{
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else{
                //handle login error
            }
        }
        
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

