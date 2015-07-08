//
//  ChooseThemeVC.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 7/1/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ChooseThemeVC: UITableViewController {
    
    var checkColor = [0: "purple", 1: "green", 2: "blue"]
    var lastSelectedIndexPath: NSIndexPath?
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.colors.count - 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get the reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("colorCell", forIndexPath: indexPath) as! UITableViewCell
        var cellColor = appDelegate.colors[checkColor[indexPath.row]!]![0] as! String

        // Set the text and color of the cell
        cell.textLabel?.text = checkColor[indexPath.row]?.capitalizedString
        cell.tintColor = UIColor(rgba: cellColor)
        
        // Check if cell is the current theme
        if checkColor[indexPath.row]! == appDelegate.systemColor {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            lastSelectedIndexPath = indexPath
        }
        
        // Set the color image of the cell
        cell.imageView!.image = getImageWithColor(UIColor(rgba: cellColor), size: CGSizeMake(32, 32))
        cell.imageView!.layer.cornerRadius = 10.0
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Deselect the previously selected row and update selected row
        if indexPath.row != self.lastSelectedIndexPath?.row {
            let oldCell = tableView.cellForRowAtIndexPath(self.lastSelectedIndexPath!)
            oldCell?.accessoryType = .None
        }
        self.lastSelectedIndexPath = indexPath
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.accessoryType = .Checkmark
        
        // Get the new colors
        let selectedColor = checkColor[indexPath.row]!
        let mainColor = appDelegate.colors[selectedColor]![0] as! String
        let buttonColor = appDelegate.colors[selectedColor]![1] as! String
        appDelegate.colors["userSelection"] = selectedColor
        
        // Set the new appDelegate colors
        appDelegate.systemColor = selectedColor
        appDelegate.mainColor = mainColor
        appDelegate.buttonColor = buttonColor
        
        // Update the current colors of the UI
        appDelegate.navigationVC?.titleLabelView.backgroundColor = UIColor(rgba: mainColor)
        appDelegate.navigationVC?.tabBarView.backgroundColor = UIColor(rgba: mainColor)
        appDelegate.navigationVC?.buttonHighlight.backgroundColor = UIColor(rgba: buttonColor)
    }

    // Helper function to get plain background image
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
