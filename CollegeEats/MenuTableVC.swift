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
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mealSelection: UISegmentedControl!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get menu from app delegate
        menu = appDelegate.menu
    }
    
    override func viewDidAppear(animated: Bool) {
        mealSelection.tintColor = UIColor(rgba: appDelegate.mainColor)
    }

    // MARK: Table View Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu == nil ? 1 : menu["Length"][time[mealSelection.selectedSegmentIndex]!].asInt!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a valid result cell
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = menu == nil ? "Unable to load menu. Check connection." : menu[time[mealSelection.selectedSegmentIndex]!][indexPath.row][2].asString!
        return cell
    }
    

    @IBAction func mealSelectionChanged(sender: UISegmentedControl) {
        menuTableView.reloadData()
        self.menuTableView.contentOffset = CGPointMake(0, 0 - self.menuTableView.contentInset.top);
    }

}
