//
//  Calculations.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/5/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import Foundation
import UIKit

class Calculations: NSObject {

    func byteRound(value: Int) -> Float {
        return round(Float(value) / Float(100)) / 10
    }
    
    func byteRoundExact(value: Int) -> Float {
        return round(Float(value) / Float(10)) / 100
    }

}


