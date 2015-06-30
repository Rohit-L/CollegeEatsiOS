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
    
    @IBOutlet weak var titleLabel: UILabel! // The Main Header Label
    @IBOutlet weak var mainContent: SpringView! // The Container View
    var mainContentController: UITabBarController!
    var systemColor = "green"
    var colors: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load plist Data
        let path = NSBundle.mainBundle().pathForResource("colors", ofType: "plist")
        print("path")
        print(path)
        colors = NSDictionary(contentsOfFile: path!)!
        print(colors)
        
        // Set initial button background color
        favoritesButton.backgroundColor = UIColor(rgba: "#BB97D2")
        
        
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
    
    @IBAction func tabButtonTapped(sender: SpringButton) {
        sender.animation = "zoomIn"
        sender.curve = "linear"
        sender.duration = 1.0
        sender.damping = 1.0
        sender.animate()
        
        print(systemColor)
        print(colors)
        print(colors[systemColor])
        let mainColor = colors[systemColor]![1] as! String
        
        if sender == favoritesButton {
            favoritesButton.backgroundColor = UIColor(rgba: mainColor)
            menuButton.backgroundColor = UIColor.clearColor()
            settingsButton.backgroundColor = UIColor.clearColor()
        } else if sender == menuButton {
            favoritesButton.backgroundColor = UIColor.clearColor()
            menuButton.backgroundColor = UIColor(rgba: mainColor)
            settingsButton.backgroundColor = UIColor.clearColor()
        } else {
            favoritesButton.backgroundColor = UIColor.clearColor()
            menuButton.backgroundColor = UIColor.clearColor()
            settingsButton.backgroundColor = UIColor(rgba: mainColor)
        }
    }
    
    private func animateMainContent(#left: Bool) {
        if left {
            mainContent.animation = "slideLeft"
        } else {
            mainContent.animation = "slideRight"
        }
        mainContent.curve = "linear"
        mainContent.duration = 0.5
        mainContent.damping = 1.0
        mainContent.animate()
    }
    
    @IBAction func favoritesTapped(sender: SpringButton) {
        
        if self.mainContentController.selectedIndex == 0 {
            return
        }
        
        titleLabel.text = "What's Good Today?"
        if self.mainContentController.selectedIndex > 0 {
            animateMainContent(left: false)
        }
        mainContentController.selectedIndex = 0
        
    }
    
    @IBAction func menuTapped(sender: SpringButton) {
        
        if self.mainContentController.selectedIndex == 1 {
            return
        }
        
        titleLabel.text = "Menu"
        if self.mainContentController.selectedIndex < 1 {
            animateMainContent(left: true)
        } else {
            animateMainContent(left: false)
        }
        self.mainContentController.selectedIndex = 1
    }
    
    @IBAction func settingsTapped(sender: SpringButton) {
        
        if self.mainContentController.selectedIndex == 2 {
            return
        }
        
        titleLabel.text = "Settings"
        if self.mainContentController.selectedIndex < 2 {
            animateMainContent(left: true)
        }
        mainContentController.selectedIndex = 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if segueName == "mainContent" {
            mainContentController = segue.destinationViewController as! UITabBarController
        }
    }


}

