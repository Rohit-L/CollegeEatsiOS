//
//  MenuTableVCTableViewController.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/28/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class MenuTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var time = [0: "Breakfast", 1: "Lunch", 2: "Dinner"]
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mealSelection: UISegmentedControl!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        mealSelection.tintColor = UIColor(rgba: appDelegate.mainColor)
    }

    // MARK: Table View Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.dailyMenu == nil ? 1 : appDelegate.dailyMenu["Length"][time[mealSelection.selectedSegmentIndex]!].asInt!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a valid result cell
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = appDelegate.dailyMenu == nil ? "Unable to load menu. Check connection." : appDelegate.dailyMenu[time[mealSelection.selectedSegmentIndex]!][indexPath.row][2].asString!
        return cell
    }
    

    @IBAction func mealSelectionChanged(sender: UISegmentedControl) {
        menuTableView.reloadData()
        self.menuTableView.contentOffset = CGPointMake(0, 0 - self.menuTableView.contentInset.top);
    }

}
