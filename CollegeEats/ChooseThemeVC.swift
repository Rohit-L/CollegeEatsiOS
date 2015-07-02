//
//  ChooseThemeVC.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 7/1/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ChooseThemeVC: UITableViewController {
    
    var colors: NSDictionary!
    var checkColor = [0: "purple", 1: "green", 2: "blue"]
    var lastSelectedIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        colors = appDelegate.colors
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return colors.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = checkColor[indexPath.row]?.capitalizedString
        //cell.accessoryType = UITableViewCellAccessoryType.Checkmark

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row != self.lastSelectedIndexPath?.row {
            if self.lastSelectedIndexPath != nil {
                let oldCell = tableView.cellForRowAtIndexPath(self.lastSelectedIndexPath!)
                oldCell?.accessoryType = .None
            }
        }
            
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.accessoryType = .Checkmark
            
        self.lastSelectedIndexPath = indexPath
        
        var selectedColor = checkColor[indexPath.row]
        var mainColor = colors[selectedColor!]![0] as! String
        var buttonColor = colors[selectedColor!]![1] as! String
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.systemColor = checkColor[indexPath.row]!
        appDelegate.mainColor = colors[appDelegate.systemColor]![0] as! String
        appDelegate.buttonColor = colors[appDelegate.systemColor]![1] as! String
        appDelegate.navigationVC?.titleLabelView.backgroundColor = UIColor(rgba: mainColor)
        appDelegate.navigationVC?.tabBarView.backgroundColor = UIColor(rgba: mainColor)
        appDelegate.navigationVC?.buttonHighlight.backgroundColor = UIColor(rgba: buttonColor)
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
