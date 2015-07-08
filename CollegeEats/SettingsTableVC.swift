//
//  SettingsTableVC.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 7/1/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class SettingsTableVC: UITableViewController {
    
    var settingsNavigationController: UINavigationController!
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.settingsTableVC = self
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = indexPath.row == 0 ? "theme" : "preferences"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel!.text = "Choose Theme"
        } else {
            cell.textLabel!.text = "Choose Favorites"
        }

        return cell
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        appDelegate.navigationVC!.backButton.hidden = false
        appDelegate.navigationVC!.titleLabel.text = segue.identifier == "themeChooser" ? "Choose Theme" : "Choose Favorites"
    }
}
