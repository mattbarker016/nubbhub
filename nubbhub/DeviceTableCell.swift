//
//  DeviceCell.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/1/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import Foundation
import UIKit

class DeviceTableCell: UITableViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var totalUsage: UILabel!
    @IBOutlet weak var icon: UIView!
    
    @IBOutlet weak var downloadTriangle: TriangleView!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var uploadTriangle: TriangleView!
    @IBOutlet weak var upLabel: UILabel!
    
    @IBOutlet weak var downConstraint: NSLayoutConstraint!
    @IBOutlet weak var upConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalConstraint: NSLayoutConstraint!
    
    func setDevice(device: Device, theme: Theme, bounds: CGRect, reduced: Bool) {
        
        icon.backgroundColor = device.color
        
        icon.layer.cornerRadius = icon.bounds.width / 4
        
        deviceName.text = device.name
        
        downloadTriangle.theme = theme
        downloadTriangle.backgroundColor = UIColor.clearColor()
        downloadTriangle.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        uploadTriangle.theme = theme
        uploadTriangle.backgroundColor = UIColor.clearColor()
        
        downloadTriangle.setNeedsDisplay()
        uploadTriangle.setNeedsDisplay()
        
        if reduced {
            totalUsage.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            downLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            upLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            deviceName.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            downConstraint.constant = 12
            upConstraint.constant = 12
            totalConstraint.constant = 12
        }
        
        totalUsage.text = "Total: \(device.byteRound(device.totalUsage)) GB"
        
        downLabel.text = "\(device.byteRound(device.totalIn)) GB"
        upLabel.text = "\(device.byteRound(device.totalOut)) GB"
        
        totalUsage.textColor = theme.secondary
        downLabel.textColor = theme.secondary
        upLabel.textColor = theme.secondary
        deviceName.textColor = theme.secondary
        
    }

}