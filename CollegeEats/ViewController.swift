//
//  ViewController.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/26/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menu: JSON!
    var time = [0: "Breakfast", 1: "Lunch", 2: "Dinner"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* HTTP Request */
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.quinterest.org/laucity/collegeEats/scripts/getMenu.php")!)
        request.HTTPMethod = "POST"
        //let postData = "difficulty=test" + "&resultsType=test"
        //request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        if data == nil {
            return
        }
        var reply = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        print(reply)
        self.menu = JSON(string: reply)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu["Length"][time[section]!].asInt!
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a valid result cell
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = menu[time[indexPath.section]!][indexPath.row][2].asString!
        return cell
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return time.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return time[section]!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

