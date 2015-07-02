//
//  ViewController.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/26/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class NavigationVC: UIViewController {
    
    // Buttons
    @IBOutlet weak var favoritesButton: SpringButton!
    @IBOutlet weak var menuButton: SpringButton!
    @IBOutlet weak var settingsButton: SpringButton!
    @IBOutlet weak var buttonHighlight: SpringView!
    
    // Views and Labels
    @IBOutlet weak var titleLabel: UILabel! // The Main Header Label
    @IBOutlet weak var titleLabelView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var mainContent: SpringView! // The Container View
    @IBOutlet weak var backButton: UIButton!
    
    // Strings
    var favoritesString = "What's Good Today?"
    var menuString = "Today's Menu"
    var settingsString = "Settings"
    var buttonColor: String!
    var mainColor: String!

    var mainContentController: UITabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get application colors from app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        buttonColor = appDelegate.buttonColor
        mainColor = appDelegate.mainColor
        
        appDelegate.navigationVC = self

        // Set initial view colors
        titleLabelView.backgroundColor = UIColor(rgba: mainColor)
        tabBarView.backgroundColor = UIColor(rgba: mainColor)
        buttonHighlight.backgroundColor = UIColor(rgba: buttonColor)
        
        
//        /* TESTING preferences import */
//        let requestpref = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/inputpref.php")!)
//        requestpref.HTTPMethod = "POST"
//        let postDatapref = "userid=a&prefs=dick, pizza, almonds"
//        requestpref.HTTPBody = postDatapref.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        var responsepref: NSURLResponse?
//        var errorpref: NSErrorPointer = nil
//        var datapref = NSURLConnection.sendSynchronousRequest(requestpref, returningResponse: &responsepref, error: errorpref)
//        var inputreply = NSString(data: datapref!, encoding: NSUTF8StringEncoding)! as String
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set the status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // Allows access to the TabBarController in the container view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainContent" {
            mainContentController = segue.destinationViewController as! UITabBarController
        }
    }
    
    // MARK: Button Taps
    // Animates the button highlight
    @IBAction func tabButtonTapped(sender: SpringButton) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.buttonHighlight.frame.origin.x = sender.frame.origin.x
        }, completion: nil)
    }
    
    // Animates the view when switching pages
    private func animateMainContent(#left: Bool) {
        mainContent.animation = left ? "slideLeft" : "slideRight"
        mainContent.curve = "spring"
        mainContent.duration = 0.5
        mainContent.damping = 1.0
        mainContent.animate()
    }
    
    // Called when the favorites button is tapped
    @IBAction func favoritesTapped(sender: SpringButton) {
        
        // Does nothing if already correct
        if self.mainContentController.selectedIndex == 0 { return }
        
        titleLabel.text = favoritesString
        animateMainContent(left: false)
        mainContentController.selectedIndex = 0
        
    }
    
    // Called the the daily menu button is tapped
    @IBAction func menuTapped(sender: SpringButton) {
        
        // Does nothing if already correct
        if self.mainContentController.selectedIndex == 1 { return }
        
        titleLabel.text = menuString
        self.mainContentController.selectedIndex < 1 ? animateMainContent(left: true) : animateMainContent(left: false)
        self.mainContentController.selectedIndex = 1
        
    }
    
    // Called when the settings button is tapped
    @IBAction func settingsTapped(sender: SpringButton) {
        
        // Does nothing if already correct
        if self.mainContentController.selectedIndex == 2 { return }
        
        titleLabel.text = settingsString
        animateMainContent(left: true)
        mainContentController.selectedIndex = 2
    }

    @IBAction func backButtonTapped(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.settingsTableVC?.navigationController?.popViewControllerAnimated(true)
        backButton.hidden = true
        titleLabel.text = settingsString
    }
    
}
