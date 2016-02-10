//
//  CalendarTVC.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/12/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit
import WebKit

class CalendarTVC: UITableViewController, WKNavigationDelegate {
    
    var dateArray: [String]!
    var selectIndex: Int?
    var chosenMonth: String?
    var guest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = self.dateArray[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chosenMonth = dateArray[indexPath.row]
        selectIndex = dateArray.count - indexPath.row
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print("entering segue")
        if segue.identifier == "unwind" && selectIndex != nil {
            let destination = segue.destinationViewController as! ViewController
            
            let format = NSDateFormatter()
            format.dateFormat = "MMMM yyyy"
            destination.chosenMonth = format.dateFromString(chosenMonth!)!
            
            destination.counterView?.removeFromSuperview()
            destination.deviceTable.hidden = true
            destination.overviewCollectionView.hidden = true
            destination.overviewLabel.hidden = true
            destination.detailsLabel.hidden = true
            destination.noDataUsageLabel.removeFromSuperview()
            destination.captionLabel.removeFromSuperview()
            
            if guest {
                switch (dateArray.count - selectIndex!) {
                    case 0: destination.nubb = GuestData().monthZero()
                    case 1: destination.nubb = GuestData().monthOne()
                    case 2: destination.nubb = GuestData().monthTwo()
                    case 3: destination.nubb = GuestData().monthThree()
                    case 4: destination.nubb = GuestData().monthFour()
                    case 5: destination.nubb = GuestData().monthFive()
                    default: break
                }
                destination.setUp()
            }
            
            else {
            
            let selectJS = "document.getElementById('month').selectedIndex = '\(selectIndex!)'"
            destination.webView.evaluateJavaScript(selectJS, completionHandler: { (result, error) in })
            let submitJS = "document.getElementsByName('submit_search')[0].click()"
            destination.webView.evaluateJavaScript(submitJS, completionHandler: { (result, error) in })
            destination.spinner.startAnimating()
                
            }
            
            selectIndex = nil
        }
        //print("segue done")
    }

}
