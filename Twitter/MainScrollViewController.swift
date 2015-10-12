//
//  MainScrollViewController.swift
//  Twitter
//
//  Created by Emily M Yang on 10/10/15.
//  Copyright © 2015 Experiences Evolved. All rights reserved.
//

import UIKit

class MainScrollViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var containerView: UIView!
  
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet weak var showMentionsButton: UIButton!
    @IBOutlet weak var showProfileButton: UIButton!
    @IBOutlet weak var showHomeButton: UIButton!
    var menuOriginalCenter: CGPoint!
    var menuXOrigin: CGFloat!
    var viewWidth : CGFloat!
    
    var selectedViewController:UIViewController?
    
    var viewControllers: [UIViewController] = []
    
    private var profileViewController: UIViewController!
    private var tweetsListViewController: TweetsViewController!
    private var tweetsNavController: UINavigationController!
    private var mentionsListViewController: TweetsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
            action: "moveMenu:")
        screenEdgeRecognizer.edges = .Left
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        menuView.frame = CGRect(origin: CGPoint(x: -(menuView.frame.width/2),y: menuView.frame.height/2), size: menuView.frame.size)
        
        viewWidth = view.frame.width
        menuXOrigin = menuView.frame.origin.x
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavController = storyboard.instantiateViewControllerWithIdentifier("NavigationFromLogin") as! UINavigationController
        viewControllers.append(tweetsNavController)
        
        tweetsListViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsListView") as! TweetsViewController
        tweetsListViewController.type = "tweets"
        viewControllers.append(tweetsListViewController)
        
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileStoryboard")
        viewControllers.append(profileViewController)
        
        mentionsListViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsListView") as!TweetsViewController
        mentionsListViewController.type = "mentions"
        viewControllers.append(mentionsListViewController)
        
        tweetsNavController.pushViewController(mentionsListViewController, animated: false)
        tweetsNavController.pushViewController(tweetsListViewController, animated: false)
        
        
        selectedViewController = viewControllers[0]
        selectViewController(viewControllers[0])
  
        //self.setUpViewControllers()
        // Do any additional setup after loading the view.
    }

    func moveMenu(panGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(view)
        switch panGestureRecognizer.state {
        case .Began:
            print("Gesture began at: \(point)")
            menuOriginalCenter = menuView.center
        case .Changed:
            print("Gesture changed at: \(point)")
            
        case .Ended:
            
            print("Gesure ended at: \(point)")
    
            UIView.animateWithDuration(0.5, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options:[], animations:{
                    self.menuView.center = CGPoint(x: self.menuView.frame.width/2,
                    y: self.menuOriginalCenter.y)
                },
                completion:nil)
            
        default:
            print("Unhandled gesture")
        }
    }
    
    @IBAction func onContainerViewPan(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(view)
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        switch panGestureRecognizer.state {
        case .Began:
            print("Gesture began at: \(point)")
            menuOriginalCenter = menuView.center
        case .Changed:
            print("Gesture changed at: \(point)")
            if(menuView.frame.origin.x + translation.x < (menuView.frame.width/4)){
                menuView.center = CGPoint(x: menuOriginalCenter.x + translation.x,
                    y: menuOriginalCenter.y)
            }
            
        case .Ended:
            
            print("Gesure ended at: \(point)")
            
            UIView.animateWithDuration(0.5, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options:[], animations:{
                if velocity.x > 0{
                    //moving out
                    self.menuView.center = CGPoint(x: self.menuView.frame.width/2,
                        y: self.menuOriginalCenter.y)
                }
                else{
                    //moving back
                    self.menuView.center = CGPoint(x: self.menuXOrigin,
                        y: self.menuOriginalCenter.y)
                    
                }
                },
                completion:nil)
            
            
        default:
            print("Unhandled gesture")
        }
    }
    
    @IBAction func onMenuPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(view)
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        switch panGestureRecognizer.state {
        case .Began:
            print("Gesture began at: \(point)")
            menuOriginalCenter = menuView.center
        case .Changed:
            print("Gesture changed at: \(point)")
            if(menuView.frame.origin.x + translation.x < (menuView.frame.width/4)){
                menuView.center = CGPoint(x: menuOriginalCenter.x + translation.x,
                    y: menuOriginalCenter.y)
            }
            
        case .Ended:
            
            print("Gesure ended at: \(point)")
            
            UIView.animateWithDuration(0.5, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options:[], animations:{
                if velocity.x > 0{
                    //moving out
                    self.menuView.center = CGPoint(x: self.menuView.frame.width/2,
                        y: self.menuOriginalCenter.y)
                }
                else{
                    //moving back
                    self.menuView.center = CGPoint(x: self.menuXOrigin,
                        y: self.menuOriginalCenter.y)
                    
                }
                },
                completion:nil)
            
            
        default:
            print("Unhandled gesture")
        }
        
    }
    func moveMenuToX(x:CGFloat){
        self.menuView.frame = CGRectMake(x, self.menuView.frame.origin.y, self.menuView.frame.width, self.menuView.frame.height)
    }
    
    @IBAction func onShowHomePressed(sender: AnyObject) {
        //self.selectViewController(viewControllers[0])
        
        let nc = viewControllers[0] as! UINavigationController
//        let vc = tweetsListViewController as! TweetsViewController
//        vc.type = "tweets"
        
        nc.navigationItem.title = "Home"
        nc.showViewController(tweetsListViewController, sender: sender)
       // nc.popToViewController(tweetsListViewController, animated: false)
        self.selectViewController(viewControllers[0])
    }
    
    @IBAction func onShowProfilePressed(sender: AnyObject) {
        let nc = viewControllers[0] as! UINavigationController
        let vc = profileViewController as! ProfileViewController
        nc.navigationItem.title = "Profile"
        
        vc.profileUser = User.currentUser
        selectViewController(viewControllers[2])
  //      performSegueWithIdentifier("backToTweetsSegue", sender: sender)
  //
     //   nc.performSegueWithIdentifier("showCurrentUserProfileSegue", sender: sender)
    }
    
    @IBAction func onShowMentionsPressed(sender: AnyObject) {
        let nc = viewControllers[0] as! UINavigationController
        
        nc.navigationItem.title = "Mentions"
  //      nc.showViewController(mentionsListViewController, sender: sender)
        nc.popToViewController(mentionsListViewController, animated: false)
        self.selectViewController(viewControllers[0])
    }

    
    func selectViewController(viewController: UIViewController){
        
        if let oldViewController = selectedViewController{
            
            oldViewController.willMoveToParentViewController(nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
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
