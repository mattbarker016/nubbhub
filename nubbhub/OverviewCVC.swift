//
//  overviewCollectionViewCell.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/7/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit

class OverviewCVC: UICollectionViewCell {
    
    @IBOutlet weak var averageTop: UILabel!
    @IBOutlet weak var averageNum: UILabel!
    @IBOutlet weak var averageBot: UILabel!
    
    @IBOutlet weak var forecastTop: UILabel!
    @IBOutlet weak var forecastNum: UILabel!
    @IBOutlet weak var forecastBot: UILabel!
    
    @IBOutlet weak var suggestTop: UILabel!
    @IBOutlet weak var suggestNum: UILabel!
    @IBOutlet weak var suggestBot: UILabel!
    
    @IBOutlet weak var costTop: UILabel!
    @IBOutlet weak var costNum: UILabel!
    @IBOutlet weak var costBot: UILabel!
    
    func setCell(identifier: String, data: Nubb, date: NSDate, theme: Theme, reduced: Bool, guest: Bool, helper: Bool) {
        
        let today = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: NSDate())
        let dateMonth = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: date)
        let dateMonthLength = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date).length
        var gbPerDay: Float!
        
        if today.month == dateMonth.month || guest {
            gbPerDay = data.byteRoundExact(data.totalUsage / today.day)
        } else {
            gbPerDay = data.byteRoundExact(data.totalUsage / dateMonthLength)
        }
  
        let gbPerMonth = round(gbPerDay * Float(dateMonthLength) * 10) / 10
        
        if identifier == "average" {
            if gbPerDay > 10 {
                if today.month == dateMonth.month || guest {
                    gbPerDay = data.byteRound(data.totalUsage / today.day)
                } else {
                    gbPerDay = data.byteRound(data.totalUsage / dateMonthLength)
                }
            }
            if reduced {
                averageTop.font = UIFont(name: "HelveticaNeue", size: 12)
                averageNum.font = UIFont(name: "HelveticaNeue-Light", size: 32)
                averageBot.font = UIFont(name: "HelveticaNeue", size: 10)
            }
            averageTop.text = "average"
            averageNum.text = "\(gbPerDay)"
            averageBot.text = "GB / day"
            averageTop.textAlignment = .Center; averageTop.textColor = theme.secondary
            averageNum.textAlignment = .Center; averageNum.textColor = theme.secondary
            averageBot.textAlignment = .Center; averageBot.textColor = theme.secondary
        }
        
        if identifier == "forecast" {
            if reduced {
                forecastTop.font = UIFont(name: "HelveticaNeue", size: 12)
                forecastNum.font = UIFont(name: "HelveticaNeue-Light", size: 32)
                forecastBot.font = UIFont(name: "HelveticaNeue", size: 10)
            }
            forecastTop.text = "forecast"
            forecastNum.text = "\(gbPerMonth)"
            forecastBot.text = "GB / month"
            //forecastNum.font = UIFont(name: "HelveticaNeue-Light", size: 42)
            forecastTop.textAlignment = .Center; forecastTop.textColor = theme.secondary
            forecastNum.textAlignment = .Center; forecastNum.textColor = theme.secondary
            forecastBot.textAlignment = .Center; forecastBot.textColor = theme.secondary
            
            //if forecast is over dataCap, highlight value: red by default; bolded if needed
            if gbPerMonth > data.byteRound(data.dataCap) {
                if theme.name == "big red" || theme.name == "sky" || theme.name == "chrome" || theme.name == "forest" {
                    forecastNum.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
                }
                else {
                    forecastNum.textColor = UIColor.redColor()
                }
            }
        }
        
        if identifier == "suggested" {
            var suggest = data.byteRoundExact((data.dataCap - data.totalUsage) / (dateMonthLength - today.day))
            if suggest > 10 {
                suggest = data.byteRound((data.dataCap - data.totalUsage) / (dateMonthLength - today.day))
            }
            if reduced {
                suggestTop.font = UIFont(name: "HelveticaNeue", size: 12)
                suggestNum.font = UIFont(name: "HelveticaNeue-Light", size: 32)
                suggestBot.font = UIFont(name: "HelveticaNeue", size: 10)
            }
            suggestTop.text = "suggested"
            suggestNum.text = "\(suggest)"
            suggestBot.text = "GB / day"
            suggestTop.textAlignment = .Center; suggestTop.textColor = theme.secondary
            suggestNum.textAlignment = .Center; suggestNum.textColor = theme.secondary
            suggestBot.textAlignment = .Center; suggestBot.textColor = theme.secondary
        }
        
        if identifier == "cost" {
            if (data.totalUsage > data.dataCap || helper) && !(data.totalUsage > data.dataCap && helper) {
                costTop.text = "amount owed"
                costNum.text = "\(round(Float(data.totalUsage - data.dataCap) * data.billingRate * 100) / 100)"
            }
            else {
                costTop.text = "estimated cost"
                let amountGB = (gbPerDay * Float(dateMonthLength)) - data.byteRoundExact(data.dataCap)
                costNum.text = "\(round(amountGB * 1000 * data.billingRate * 100) / 100)"
            }
            costBot.text = "dollars"
            
            //checks: make sure charge is between 0-50, and has two decimal places
            if Float(costNum.text!)! > 50.0 { costNum.text = "50.00" } //NUBB doesn't charge past $50
            if Float(costNum.text!)! < 0.00 { costNum.text = "0.00" } //negative money, I wish
            
            switch Int((costNum.text?.substringFromIndex((costNum.text?.characters.indexOf(".")!)!).characters.count)!) {
            case 1: costNum.text = costNum.text!+"00"
            case 2: costNum.text = costNum.text!+"0"
            default: break
            }
            
            if reduced {
                costTop.font = UIFont(name: "HelveticaNeue", size: 12)
                costNum.font = UIFont(name: "HelveticaNeue-Light", size: 32)
                costBot.font = UIFont(name: "HelveticaNeue", size: 10)
            }
            //costNum.font = UIFont(name: "HelveticaNeue-Light", size: 42)
            costTop.textAlignment = .Center; costTop.textColor = theme.secondary
            costNum.textAlignment = .Center; costNum.textColor = theme.secondary
            costBot.textAlignment = .Center; costBot.textColor = theme.secondary
            
            //highlight amount owed: red by default; otherwise, bolded
            if costTop.text == "amount owed" && data.totalUsage > data.dataCap {
                if theme.name == "big red" || theme.name == "sky" || theme.name == "chrome" || theme.name == "forest" {
                    costNum.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
                } else {
                    costNum.textColor = UIColor.redColor()
                }
            }
        }
        
    }
    
}
