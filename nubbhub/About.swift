//
//  About.swift
//  nubbhub
//
//  Created by Matthew Barker on 2/9/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class AboutVC: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var github: UIButton!
    @IBOutlet weak var instagram: UIButton!
    @IBOutlet weak var youtube: UIButton!
    
    override func viewDidLoad() {
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        github.layer.cornerRadius = github.frame.size.width / 5
        youtube.layer.cornerRadius = youtube.frame.size.width / 5
        
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("sendFeedback:"))
        recognizer.delegate = self
        profilePic.addGestureRecognizer(recognizer)
    }
    
    func open(url: String) {
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(URL: NSURL(string: url)!)
            svc.delegate = self
            UIApplication.sharedApplication().statusBarStyle = .Default
            self.presentViewController(svc, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
    }
    
    @IBAction func github(sender: UIButton) {
        open("https://github.com/mattbarker016")
    }
    
    @IBAction func instagram(sender: UIButton) {
        open("https://www.instagram.com/mattbarker016/")
    }
    
    @IBAction func youtube(sender: UIButton) {
        open("https://www.youtube.com/user/mattbarker016")
    }
    
    //doesn't work in simulator
    func sendFeedback(sender: UITapGestureRecognizer) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["mjb485@cornell.edu"])
        mailComposerVC.setSubject("nubbhub feedback")
        mailComposerVC.setMessageBody("Wow, this app is amazing!", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //dismiss SVC
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
