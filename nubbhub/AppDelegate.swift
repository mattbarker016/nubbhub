//
//  AppDelegate.swift
//  nubbhub
//
//  Created by Matthew Barker on 12/15/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    var timer = NSTimer()
    let prefs = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        print("min: \(UIApplicationBackgroundFetchIntervalMinimum)")
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("background firing!")
        
        //reset if first of the month
        let cal = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: NSDate())
        if cal.day == 1 {
            prefs.removeObjectForKey("firstNotifBool")
            prefs.removeObjectForKey("secondNotifBool")
            prefs.removeObjectForKey("thirdNotifBool")
        }
        
        //load data
        if let vc = window?.rootViewController as? ViewController {
            if !(NSUserDefaults.standardUserDefaults().valueForKey("netid") == nil) {
                vc.webView.loadRequest(NSURLRequest(URL: NSURL(string: (string:"https://nubb.cornell.edu"))!))
                timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerAction:", userInfo: vc, repeats: false)
                print("website requested, timer started")
                completionHandler(.NewData)
            }
        }
        
        completionHandler(.NoData)
    }
    
    //set notifcation depending on data
    func timerAction(timer: NSTimer) -> Bool {
        print("timer going")
        let vc = timer.userInfo as! ViewController
        let svc = SettingsVC()
        let notification = UILocalNotification()
        notification.alertAction = "view details"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = NSDate(timeIntervalSinceNow: 3)
        
        if vc.nubb!.totalUsage > vc.nubb!.dataCap * svc.notificationFirstAlert / 100 && prefs.valueForKey("firstNotifBool") == nil {
            notification.alertBody = "You have used \(svc.notificationFirstAlert)%% of your data for this month"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            print("scheduled first notification")
            prefs.setBool(true, forKey: "firstNotifBool")
            return true
        }
        if vc.nubb!.totalUsage > vc.nubb!.dataCap * svc.notificationSecondAlert / 100 && prefs.valueForKey("secondNotifBool") == nil {
            notification.alertBody = "You have used \(svc.notificationSecondAlert)%% of your data for this month"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            print("scheduled first notification")
            prefs.setBool(true, forKey: "secondNotifBool")
            return true
        }
        if vc.nubb!.totalUsage > vc.nubb!.dataCap * svc.notificationThirdAlert / 100 && prefs.valueForKey("thirdNotifBool") == nil {
            notification.alertBody = "You have used \(svc.notificationThirdAlert)%% of your data for this month"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            print("scheduled first notification")
            prefs.setBool(true, forKey: "thirdNotifBool")
            return true
        }
        
        return false
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

