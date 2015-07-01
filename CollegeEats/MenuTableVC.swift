//
//  MenuTableVCTableViewController.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 6/28/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class MenuTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var menu: JSON!
    var time = [0: "Breakfast", 1: "Lunch", 2: "Dinner"]
    
    @IBOutlet weak var mealSelection: UISegmentedControl!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        menu = appDelegate.menu
        
        // Set segmented control color
        mealSelection.tintColor = UIColor(rgba: appDelegate.mainColor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table View Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu["Length"][time[mealSelection.selectedSegmentIndex]!].asInt!
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a valid result cell
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = menu[time[mealSelection.selectedSegmentIndex]!][indexPath.row][2].asString!
        return cell
        
    }
    

    @IBAction func mealSelectionChanged(sender: UISegmentedControl) {
        menuTableView.reloadData()
        self.menuTableView.contentOffset = CGPointMake(0, 0 - self.menuTableView.contentInset.top);
    }

}
