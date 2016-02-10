//
//  Device.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/28/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

class Device: NSObject {
    
    var id: String
    var name: String
    var color: UIColor?
    var totalIn: Int
    var totalOut: Int
    var totalUsage: Int
    
    init(id: String, name: String, color: UIColor?, totalIn: Int, totalOut: Int, totalUsage: Int) {
        self.id = id
        self.name = name
        self.color = color
        self.totalIn = totalIn
        self.totalOut = totalOut
        self.totalUsage = totalUsage
    }
    
    func byteRound(value: Int) -> Float {
        return round(Float(value) / Float(100)) / 10
    }
    
    func byteRoundExact(value: Int) -> Float {
        return round(Float(value) / Float(10)) / 100
    }
    
}
