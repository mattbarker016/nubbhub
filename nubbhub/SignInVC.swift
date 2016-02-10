//
//  SignInVC.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/23/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import WebKit

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
            
            //encryption here
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
    
