//
//  AppDelegate.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/26/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Load plist Data
    var systemColor = "purple"
    var colors: NSDictionary!
    var buttonColor: String!
    var mainColor: String!
    
    // App data
    var menu: JSON!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Load plist Data
        let path = NSBundle.mainBundle().pathForResource("colors", ofType: "plist")
        colors = NSDictionary(contentsOfFile: path!)!
        buttonColor = colors[systemColor]![1] as! String
        mainColor = colors[systemColor]![0] as! String
        
        /* HTTP Request */
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/getMenu.php")!)
        request.HTTPMethod = "POST"
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        if data == nil {
            self.menu = nil
        } else {
            var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            print(reply)
            self.menu = JSON(string: reply)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

