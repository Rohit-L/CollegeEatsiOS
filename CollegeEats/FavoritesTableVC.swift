//
//  FavoritesTableVC.swift
//  CollegeEats
//
//  Created by Rohit Lalchanadani on 7/2/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class FavoritesTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var time = [0: "Breakfast", 1: "Lunch", 2: "Dinner"]
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mealSelection: UISegmentedControl!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.favoritesTableVC = self
    }
    
    override func viewDidAppear(animated: Bool) {
        mealSelection.tintColor = UIColor(rgba: appDelegate.mainColor)
    }
    
    // MARK: Table View Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.favoritesMenu == nil ? 1 : appDelegate.favoritesMenu["Length"][time[mealSelection.selectedSegmentIndex]!].asInt!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get a valid result cell
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = appDelegate.favoritesMenu == nil ? "Nothing good is being served today!" : appDelegate.favoritesMenu[time[mealSelection.selectedSegmentIndex]!][indexPath.row][2].asString!
        return cell
    }
    
    
    @IBAction func mealSelectionChanged(sender: UISegmentedControl) {
        favoritesTableView.reloadData()
        self.favoritesTableView.contentOffset = CGPointMake(0, 0 - self.favoritesTableView.contentInset.top);
    }
    
}
