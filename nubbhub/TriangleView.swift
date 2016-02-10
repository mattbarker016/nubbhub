//
//  TriangleView.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/2/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import Foundation
import UIKit

class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //var theme: Theme = Theme(name: "modern", primary: UIColor.blackColor(), secondary: UIColor.whiteColor(), arc: UIColor.redColor(), statusBar: .LightContent)
    
    var theme: Theme!
    var custom: UIColor?
    
    func setColor(value: Theme) { theme = value }
    
    override func drawRect(rect: CGRect) {
        
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMinY(rect))
        CGContextClosePath(ctx)
        
        //CGContextSetRGBFillColor(ctx, 256, 256, 256, 1.0)
        CGContextSetFillColorWithColor(ctx, (custom?.CGColor ?? theme.secondary.CGColor))
        CGContextFillPath(ctx);
        
    }

}
