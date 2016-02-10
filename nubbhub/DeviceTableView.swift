//
//  DeviceTableView.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/14/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit

class DeviceTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var nubb: Nubb?
    var reduced: Bool?
    //var myBounds = UIScreen.mainScreen().bounds
    
    let myDelegate = UITableViewDelegate.self
    let myDataSource = UITableViewDataSource.self
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DTV running num")
        if nubb?.devices.count != nil {
            return nubb!.devices.count
        }
        else {
            return 0
        }
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("DTV running cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DeviceTableCell
        cell.setDevice(nubb!.devices[indexPath.row], bounds: bounds, reduced: reduced!)
        return cell
    }
    
}
