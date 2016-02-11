//
//  ViewController.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/15/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var deviceTable: UITableView!
    @IBOutlet weak var overviewCollectionView: UICollectionView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var overviewConstraint: NSLayoutConstraint!
    
    let cal = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: NSDate())
    let daysInMonth = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: NSDate()).length
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    let settings = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
    let calendar = UIButton(type: UIButtonType.Custom) as UIButton
    
    var theme = Theme(name: "modern", primary: UIColor.blackColor(), secondary: UIColor.whiteColor(), arc: UIColor.redColor(), colorArray: [UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.purpleColor(), UIColor.orangeColor(), UIColor.magentaColor()], statusBar: ".LightContent", gradient: nil)
    
    var webView = WKWebView()
    var counterView: CounterView?
    var spinner = UIActivityIndicatorView()
    var noDataUsageLabel = UILabel()
    var captionLabel = UILabel()
    
    var nubb: Nubb?
    var reduced: Bool = false
    var guest: Bool = false
    var chosenMonth = NSDate()
    var dateArray: [String]?
    var bounds = UIScreen.mainScreen().bounds
    
    var timer = NSTimer()
    var counter = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear is running")
        print("theme is \(theme.name)")
        
        UIApplication.sharedApplication().statusBarStyle = theme.style(theme.statusBar)!
        
        //if user doesn't exist, show Intro
        if prefs.stringForKey("netid") == nil && prefs.stringForKey("password") == nil && !guest {
            self.counterView?.removeFromSuperview()
            self.noDataUsageLabel.removeFromSuperview()
            self.captionLabel.removeFromSuperview()
            
            //hides storyboard elements
            overviewLabel.hidden = true
            detailsLabel.hidden = true
            overviewCollectionView.hidden = true
            deviceTable.hidden = true
            
            self.presentViewController(storyboard!.instantiateViewControllerWithIdentifier("login_screen"), animated: true, completion: { () -> Void in })
        }
        
        if guest {
            calendar.enabled = true
        }
            //self.performSegueWithIdentifier("login_screen", sender: self)
        print("viewDidAppear done")
    }
    
    override func viewDidLoad() {
        print("viewDidLoad did start")
        super.viewDidLoad()
        
        /*
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.blackColor().CGColor, UIColor.redColor().CGColor]
        view.layer.addSublayer(layer)
        */
        
        //loads webpage
        self.webView.navigationDelegate = self
        if prefs.stringForKey("netid")?.isEmpty == false && prefs.stringForKey("password")?.isEmpty == false {
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string:"https://nubb.cornell.edu")!))
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
        
        //loads theme
        if prefs.valueForKey("theme") != nil {
            let trans = prefs.valueForKey("theme") as! NSData
            let dataTheme = NSKeyedUnarchiver.unarchiveObjectWithData(trans) as! Theme
            theme = dataTheme
            themeHelper(theme)
        }
        
        //hides storyboard elements
        overviewLabel.hidden = true
        detailsLabel.hidden = true
        overviewCollectionView.hidden = true
        deviceTable.hidden = true
        
        //creates loading indictor
        spinner.center = CGPoint(x: bounds.midX, y: bounds.midY)
        spinner.startAnimating()
        view.addSubview(spinner)
        
        //dummy data for testing 
        nubb = Nubb(totalUsage: 0, totalIn: 0, totalOut: 0, devices: [], billingRate: 0.0, dataCap: 0)
        
        //create settings button
        settings.frame = CGRect(x: 16, y: 28, width: 22, height: 22)
        settings.tintColor = theme.secondary
        settings.addTarget(self, action: "settingsAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(settings)
        
        //create calendar button, disabled until data loads
        calendar.frame = CGRect(x: bounds.width - 40, y: 28, width: 22, height: 22)
        calendar.setImage(UIImage(named: theme.button("cal")), forState: .Normal)
        calendar.addTarget(self, action: "calendarAction:", forControlEvents: UIControlEvents.TouchUpInside)
        calendar.enabled = false
        self.view.addSubview(calendar)
        
        if bounds.width < 370 {
            reduced = true
        }
        
        //overviewCollectionView.selectItemAtIndexPath(NSIndexPath(index: 1), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        
        //delegates and dataSource for tableView, collectionView
        deviceTable.dataSource = self
        deviceTable.delegate = self
        overviewCollectionView.dataSource = self
        overviewCollectionView.delegate = self
        
        print("viewDidLoad did finish")
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    func setUp() {
        print("setUp running")
        
        //creates loading indictor
        spinner.center = CGPoint(x: bounds.midX, y: bounds.midY)
        spinner.startAnimating()
        view.addSubview(spinner)
        
        //removes center labels if they were present
        self.noDataUsageLabel.removeFromSuperview()
        self.captionLabel.removeFromSuperview()
        
        //determines if screen is small, intilizes variable and significant UI changes
        if reduced {
            overviewCollectionView.frame = CGRect(x: overviewCollectionView.frame.minX, y: overviewCollectionView.frame.minY, width: bounds.width, height: 58)
            overviewConstraint.constant = 58
            overviewLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
            detailsLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        }
        
        //unhides storyboard elements
        overviewLabel.hidden = false
        detailsLabel.hidden = false
        overviewCollectionView.hidden = false
        deviceTable.hidden = false
        
        for device in 0...nubb!.devices.count - 1 {
            nubb!.devices[device].color = theme.colorArray[device % theme.colorArray.count]
        }
        
        drawGraph()
        
        print("setUp finished")
    }
    
    func drawGraph() {
        print("drawGraph running")
        
        //clears existing counterView if it exists
        if counterView != nil { counterView!.removeFromSuperview() }
        
        //create counterView graph, special instructions for 4s
        var mainSize = CGSize(width: CGFloat(bounds.width) / 1.5, height: CGFloat(bounds.width) / 1.5)
        if bounds.height < 500 { mainSize = CGSize(width: CGFloat(bounds.width) / 1.75, height: CGFloat(bounds.width) / 1.75) }
        
        //size: 2/3's of screen width, special instructions for 4s
        var mainOrigin = CGPoint(x:Int(bounds.width)/6,y: Int(UIApplication.sharedApplication().statusBarFrame.size.height) + 8)
        if bounds.height < 500 { mainOrigin.x = bounds.width / (14/3) } //this was some fun math, see nb
        
        //based on size: 1/6 from screen edge, or 1/3 each way from center
        let mainFrame = CGRect(origin: mainOrigin, size: mainSize)
        counterView = CounterView(frame: mainFrame)
        counterView!.backgroundColor = UIColor.clearColor()
        counterView!.setArc(theme.arc)
        view.addSubview(counterView!)
        
        //main center number
        let displaySize = CGSize(width: Int(counterView!.bounds.width), height: Int(counterView!.bounds.height))
        let displayOrigin = CGPoint(x: mainFrame.minX, y: mainFrame.minY)
        let displayFrame = CGRect(origin: displayOrigin, size: displaySize)
        let displayNumber = UILabel(frame: displayFrame)
        displayNumber.text = "\(nubb!.byteRound(nubb!.totalUsage))"
        displayNumber.textColor = theme.secondary
        displayNumber.font = UIFont(name: "HelveticaNeue-UltraLight", size: 92)
        if reduced { displayNumber.font = UIFont(name: "HelveticaNeue-UltraLight", size: 72) }
        if bounds.height < 500 { displayNumber.font = UIFont(name: "HelveticaNeue-UltraLight", size: 62) }
        displayNumber.center = CGPoint(x: counterView!.bounds.width / 2, y: counterView!.bounds.height / 2)
        displayNumber.textAlignment = .Center
        counterView!.addSubview(displayNumber)
        
        //checks if viewing data cycle that isn't current
        let thisMonth = NSCalendar.currentCalendar().components([.Month], fromDate: NSDate())
        let selectedMonth = NSCalendar.currentCalendar().components([.Month], fromDate: chosenMonth)
        
        if !(thisMonth.month == selectedMonth.month) {
            //month/year of data cycle
            let monthSize = CGSize(width: Int(counterView!.bounds.width) / 2, height: Int(counterView!.bounds.height) / 4)
            let monthOrigin = CGPoint(x: mainFrame.maxX, y: mainFrame.maxY)
            let monthFrame = CGRect(origin: monthOrigin, size: monthSize)
            let monthNumber = UILabel(frame: monthFrame)
            let format = NSDateFormatter()
            format.dateFormat = "MMM yyyy"
            monthNumber.text = "\(format.stringFromDate(chosenMonth))"
            monthNumber.textColor = theme.secondary
            monthNumber.font = UIFont(name: "HelveticaNeue-Light", size: 22)
            if reduced { monthNumber.font = UIFont(name: "HelveticaNeue-Light", size: 18) }
            monthNumber.center = CGPoint(x: counterView!.bounds.width / 2, y: counterView!.bounds.height - 18)
            if bounds.height < 500 {
                monthNumber.font = UIFont(name: "HelveticaNeue-Light", size: 16)
                monthNumber.center = CGPoint(x: counterView!.bounds.width / 2, y: counterView!.bounds.height - 14)
            }
            monthNumber.textAlignment = .Center
            counterView!.addSubview(monthNumber)
        } else {
        
        //number of days left
        let daySize = CGSize(width: Int(counterView!.bounds.width) / 4, height: Int(counterView!.bounds.height) / 4)
        let dayOrigin = CGPoint(x: mainFrame.maxX, y: mainFrame.maxY)
        let dayFrame = CGRect(origin: dayOrigin, size: daySize)
        let dayNumber = UILabel(frame: dayFrame)
        dayNumber.text = "\(daysInMonth - cal.day)"
        dayNumber.textColor = theme.secondary
        dayNumber.font = UIFont(name: "HelveticaNeue-Light", size: 26)
        if reduced { dayNumber.font = UIFont(name: "HelveticaNeue-Light", size: 22) }
        if bounds.height < 500 { dayNumber.font = UIFont(name: "HelveticaNeue-Light", size: 20) }
        dayNumber.center = CGPoint(x: counterView!.bounds.width / 2, y: counterView!.bounds.height - 26)
        dayNumber.textAlignment = .Center
        counterView!.addSubview(dayNumber)
        
        //days left string
        let daysLeftSize = CGSize(width: Int(counterView!.bounds.width) / 2, height: Int(counterView!.bounds.height) / 2)
        let daysLeftOrigin = CGPoint(x: mainFrame.minX, y: mainFrame.minY)
        let daysLeftFrame = CGRect(origin: daysLeftOrigin, size: daysLeftSize)
        let daysLeftNumber = UILabel(frame: daysLeftFrame)
        daysLeftNumber.text = "days left"
        if dayNumber.text == "1" { daysLeftNumber.text = "day left" }
        daysLeftNumber.textColor = theme.secondary
        daysLeftNumber.font = UIFont(name: "HelveticaNeue", size: 16)
        if reduced { daysLeftNumber.font = UIFont(name: "HelveticaNeue", size: 14) }
        daysLeftNumber.center = CGPoint(x: counterView!.bounds.width / 2, y: counterView!.bounds.height - 8)
        daysLeftNumber.textAlignment = .Center
        counterView!.addSubview(daysLeftNumber)
            
            }
        
        //alerting UI changes if dataCap has been surpassed
        if self.nubb!.totalUsage > self.nubb!.dataCap {
            if theme.name == "big red" || theme.name == "sky" || theme.name == "forest" {
                displayNumber.font = UIFont(name: "HelveticaNeue", size: 92)
                if reduced { displayNumber.font = UIFont(name: "HelveticaNeue", size: 72) }
                if bounds.height < 500 { displayNumber.font = UIFont(name: "HelveticaNeue", size: 62) }
            } else {
                displayNumber.textColor = UIColor.redColor()
            }
            counterView!.setMDC(self.nubb!.dataCap)
            counterView!.setMDU(self.nubb!.dataCap)
        } else {
            counterView!.setMDC(self.nubb!.dataCap)
            counterView!.setMDU(self.nubb!.totalUsage)
        }
        
        //update display with above info
        counterView!.setNeedsDisplay()
        overviewCollectionView.reloadData()
        deviceTable.reloadData()
        
        //adjust storyboard elements to be under CounterView
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraint = NSLayoutConstraint(item: overviewLabel, attribute: .Top, relatedBy: .Equal, toItem: counterView, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        spinner.stopAnimating()
        
        //print("nubb: totalUsage is \(nubb!.totalUsage), totalIn is \(nubb!.totalIn), totalOut is \(nubb!.totalOut), see devices below, dataCap is \(nubb!.dataCap), and billingRate is \(nubb!.billingRate).")
        
        //for device in nubb!.devices {
            //print("\(device.name): totalUsage: \(device.totalUsage), totalIn: \(device.totalIn), totalOut: \(device.totalOut), color is \(device.color) and id is \(device.id)")
        //}
        
        print("drawGraph done")
    }
    
    func themeHelper(theme: Theme) {
        print("theme helper firing, theme is \(theme.name)")
        let gradient = CAGradientLayer()
        if theme.gradient != nil {
            gradient.frame = view.bounds
            gradient.colors = theme.gradientHelper(theme.gradient!)
            view.layer.insertSublayer(gradient, atIndex: 0)
        } else {
            print("removing, or should be")
            gradient.removeFromSuperlayer()
            view.backgroundColor = theme.primary
        }
        settings.tintColor = theme.secondary
        calendar.tintColor = theme.secondary
        noDataUsageLabel.textColor = theme.secondary
        captionLabel.textColor = theme.secondary
        overviewLabel.textColor = theme.secondary
        detailsLabel.textColor = theme.secondary
        UIApplication.sharedApplication().statusBarStyle = theme.style(theme.statusBar)!
        calendar.setImage(UIImage(named: theme.button("cal")), forState: .Normal)
        if !(nubb == nil) && !(nubb!.devices.count == 0) && !(nubb?.totalUsage == 0) {
            setUp()
        }
    }

    func parser(data: [String]) -> Nubb {
        
        //calculate device data
        var devices = [Device]()
        let numberOfDevices = (data.count - 5 - 12) / 5
        var counter = 1
        
        for n in 0...numberOfDevices - 1 {
            devices.append(Device(id: data[12+(5*n)],
                name: data[13+(5*n)],
                color: theme.colorArray[n % theme.colorArray.count],
                totalIn: Int(self.parserHelper(data[14+(5*n)])),
                totalOut: Int(self.parserHelper(data[15+(5*n)])),
                totalUsage: Int(self.parserHelper(data[16+(5*n)]))))
            if devices.last!.name == "*Set Device Description" {
                devices.last!.name = "Unnamed Device #\(counter)"
                counter += 1
            }
        }
        
        
        //return new data
        return Nubb(totalUsage: Int(self.parserHelper(data[3])),
            totalIn: Int(self.parserHelper(data[data.count - 3])),
            totalOut: Int(self.parserHelper(data[data.count - 2])),
            devices: devices,
            billingRate: self.parserHelper(data[9]),
            dataCap: Int(self.parserHelper(data[5])))
    }
    
    //strips string of anything but numbers and a decimal point
    func parserHelper(string: String) -> Float {
        let decimalSet = NSCharacterSet(charactersInString: ".0123456789")
        let otherCharSet = decimalSet.invertedSet
        return Float(string.componentsSeparatedByCharactersInSet(otherCharSet).joinWithSeparator(""))!
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        print("didFinishNavigation running")
        
        //login to nubb.cornell.edu
        if webView.title! == "Cornell University Web Login" {
        
            let loadUsernameJS = "document.getElementById('netid').value = '"+prefs.stringForKey("netid")!+"';"
            let loadPasswordJS = "document.getElementById('password').value = '"+prefs.stringForKey("password")!+"';"
            let submitFormJS = "document.getElementById('password').form.submit();"
        
            webView.evaluateJavaScript(loadUsernameJS, completionHandler: { (result, error) in })
            webView.evaluateJavaScript(loadPasswordJS, completionHandler: { (result, error) in })
            webView.evaluateJavaScript(submitFormJS, completionHandler: { (result, error) in })
        }
        
        //parses webpage
        else if webView.title! == "Network Usage-Based Billing" {
            print("parsing site")
            
            //checks if nubb report exists
            let checkJS = "document.getElementsByTagName('p')[2].textContent"
            webView.evaluateJavaScript(checkJS, completionHandler: { (result, error) -> Void in
                
                //show message "no data usage"
                if (result as! String).containsString("No NUBB data to report") {
                    
                    self.counterView?.removeFromSuperview()
                    self.overviewCollectionView.hidden = true
                    self.deviceTable.hidden = true
                    self.overviewLabel.hidden = true
                    self.detailsLabel.hidden = true
                    
                    self.spinner.stopAnimating()
                    
                    self.noDataUsageLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 200)
                    self.noDataUsageLabel.text = "no data usage"
                    self.noDataUsageLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 52)
                    if self.reduced { self.noDataUsageLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 44) }
                    self.noDataUsageLabel.sizeToFit()
                    self.noDataUsageLabel.textAlignment = .Center
                    self.noDataUsageLabel.textColor = self.theme.secondary
                    self.noDataUsageLabel.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY - 25)
                    self.view.addSubview(self.noDataUsageLabel)
                    
                    self.captionLabel.frame = CGRect(x: 0, y: 0, width: self.noDataUsageLabel.frame.width - 80, height: 200)
                    self.captionLabel.numberOfLines = 2
                    self.captionLabel.text = "tap the selector button to view another month"
                    self.captionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
                    self.captionLabel.textAlignment = .Center
                    self.captionLabel.textColor = self.theme.secondary
                    self.captionLabel.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY + 35)
                    self.view.addSubview(self.captionLabel)
                }
                
                //parse data, pass to variable test
                else {
                    
                    let parse = "y = document.getElementsByTagName('td'); a = []; for (i=0;i<y.length;i++) { a.push(y[i].textContent); }; a"
                    
                    webView.evaluateJavaScript(parse, completionHandler: { (result, error) in
                        let data = result as! [String]
                        self.nubb = self.parser(data)
                        self.setUp()
                        print("site parsed, data passed, reloading!")
                    })
                    self.spinner.stopAnimating()
                }
            })
            
            //get months of past cycles
            let dateJS = "var data = document.getElementsByTagName('option'); x = []; for (var i=1;i<data.length;i++) { x.push(data[i].textContent); }; x"
            
            webView.evaluateJavaScript(dateJS, completionHandler: { (result, error) in
                self.dateArray = self.formatDateArray((result as? [String])!.reverse())
                self.calendar.enabled = true
                print("dataArray filled")
            })
            
            print("resetting timer")
            self.timer.invalidate()
            self.counter = 0
            
        }
        
        else {
            print("some other website was visited")
        }
    
        print("didFinishNavigation is finished")
    }
    
    //timeout
    func timerAction(){
        counter += 1
        
        print("title: \(webView.title!)")
        print("loading: \(webView.loading)")
        print("estimated: \(webView.estimatedProgress)")
        print("URL: \(webView.URL!)")
        
        if counter == 12 {
            timer.invalidate()
            counter = 0
            webView.stopLoading()
            let alertController = UIAlertController(title: "Network Timeout", message: "Hmm, your connection seems slow. Try reloading with a better internet connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { (UIAlertAction) -> Void in
                self.spinner.stopAnimating()
                self.timer.invalidate()
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
            }))
            alertController.addAction(UIAlertAction(title: "Reload", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string:"https://nubb.cornell.edu")!))
                self.timer.invalidate()
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //create popover and send needed data to view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calendar" {
            let destination = segue.destinationViewController as! CalendarTVC
            destination.dateArray = self.dateArray
            destination.guest = guest
            
            destination.modalPresentationStyle = .Popover
            destination.popoverPresentationController!.delegate = self
            destination.popoverPresentationController?.sourceRect = CGRect(x: calendar.frame.midX - 6, y: calendar.frame.maxY + 8, width: 1, height: 1)
            var height = dateArray!.count * Int(44) //row height
            if height > Int(bounds.height / 2) { height = Int(bounds.height / 2) }
            destination.preferredContentSize = CGSize(width: Int(bounds.width), height: height)
        }
        if segue.identifier == "settings" {
            print("segue for settings firing")
            let destination = segue.destinationViewController as! SettingsVC
            destination.theme = theme
            destination.guest = guest
            let gradient = CAGradientLayer()
            if theme.gradient != nil {
                gradient.frame = destination.view.bounds
                gradient.colors = theme.gradientHelper(theme.gradient!)
                destination.view.layer.insertSublayer(gradient, atIndex: 0)
            } else {
                gradient.removeFromSuperlayer()
                destination.view.backgroundColor = theme.primary
            }
            destination.doneButton.setImage(UIImage(named: theme.button("ex")), forState: .Normal)
        }
    }
    
    func settingsAction(sender: UIButton!) {
        self.performSegueWithIdentifier("settings", sender: self)
        //self.presentViewController(storyboard!.instantiateViewControllerWithIdentifier("settings"), animated: true) { () -> Void in }
    }
    
    func calendarAction(sender: UIButton!) {
        self.performSegueWithIdentifier("calendar", sender: self)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nubb?.devices.count != nil {
            if !guest {
                nubb!.devices.sortInPlace({ $0.totalUsage > $1.totalUsage })
            }
            return nubb!.devices.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DeviceTableCell
        cell.setDevice(nubb!.devices[indexPath.row], theme: theme, bounds: bounds, reduced: reduced)
        //cell.backgroundColor = theme.primary
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //viewing past data, disabled for guest
        let thisMonth = NSCalendar.currentCalendar().components([.Month], fromDate: NSDate())
        let selectedMonth = NSCalendar.currentCalendar().components([.Month], fromDate: chosenMonth)
        
        if !(thisMonth.month == selectedMonth.month) && !guest {
            return 2
        }
        //user likely will or has already gone over dataCap (by virtue of guest mode, occasionally won't fire even when forecast is greater)
        if (nubb!.byteRoundExact(nubb!.totalUsage / cal.day) * Float(daysInMonth)) > nubb!.byteRoundExact(nubb!.dataCap) {
            return 4
        }
        //show average, forecast, and suggested
        return 3
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if reduced {
            return CGSize(width: 100, height: 62)
        } else {
            return CGSize(width: 120, height: 76)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: OverviewCVC!

        if indexPath.row == 0 {
            if nubb?.totalUsage > nubb?.dataCap {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("cost", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("cost", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: false)
            } else {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("average", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("average", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
                }
            return cell
            }
        if indexPath.row == 1 {            
            if collectionView.numberOfItemsInSection(0) == 2 {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("cost", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("cost", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
                return cell
            }
            if nubb?.totalUsage > nubb?.dataCap {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("cost", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("cost", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
                return cell
            } else {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecast", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("forecast", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
                return cell
                }
            }
        if indexPath.row == 2 {
            if nubb?.totalUsage > nubb?.dataCap {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("average", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("average", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
            } else {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("suggested", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("suggested", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
            }
            return cell
        }
        if indexPath.row == 3 {
            if nubb?.totalUsage > nubb?.dataCap {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecast", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("forecast", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: true)
            } else {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("cost", forIndexPath: indexPath) as! OverviewCVC
                cell.setCell("cost", data: nubb!, date: chosenMonth, theme: theme, reduced: reduced, guest: guest, helper: false)
            }
            return cell
            }
        return cell
    }
    
    func formatDateArray(dateArray: [String]) -> [String] {
        var newArray: [String] = []
        let beforeFormat = NSDateFormatter()
        beforeFormat.dateFormat = "MM-yyyy"
        let afterFormat = NSDateFormatter()
        afterFormat.dateFormat = "MMMM yyyy"
        
        for date in dateArray {
            newArray.append(afterFormat.stringFromDate(beforeFormat.dateFromString(date)!))
        }
        return newArray
    }
    
    @IBAction func unwindToMainView(sender: UIStoryboardSegue) { }
    
}

