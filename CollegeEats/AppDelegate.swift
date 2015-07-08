//
//  AppDelegate.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/26/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Colors
    var colors: NSMutableDictionary!
    var systemColor: String!
    var buttonColor: String!
    var mainColor: String!
    
    // Data
    var dailyMenu: JSON!
    var favoritesMenu: JSON!
    var allFood: JSON!
    var favorites: [String]! = []
    var isConnected: Bool = false
    
    // View controllers
    var navigationVC: NavigationVC?
    var settingsTableVC: SettingsTableVC?
    var favoritesTableVC: FavoritesTableVC?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Check for network connection
        isConnected = IJReachability.isConnectedToNetwork()
        
        loadLocalColors()

        
        if isConnected {
            
            getFavoritesSynchronous()
            loadLocalFavorites()
            getMenuSynchronous()
            getAllFoodAsynchronous()
            
        } else { // Not connected
            
            self.favoritesMenu = nil
            self.dailyMenu = nil
            self.allFood = nil
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Save color preferences
        saveFile(fileName: "colors.plist", fileObject: colors)
        
        // Save Favorites
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as! NSString
        let save = documentsDirectory.stringByAppendingPathComponent("favorites.plist")
        (favorites as NSArray).writeToFile(save, atomically: true)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        
        // Save color preferences
        saveFile(fileName: "colors.plist", fileObject: colors)
        
        // Save Favorites
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as! NSString
        let save = documentsDirectory.stringByAppendingPathComponent("favorites.plist")
        (favorites as NSArray).writeToFile(save, atomically: true)
    }
    
    func saveFile(#fileName: String, fileObject: NSDictionary) {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as! NSString
        let saveFile = documentsDirectory.stringByAppendingPathComponent(fileName as String)
        fileObject.writeToFile(saveFile, atomically: true)
    }
    
    func getData(#file: String, postData: String) -> String? {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/" + file)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        /* Synchronous (Halting) HTTP Request */
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        return reply == "" ? nil : reply
    }
    
    func loadLocalColors() -> Void {
        
        // Get local documents directory
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! NSString
        
        // Load local colors file
        let colorsFile = documentsDirectory.stringByAppendingPathComponent("colors.plist")
        
        if (NSFileManager.defaultManager().fileExistsAtPath(colorsFile)) {
            colors = NSMutableDictionary(contentsOfFile: colorsFile)
        } else {
            // First time app is opened
            let path = NSBundle.mainBundle().pathForResource("colors", ofType: "plist")
            colors = NSMutableDictionary(contentsOfFile: path!)!
        }
        
        // Set app colors
        self.systemColor = colors["userSelection"]! as! String
        self.mainColor = colors[systemColor]![0] as! String
        self.buttonColor = colors[systemColor]![1] as! String
    }
    
    // Load local favorites plist into array
    func loadLocalFavorites() -> Void {
        
        // Get local documents directory
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! NSString
        
        let favoritesFile = documentsDirectory.stringByAppendingPathComponent("favorites.plist")
        
        if (NSFileManager.defaultManager().fileExistsAtPath(favoritesFile)) { // if file exist
            self.favorites = NSArray(contentsOfFile: favoritesFile) as! [String]
        } else {
            self.favorites = []
        }
    }
    
    // Asynchronous HTTP Request to get favorites
    func getFavoritesAsynchronous() -> Void {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/getFavorites.php")!)
        request.HTTPMethod = "POST"
        let requestData = "id=" + UIDevice.currentDevice().identifierForVendor.UUIDString
        request.HTTPBody = requestData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if data == nil {
                self.favoritesMenu = nil
            } else {
                let reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                if reply == "" {
                    self.favoritesMenu = nil
                } else {
                    print(reply)
                    self.favoritesMenu = JSON(string: reply)
                }
            }
            self.favoritesTableVC?.favoritesTableView.reloadData()
        }
    }
    
    // Synchronous HTTP Request to Get Favorites
    func getFavoritesSynchronous() -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/getFavorites.php")!)
        request.HTTPMethod = "POST"
        let requestData = "id=" + UIDevice.currentDevice().identifierForVendor.UUIDString
        request.HTTPBody = requestData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        if data == nil {
            self.favoritesMenu = nil
        } else {
            let reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            if reply == "" {
                self.favoritesMenu = nil
            } else {
                print(reply)
                self.favoritesMenu = JSON(string: reply)
            }
        }
        self.favoritesTableVC?.favoritesTableView.reloadData()
    }
    
    // Synchronous HTTP Request to Get Menu
    func getMenuSynchronous() -> Void {
        self.dailyMenu = JSON(string: getData(file: "getMenu.php", postData: "")!)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/getMenu.php")!)
        request.HTTPMethod = "POST"
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        if data == nil {
            self.dailyMenu = nil
        } else {
            let reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            self.dailyMenu = JSON(string: reply)
        }
    }
    
    // Asynchronous HTTP Request to get all food items
    func getAllFoodAsynchronous() -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.laucity.com/collegeEats/scripts/getFood.php")!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if data == nil {
                self.allFood = nil
            } else {
                var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                self.allFood = JSON(string: reply)
            }
        }
    }

    
}
