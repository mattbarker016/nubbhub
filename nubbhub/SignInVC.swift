//
//  SignInVC.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/23/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import WebKit
import SwiftyRSA

class SignInVC: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet weak var netid_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var signInWebView = WKWebView()
    let prefs = NSUserDefaults.standardUserDefaults()
    var timer = NSTimer()
    var counter = 0
    var guest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("sign in view did load running")
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        guest = false
        netid_textfield.delegate = self
        password_textfield.delegate = self
        signInWebView.navigationDelegate = self
        signInWebView.loadRequest(NSURLRequest(URL: NSURL(string: "https://nubb.cornell.edu")!))
        
        //selects first textfield automatically
        //netid_textfield.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //gives return key same functionality as signin
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.placeholder == "netid" {
            if textField.text == "" { error("unfilled") }
            textField.resignFirstResponder()
            password_textfield.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            checkValidInfo()
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
            spinner.startAnimating()
        }
        return true
    }
    
    //updates display accordingly while checking is combo works
    @IBAction func signin(sender: AnyObject) {
        password_textfield.endEditing(true)
        checkValidInfo()
    }
    
    //initiates guest mode
    @IBAction func guest(sender: UIButton) {
        guest = true
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    func checkValidInfo() {
        if netid_textfield.text != "" && password_textfield.text != "" {
            
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
            spinner.startAnimating()
            
            let loadUsernameJS = "document.getElementById('netid').value = '\(netid_textfield.text!)';"
            let loadPasswordJS = "document.getElementById('password').value = '\(password_textfield.text!)';"
            let submitFormJS = "document.getElementById('password').form.submit();"
            
            signInWebView.evaluateJavaScript(loadUsernameJS, completionHandler: { (result, error) in })
            signInWebView.evaluateJavaScript(loadPasswordJS, completionHandler: { (result, error) in })
            signInWebView.evaluateJavaScript(submitFormJS, completionHandler: { (result, error) in })
        }
        else {
            error("unfilled")
        }
    }
    
    //timeout
    func timerAction(){
        counter += 1
        if counter == 10 {
            signInWebView.stopLoading()
            signInWebView.loadRequest(NSURLRequest(URL: NSURL(string:"https://nubb.cornell.edu")!))
            error("timeout")
        }
    }
    
    func error(type: String) {
        
        var title: String!
        var message: String!
        
        counter = 0
        self.timer.invalidate()
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), { ()->() in self.spinner.stopAnimating() })
        
        if type == "unfilled" {
            print("error: unfilled")
            title = "Whoops! Log In Failed"
            message = "Please enter both a valid NetID and password."
        }
        
        if type == "incorrect" {
            print("error: incorrect")
            title = "Whoops! Log In Failed"
            message = "Make sure you entered your NetID and password right."
            netid_textfield.text = ""
            password_textfield.text = ""
        }
        
        if type == "timeout" {
            print("error: timeout")
            title = "Whoops! Log In Failed"
            message = "Your connection seems slow. Please make sure you are connected to the internet and try again."
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        print("sign in didFinishNavigation running")
        
        if signInWebView.title == "Cornell University Web Login" {
            let errorJS = "document.getElementById('reason').textContent"
            signInWebView.evaluateJavaScript(errorJS, completionHandler: { (result, error) in
                if result != nil {
                    if result!.containsString("Unable to log in with the supplied NetID and password") {
                        self.timer.invalidate()
                        self.error("incorrect")
                            }
                        }
                    })
        }
        
        if signInWebView.title == "Network Usage-Based Billing" {
            
            
            /*
            let str = "it worked!!!"
            
            let pemString = "-----BEGIN RSA PUBLIC KEY-----
            MIIBCgKCAQEAywsw0aMCjaU91uFUjiBEBmedxAV4y6QFyWvHG6LlWIHyR3tHe3qC
            sD9LlLc0DUQxd/B9qQ07BZwDF+nZbr4ekYreDcuVrrIxnlzQMPejd7Gvisa5IELm
            hunM+2HJlFYSTsXbzNE6A36jYX/UDBiqh8tjM9JunHnljKgASQD4bAHBWqK8KVpp
            4Npko2LhWA35ONjKJsJz1mNKJFWa4w1cp3tfFXjTjXL31f3yKEqJGQJcP5zKhG5/
            vxHbzT3PFeBWN0+aV/qldz6F9C/jn+/0+2GbmcPeXvV7IbX2kuY0ezaVuCq2y1GN
            mxCkoduumpUmZYGWbWunzEhFuLB3Wmk1zQIDAQAB
            -----END RSA PUBLIC KEY-----"

            
            let privString = "-----BEGIN RSA PRIVATE KEY-----Proc-Type: 4,ENCRYPTED DEK-Info: AES-128-CBC,27B4410682A0BE2EB4F617312B04C27Du92zktQtWQJsGz5JluXkWjGWX8JGZSCBSr040iMI02SA8h1ymMsGSh9PZAEeBYrAkuCRQTxMDeLPp6+gqycaMsqpBKGNC9OA0PBQ+UdlNhHRNvL0B1Z8Z5aCYO23vsNn1LWsb6ysyNQI5fWTplsk2riGQ4GKZNjlyZLnzdfXFf6B+ek6FJMsBih6J5pyg4zRZV57SZF4cbautAGeR6YoF1dUqa0MegMezQ+tVXvnr6kecTn85sbnMjJY8J2TsJmSrhwQ7zCes/NLPUow9gsmS5LH1lN52gV3sGD9cBhI+mvLpuQUAp381GjzAoGvwj1cnAskcz4leGn4n3c77Ourw1nocHD7VgQNnYUQYt0nftFiLSZwS+Fu851ZVt4anuMsthwVl8g/xfDAGtITGQHxZy3dSRF5erwaVP3zou1tNit+J98Lli270/6UacBvLCVSNP4GwQU72L/zkbXO1AMZ9ZonlacksVXtyeCWR/B+H/tweWjfQwvhPgMl4FdGQQ2ogvkgdCt2tlnD0GiGQGSTyeYk+ucPLQnjrl3B0b5JGh50JnpaVitCuM6iaH3cDuekq9hS6Ll30jtYoxeGHAd/mBc5vVdDhZY+w7cX81kXYDoF0Pt6qcfTUod4HM2+Oe4AhynO2yd4aMnjHsbKTWYD+brjVT8+6tvGhqwnBTYVaNuRnFMP1dsZReG1iY1p14XkqAQXsTX3wtrx/+XB70NPO4nYyYa6EyXMsE/nlSxc9Atzlgu5s6PtHByCy0bf8wun9iRHj1KLYpqzCpJGYHlCYPZCQ+gc5fhreUeFVtD2f21sm1XnD5GMAO/I2lfPILsnnse8BtAJCWvQ82Q/lvrG4IXXHxIyawT2afpKP+PAm2/SimOHpxcLfLAK32EBcqwHoDLaEUonTQd8Ty081GbIkQ2nezT4BDrY++ngm6sRYELpIdzG6YmybwG3ew4DShBvYQN3zzOIoVsuxCg2hLYF9f+pmOgpe/vZXPzd34H5L3+JlL18ABzuIltKDIg4EYue7tCbyPWy2HCMlNrpQiu+9/6cW/1JpW47z9ny5wKtY0tKBvbaVN6pvUk2f1dfkB6AS26Kla8p0cSh0P7sQTmqsswFtXvV+RQC+fWXG8OyAoPAc50DP+/LwIqsxhnoSfaBGJ5Z2hZ2T2dbwgdpJ/ZmKh28UWe4nNZczmy+wc2DLWja9ELRyZezkbZddbWl6CcbaTEp4Y73sGyb7DrA3Fjt1g0/UTE0TF2ADtCP65xs2X38nuqEiDU7WTrJSsBG6qrvg3HWI14VyonMi79aKL69DOF1HsrBf2SjEK8ScM6QJL9jbpyocdso5yt3b/i0UzwT2ctnLhdX8zIeVesP6AXyhpLFokoB47hOzTd2OCdMs0zKzkaODHsK+kpHzU5T8IQ2IBzRg13baC6v26GITWJtkaIz3pEHVNB9yk8ZJdOmC13yyEvS58qqBDT8orkfysk0LzenhvZEQeshExUQLSBaeLf7KK583d6+fW5RGhL72mK4rGNbYXs95Rna5OhWxrEIc6NaXLrIBOMStFjcyQjWYUopNT8SAcgClvbNtaSHTkhuwZe24wIVvUTm/6QNMVlH-----END RSA PRIVATE KEY-----"
            
            let encrypted = try! SwiftyRSA.encryptString(str, publicKeyPEM: pemString)
            print("encrypt is \(encrypted)")
            let decrypted = try! SwiftyRSA.decryptString(encrypted, privateKeyPEM: privString)
            print("decrypt is \(decrypted)")*/
            
            prefs.setValue(netid_textfield.text, forKey: "netid")
            prefs.setValue(password_textfield.text, forKey: "password")
            
            counter = 0
            timer.invalidate()
            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), { ()->() in self.spinner.stopAnimating() })
            
            self.performSegueWithIdentifier("unwind", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue firing")
        if segue.identifier == "unwind" {
            
            //prepare display, especially if sign out was used
            let destination = segue.destinationViewController as! ViewController
            
            let test = Theme(name: "modern", primary: UIColor.blackColor(), secondary: UIColor.whiteColor(), arc: UIColor.redColor(), colorArray: [UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.purpleColor(), UIColor.orangeColor(), UIColor.magentaColor()], statusBar: ".LightContent", gradient: nil)
            
            let data = NSKeyedArchiver.archivedDataWithRootObject(test)
            prefs.setObject(data, forKey: "theme")
            
            destination.themeHelper(destination.theme)
            destination.counterView?.removeFromSuperview()
            destination.noDataUsageLabel.removeFromSuperview()
            destination.captionLabel.removeFromSuperview()
            destination.overviewLabel.hidden = true
            destination.detailsLabel.hidden = true
            destination.overviewCollectionView.hidden = true
            destination.deviceTable.hidden = true
            destination.spinner.startAnimating()
            
            if guest {
                print("guest mode")
                destination.nubb = GuestData().monthZero()
                destination.dateArray = GuestData().guestDateArray()
                destination.guest = true
                destination.setUp()
            }
            
            else {
                destination.webView.loadRequest(NSURLRequest(URL: NSURL(string:"https://nubb.cornell.edu")!))
                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
            }

            }
        }

}
    
