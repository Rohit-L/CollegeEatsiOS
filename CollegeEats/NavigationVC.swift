//
//  ViewController.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/26/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class NavigationVC: UIViewController {
        
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainContent: UIView!
    var mainContentController: UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.backgroundColor = UIColor(rgba: "#BB97D2")
        
        
        /* TESTING preferences import */
        let requestpref = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/inputpref.php")!)
        requestpref.HTTPMethod = "POST"
        let postDatapref = "userid=a&prefs=dick, pizza, almonds"
        requestpref.HTTPBody = postDatapref.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var responsepref: NSURLResponse?
        var errorpref: NSErrorPointer = nil
        var datapref = NSURLConnection.sendSynchronousRequest(requestpref, returningResponse: &responsepref, error: errorpref)
        var inputreply = NSString(data: datapref!, encoding: NSUTF8StringEncoding)! as String
        

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        if sender == button1 {
            button1.backgroundColor = UIColor(rgba: "#BB97D2")
            button2.backgroundColor = UIColor.clearColor()
            button3.backgroundColor = UIColor.clearColor()
        } else if sender == button2 {
            button1.backgroundColor = UIColor.clearColor()
            button2.backgroundColor = UIColor(rgba: "#BB97D2")
            button3.backgroundColor = UIColor.clearColor()
        } else {
            button1.backgroundColor = UIColor.clearColor()
            button2.backgroundColor = UIColor.clearColor()
            button3.backgroundColor = UIColor(rgba: "#BB97D2")
        }
    }
    
    @IBAction func menuTapped(sender: UIButton) {
        titleLabel.text = "What's Good Today?"
        mainContentController.selectedIndex = 0
    }
    
    @IBAction func FavoritesTapped(sender: UIButton) {
        titleLabel.text = "Menu"
        
        // Get views. controllerIndex is passed in as the controller we want to go to.
        var fromView = mainContentController.selectedViewController!.view
        var toView = mainContentController.viewControllers?[1].view!
        
        UIView.transitionFromView(fromView, toView: toView!, duration: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, completion: { finished in
            self.mainContentController.selectedIndex = 1
        })
    }
    
    
    @IBAction func settingsTapped(sender: UIButton) {
        titleLabel.text = "Settings"
        mainContentController.selectedIndex = 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if segueName == "mainContent" {
            mainContentController = segue.destinationViewController as! UITabBarController
        }
    }


}

