//
//  ChoosePreferencesVC.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 7/1/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ChoosePreferencesVC: UITableViewController {
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var time = section == 0 ? "Breakfast" : "Lunch"
        return appDelegate.allFood["Length"][time].asInt!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath) as! UITableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        var time = indexPath.section == 0 ? "Breakfast" : "Lunch"
        cell.textLabel!.text = appDelegate.allFood[time][indexPath.row][0].asString!
        
        if contains(appDelegate.favorites, cell.textLabel!.text!) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Breakfast / Brunch" : "Lunch / Dinner"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
            appDelegate.favorites.removeAtIndex(find(appDelegate.favorites, cell.textLabel!.text!)!)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            appDelegate.favorites.append(cell.textLabel!.text!)
        }
        
        /* Asynchronous HTTP Request to send preferences */
        var request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/inputPreferences.php")!)
        request.HTTPMethod = "POST"
        var id = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        var preferences: String = ""
        for word in appDelegate.favorites {
            preferences = preferences + word + "|"
        }
        if preferences != "" {
            preferences = preferences.substringToIndex(preferences.endIndex.predecessor())
        }
        
        preferences = preferences.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString:"&\"#%/<>?@\\^`{|}").invertedSet)!
        var data = "id=" + id + "&preferences=" + preferences
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            print(reply)
        }
    }
}
