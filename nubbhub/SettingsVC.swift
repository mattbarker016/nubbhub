//
//  SettingsVC.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/10/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit
import WebKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let settingsArray: [String] = ["about", "nubbhub pro", "notifications", "themes", "widget", "sign out"]
    let prefs = NSUserDefaults.standardUserDefaults()

    var theme: Theme?
    var guest: Bool = false
    
    var notificationFirstAlert = 50
    var notificationSecondAlert = 75
    var notificationThirdAlert = 90
    
    //store in NSUserDefaults
    
    func getFirst() -> Int { return notificationFirstAlert }
    func getSecond() -> Int { return notificationSecondAlert }
    func getThird() -> Int { return notificationThirdAlert }
    
    func setFirst(value: Int) { notificationFirstAlert = value }
    func setSecond(value: Int) { notificationSecondAlert = value }
    func setThird(value: Int) { notificationThirdAlert = value }
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        print("settings vc view did load firing")
        UIApplication.sharedApplication().statusBarStyle = theme!.style(theme!.statusBar)!
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        //prefs.setInteger(notifcation, forKey: <#T##String#>)
        //NSUserDefaults.standardUserDefaults().valueForKey("notificationSecondAlert")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = settingsArray[indexPath.row]
        cell!.textLabel?.textColor = theme?.secondary
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if settingsArray[indexPath.row] == "about" {
            self.performSegueWithIdentifier("about", sender: self)
        }
        if settingsArray[indexPath.row] == "notfications" {
            self.performSegueWithIdentifier("notifications", sender: self)
        }
        if settingsArray[indexPath.row] == "themes" {
            UIApplication.sharedApplication().statusBarStyle = .Default
            self.performSegueWithIdentifier("themes", sender: self)
        }
        if settingsArray[indexPath.row] == "sign out" {
            guest = false
            prefs.removeObjectForKey("netid")
            prefs.removeObjectForKey("password")
            prefs.removeObjectForKey("theme")
            self.performSegueWithIdentifier("unwind", sender: self)
            //self.dismissViewControllerAnimated(true) { () -> Void in }
        }
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "themes" {
            let destination = segue.destinationViewController as! SettingsThemes
            destination.theme = theme
        }
        if segue.identifier == "unwind" {
            print("settings to VC unwind firing")
            let destination = segue.destinationViewController as! ViewController
            destination.guest = guest
            destination.theme = theme!
            destination.themeHelper(theme!)
            if prefs.stringForKey("netid") == nil && !guest {
                destination.counterView?.removeFromSuperview()
                destination.deviceTable.hidden = true
                destination.overviewCollectionView.hidden = true
                destination.overviewLabel.hidden = true
                destination.detailsLabel.hidden = true
                destination.noDataUsageLabel.removeFromSuperview()
                destination.captionLabel.removeFromSuperview()
            }
            
        }
    }
    
    @IBAction func unwindToSettings(sender: UIStoryboardSegue) { }
    
}
