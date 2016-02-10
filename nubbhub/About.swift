//
//  About.swift
//  nubbhub
//
//  Created by Matthew Barker on 2/9/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit
import SafariServices

class AboutVC: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var github: UIButton!
    @IBOutlet weak var instagram: UIButton!
    @IBOutlet weak var youtube: UIButton!
    
    override func viewDidLoad() {
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        github.layer.cornerRadius = github.frame.size.width / 5
        youtube.layer.cornerRadius = youtube.frame.size.width / 5
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
    
    //dismiss SVC
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
