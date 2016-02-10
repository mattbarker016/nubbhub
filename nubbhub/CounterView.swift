//
//  CounterView.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/28/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

@IBDesignable class CounterView: UIView {
    
    @IBInspectable var totalUsed: Int = 140000
    @IBInspectable var dataCap: Int = 150000
    var arcColor: UIColor = UIColor.redColor()
    
    func setMDU(value: Int) {
        totalUsed = value
    }
    
    func setMDC(value: Int) {
        dataCap = value
    }
    
    func setArc(value: UIColor) {
        arcColor = value
    }
    
    override func drawRect(rect: CGRect) {
        
        //print("drawRect in ConuterView is running")
        //print("stats while drawing are "+String(dataCap)+" and "+String(totalUsed))
        
        let context = UIGraphicsGetCurrentContext()
        let startAngle: CGFloat = 2 * CGFloat(M_PI) / 3
        let endAngle: CGFloat = CGFloat(M_PI) / 3
        
        CGContextSetLineWidth(context, 5.0)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextAddArc(context, bounds.width/2, bounds.height/2,
            max(bounds.width/2, bounds.height/2) - 2.5, startAngle, endAngle, 0)
        CGContextStrokePath(context)
  
        //1 - first calculate the difference between the two angles, ensuring it is positive
        let angleDifference: CGFloat = 2 * CGFloat(M_PI) - startAngle + endAngle
        
        //then calculate the arc for each single MB
        let arcLengthPerMB = angleDifference / CGFloat(dataCap)
        
        //then multiply out by the amount MB used
        let outlineEndAngle = arcLengthPerMB * CGFloat(totalUsed) + startAngle
        
        CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
        CGContextAddArc(context, bounds.width/2, bounds.height/2,
            max(bounds.width/2, bounds.height/2) - 2.5, startAngle, outlineEndAngle, 0)
        CGContextStrokePath(context)

        //print("drawRect in ConuterView done")

    }
}
