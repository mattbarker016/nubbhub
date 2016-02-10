//
//  GuestData.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/17/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import Foundation
import UIKit

class Data {
    
}

class GuestData {
    
    func monthZero() -> Nubb {
        let device1 = Device(id: "21:c9:d0:43:36:79", name: "Retina MacBook Pro 15\"", color: UIColor.redColor(), totalIn: 42369, totalOut: 5948, totalUsage: 48318)
        let device2 = Device(id: "53:ea:a8:a8:89:dd", name: "iPhone 6 Plus", color: UIColor.cyanColor(), totalIn: 16969, totalOut: 1877, totalUsage: 16946)
        let device3 = Device(id: "87:b9:31:c3:03:11", name: "iPad Air", color: UIColor.greenColor(), totalIn: 10331, totalOut: 2638, totalUsage: 12969)
        let device4 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.yellowColor(), totalIn: 10169, totalOut: 2050, totalUsage: 16919)
        
        let device5 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.purpleColor(), totalIn: 10169, totalOut: 2050, totalUsage: 16919)
        let device6 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.orangeColor(), totalIn: 10169, totalOut: 2050, totalUsage: 16919)
        let device7 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.magentaColor(), totalIn: 10169, totalOut: 2050, totalUsage: 16919)
        let device8 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.magentaColor(), totalIn: 10169, totalOut: 2050, totalUsage: 16919)
        
        return Nubb(totalUsage: 149069, totalIn: 78330, totalOut: 12734, devices: [device1, device2, device3, device4, device5, device6, device7, device8], billingRate: 0.0015, dataCap: 153600)
    }
    
    func monthOne() -> Nubb {
        let device1 = Device(id: "21:c9:d0:43:36:79", name: "Retina MacBook Pro 15\"", color: UIColor.redColor(), totalIn: 29695, totalOut: 5948, totalUsage: 48644)
        let device2 = Device(id: "53:ea:a8:a8:89:dd", name: "iPhone 6 Plus", color: UIColor.cyanColor(), totalIn: 16973, totalOut: 2094, totalUsage: 19850)
        let device3 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.yellowColor(), totalIn: 10169, totalOut: 2053, totalUsage: 54622)
        
        return Nubb(totalUsage: 69064, totalIn: 55330, totalOut: 12734, devices: [device1, device2, device3], billingRate: 0.0015, dataCap: 153600)
    }
    
    func monthTwo() -> Nubb {
        let device1 = Device(id: "21:c9:d0:43:36:79", name: "Retina MacBook Pro 15\"", color: UIColor.redColor(), totalIn: 39425, totalOut: 5948, totalUsage: 48344)
        let device2 = Device(id: "53:ea:a8:a8:89:dd", name: "iPhone 6 Plus", color: UIColor.cyanColor(), totalIn: 14973, totalOut: 1643, totalUsage: 16904)
        let device3 = Device(id: "87:b9:31:c3:03:11", name: "iPad Air", color: UIColor.greenColor(), totalIn: 3445, totalOut: 2692, totalUsage: 16987)
        let device4 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.yellowColor(), totalIn: 10157, totalOut: 2693, totalUsage: 19827)
        
        return Nubb(totalUsage: 100910, totalIn: 78330, totalOut: 12734, devices: [device1, device2, device3, device4], billingRate: 0.0015, dataCap: 153600)
    }
    
    func monthThree() -> Nubb {
        let device1 = Device(id: "21:c9:d0:43:36:79", name: "Retina MacBook Pro 15\"", color: UIColor.redColor(), totalIn: 56290, totalOut: 6948, totalUsage: 69344)
        let device2 = Device(id: "87:b9:31:c3:03:11", name: "iPad Air", color: UIColor.greenColor(), totalIn: 16894, totalOut: 4690, totalUsage: 12983)
        let device3 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.yellowColor(), totalIn: 34829, totalOut: 6969, totalUsage: 12210)
        
        return Nubb(totalUsage: 90897, totalIn: 110330, totalOut: 12734, devices: [device1, device2, device3], billingRate: 0.0015, dataCap: 153600)
    }
    
    func monthFour() -> Nubb {
        let device1 = Device(id: "21:c9:d0:43:36:79", name: "Retina MacBook Pro 15\"", color: UIColor.redColor(), totalIn: 42395, totalOut: 2836, totalUsage: 48729)
        let device2 = Device(id: "53:ea:a8:a8:89:dd", name: "iPhone 6 Plus", color: UIColor.cyanColor(), totalIn: 7842, totalOut: 6977, totalUsage: 14928)
        let device3 = Device(id: "87:b9:31:c3:03:11", name: "iPad Air", color: UIColor.greenColor(), totalIn: 43578, totalOut: 146, totalUsage: 13579)
        let device4 = Device(id: "b4:44:d9:10:db:76", name: "iPhone 5", color: UIColor.yellowColor(), totalIn: 10157, totalOut: 690, totalUsage: 8492)
        
        return Nubb(totalUsage: 46934, totalIn: 78330, totalOut: 12734, devices: [device1, device2, device3, device4], billingRate: 0.0015, dataCap: 153600)
    }
    
    func monthFive() -> Nubb {
        let device1 = Device(id: "21:c9:d0:43:36:79", name: "MacBook", color: UIColor.redColor(), totalIn: 53490, totalOut: 6918, totalUsage: 48344)
        let device2 = Device(id: "53:ea:a8:a8:89:dd", name: "iPhone 6 Plus", color: UIColor.cyanColor(), totalIn: 14973, totalOut: 1877, totalUsage: 16920)
        let device3 = Device(id: "87:b9:31:c3:03:11", name: "iPad Air", color: UIColor.greenColor(), totalIn: 16945, totalOut: 45, totalUsage: 12983)
        
        return Nubb(totalUsage: 156997, totalIn: 50000, totalOut: 12734, devices: [device1, device2, device3], billingRate: 0.0015, dataCap: 153600)
    }
    
    func guestDateArray() -> [String] {
        let format = NSDateFormatter()
        format.dateFormat = "MMMM"
        let index = format.monthSymbols.indexOf(format.stringFromDate(NSDate()))
        var year = NSCalendar.currentCalendar().components([.Year], fromDate: NSDate()).year
        var newArray = [format.monthSymbols[index!]+" \(year)"]
        if index == 0 { year = year - 1 }
        for x in 1...5 {
            var idx = index! - x
            if idx < 0 {
                idx = format.monthSymbols.endIndex.advancedBy(idx)
            }
            newArray.append(format.monthSymbols[idx]+" \(year)")
            if index! - x == 0 {
                year = year - 1
            }
        }
        return newArray
    }

}