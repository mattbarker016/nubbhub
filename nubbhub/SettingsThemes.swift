//
//  SettingsThemes.swift
//  nubbhub
//
//  Created by Matthew Barker on 1/16/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit

class SettingsThemes: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var themesTableView: UITableView!
    let prefs = NSUserDefaults.standardUserDefaults()
    var theme: Theme?
    var themes: [Theme]!
    
    override func viewDidLoad() {
        themesTableView.delegate = self
        themesTableView.dataSource = self
        
        themes = theme!.allThemes()
        for pick in themes {
            themesTableView.selectRowAtIndexPath(NSIndexPath(forItem: themes.indexOf(pick)!, inSection: 0), animated: true, scrollPosition: .None)
            if pick.name == theme?.name {
                themesTableView.cellForRowAtIndexPath(NSIndexPath(forItem: themes.indexOf(pick)!, inSection: 0))?.accessoryType = .Checkmark
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = themes[indexPath.row].name
        cell!.textLabel?.textColor = themes[indexPath.row].arc
        
        let gradient = CAGradientLayer()
        if themes[indexPath.row].gradient != nil {
            gradient.transform = CATransform3DMakeRotation(CGFloat(3.0 * M_PI / 2.0), 0, 0, 1.0)
            gradient.frame = cell!.bounds
            gradient.colors = themes[indexPath.row].gradientHelper(themes[indexPath.row].gradient!)
            cell!.layer.insertSublayer(gradient, atIndex: 0)
        } else {
            gradient.removeFromSuperlayer()
            cell!.backgroundColor = themes[indexPath.row].primary
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        theme = themes[indexPath.row]
        dispatch_async(dispatch_get_main_queue(), { self.performSegueWithIdentifier("unwind", sender: self) })
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare firing")
        if segue.identifier == "unwind" {
            let destination = segue.destinationViewController as! SettingsVC
            
            let data = NSKeyedArchiver.archivedDataWithRootObject(theme!)
            prefs.setObject(data, forKey: "theme")
            
            destination.theme = theme
            
            let gradient = CAGradientLayer()
            if theme?.gradient != nil {
                gradient.frame = destination.view.bounds
                gradient.colors = theme!.gradientHelper(theme!.gradient!)
                destination.view.layer.insertSublayer(gradient, atIndex: 0)
            } else {
                gradient.removeFromSuperlayer()
                destination.view.backgroundColor = theme?.primary
            }
            
            UIApplication.sharedApplication().statusBarStyle = theme!.style(theme!.statusBar)!
            destination.doneButton.setImage(UIImage(named: theme!.button("ex")), forState: .Normal)
            destination.settingsTableView.reloadData()
        }
    }
    
    func tableDisplay(cell: UITableViewCell, theme: Theme) {
        //uncomment these two lines
        //
        //cell!.textLabel?.textColor = themes[indexPath.row].arc
        //cell!.backgroundColor = themes[indexPath.row].primary
        //
        //call this function instead in cellForRow, add any exceptions here as if statement
    }
    
}