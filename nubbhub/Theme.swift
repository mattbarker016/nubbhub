//
//  Theme.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/16/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit

class Theme: NSCoder {
    
    var name: String
    var primary: UIColor
    var secondary: UIColor
    var arc: UIColor
    var colorArray: [UIColor]
    var statusBar: String
    var gradient: [UIColor]?
    
    init(name: String, primary: UIColor, secondary: UIColor, arc: UIColor, colorArray: [UIColor], statusBar: String, gradient: [UIColor]?) {
        self.name = name
        self.primary = primary
        self.secondary = secondary
        self.arc = arc
        self.colorArray = colorArray
        self.statusBar = statusBar
        self.gradient = gradient
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObjectForKey("name") as! String
        self.primary = decoder.decodeObjectForKey("primary") as! UIColor
        self.secondary = decoder.decodeObjectForKey("secondary") as! UIColor
        self.arc = decoder.decodeObjectForKey("arc") as! UIColor
        self.colorArray = decoder.decodeObjectForKey("colorArray") as! [UIColor]
        self.statusBar = decoder.decodeObjectForKey("statusBar") as! String
        self.gradient = decoder.decodeObjectForKey("gradient") as! [UIColor]?
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.primary, forKey: "primary")
        coder.encodeObject(self.secondary, forKey: "secondary")
        coder.encodeObject(self.arc, forKey: "arc")
        coder.encodeObject(self.colorArray, forKey: "colorArray")
        coder.encodeObject(self.statusBar, forKey: "statusBar")
        coder.encodeObject(self.gradient, forKey: "gradient")
    }
    
    func modern() -> Theme {
        return Theme(name: "modern", primary: UIColor.blackColor(), secondary: UIColor.whiteColor(), arc: UIColor.redColor(), colorArray: [UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor()], statusBar: ".LightContent", gradient: nil)
    }
    
    func modernGradient() -> Theme {
        return Theme(name: "modern gradient", primary: UIColor.blackColor(), secondary: UIColor.whiteColor(), arc: UIColor.redColor(), colorArray: [UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor()], statusBar: ".LightContent", gradient: [UIColor.blackColor(), UIColor.redColor()])
    }
    
    func sky() -> Theme {
        return Theme(name: "sky", primary: UIColor(red: 51/255, green: 153/255, blue: 1, alpha: 1.0), secondary: UIColor.whiteColor(), arc: UIColor.whiteColor(), colorArray: [UIColor.whiteColor()], statusBar: ".LightContent", gradient: nil)
    }
    
    func bigred() -> Theme {
        return Theme(name: "big red", primary: UIColor(red: 204/255, green: 0, blue: 0, alpha: 1.0), secondary: UIColor.whiteColor(), arc: UIColor.whiteColor(), colorArray: [UIColor.whiteColor()], statusBar: ".LightContent", gradient: nil)
    }
    
    func sunshine() -> Theme {
        return Theme(name: "sunshine", primary: UIColor(red: 255/255, green: 255/255, blue: 51/255, alpha: 1.0), secondary: UIColor.blackColor(), arc: UIColor.blackColor(), colorArray: [UIColor.blackColor()], statusBar: ".Default", gradient: nil)
    }
    
    func forest() -> Theme {
        return Theme(name: "forest", primary: UIColor(red: 100/255, green: 255/255, blue: 100/255, alpha: 1.0), secondary: UIColor.blackColor(), arc: UIColor.blackColor(), colorArray: [UIColor.darkGrayColor()],  statusBar: ".Default", gradient: nil)
    }
    
    func royal() -> Theme {
        return Theme(name: "royal", primary: UIColor.purpleColor(), secondary: UIColor.whiteColor(), arc: UIColor.whiteColor(), colorArray: [UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.magentaColor()], statusBar: ".LightContent", gradient: nil)
    }
    
    func swiss() -> Theme {
        return Theme(name: "swiss", primary: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0), secondary: UIColor.blackColor(), arc: UIColor.redColor(), colorArray: [UIColor.redColor(), UIColor.blackColor(), UIColor.whiteColor()],  statusBar: ".Default", gradient: nil)
    }
    
    func chrome() -> Theme {
        return Theme(name: "chrome", primary: UIColor.darkGrayColor(), secondary: UIColor.whiteColor(), arc: UIColor.whiteColor(), colorArray: [UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.orangeColor(), UIColor.magentaColor()], statusBar: ".LightContent", gradient: nil)
    }
    
    func allThemes() -> [Theme] {
        return [modern(), sky(), bigred(), sunshine(), forest(), royal(), swiss(), chrome()]
    }
    
    func button(buttonName: String) -> String {
        var picString: String!
        if self.statusBar == ".LightContent" {
            picString = String(buttonName)+"-light"
        }
        if self.statusBar == ".Default" {
            picString = String(buttonName)+"-dark"
        }
        return picString
    }
    
    func buttonReverse(buttonName: String) -> String {
        var picString: String!
        if self.statusBar == ".Default" {
            picString = String(buttonName)+"-light"
        }
        if self.statusBar == ".LightContent" {
            picString = String(buttonName)+"-dark"
        }
        return picString
    }
    
    func style(statusBar: String) -> UIStatusBarStyle? {
        if statusBar == ".Default" {
            return UIStatusBarStyle.Default
        }
        if statusBar == ".LightContent" {
            return UIStatusBarStyle.LightContent
        }
        return nil
    }
    
    func gradientHelper(array: [UIColor]) -> [CGColor] {
        var newArray: [CGColor] = []
        for color in array {
            newArray.append(color.CGColor)
        }
        return newArray
    }
    
}
