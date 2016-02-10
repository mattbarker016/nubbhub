//
//  Nubb.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/28/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

class Nubb: NSObject {
    
    var totalUsage: Int
    var totalIn: Int
    var totalOut: Int

    var devices: [Device]
    
    //"constants"
    var billingRate: Float
    var dataCap: Int
    
    init(totalUsage: Int, totalIn: Int, totalOut: Int, devices: [Device], billingRate: Float, dataCap: Int) {
        self.totalUsage = totalUsage
        self.totalIn = totalIn
        self.totalOut = totalOut
        self.devices = devices
        self.billingRate = billingRate
        self.dataCap = dataCap
    }
    
    func byteRound(value: Int) -> Float {
        return round(Float(value) / Float(100)) / 10
    }
    
    func byteRoundExact(value: Int) -> Float {
        return round(Float(value) / Float(10)) / 100
    }
    
}