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
    var favoritesString = "Your Favorite Foods"
    var menuString = "Today's Menu"
    var settingsString = "Settings"
    var buttonColor: String!
    var mainColor: String!

    var mainContentController: UITabBarController!
    var tabs = [0: favoritesTapped, 1: menuTapped, 2: settingsTapped]
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.navigationVC = self
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        titleLabelView.backgroundColor = UIColor(rgba: appDelegate.mainColor)
        tabBarView.backgroundColor = UIColor(rgba: appDelegate.mainColor)
        buttonHighlight.backgroundColor = UIColor(rgba: appDelegate.buttonColor)
        
        if !appDelegate.isConnected {
            let alert = UIAlertController(title: "Not Connected the Internet", message: "Please connect to a network to use CollegeEats", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            if sender == self.favoritesButton {
                self.appDelegate.getFavoritesAsynchronous()
            }
            self.buttonHighlight.frame.origin.x = sender.frame.origin.x
            self.appDelegate.settingsTableVC?.navigationController?.popToRootViewControllerAnimated(true)
            self.backButton.hidden = true
            
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
        appDelegate.settingsTableVC?.navigationController?.popViewControllerAnimated(true)
        backButton.hidden = true
        titleLabel.text = settingsString
        appDelegate.getFavoritesAsynchronous()
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            println("Swipe Left")
            if mainContentController.selectedIndex != 2 {
                if mainContentController.selectedIndex == 0 {
                    menuTapped(menuButton)
                    tabButtonTapped(menuButton)
                } else {
                    settingsTapped(settingsButton)
                    tabButtonTapped(settingsButton)
                }
            }
        }
        
        if (sender.direction == .Right) {
            println("Swipe Right")
            if mainContentController.selectedIndex != 0 {
                if mainContentController.selectedIndex == 2 {
                    menuTapped(menuButton)
                    tabButtonTapped(menuButton)
                } else {
                    favoritesTapped(favoritesButton)
                    tabButtonTapped(favoritesButton)
                }
            }
        }
    }
    
}
