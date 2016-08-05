//
//  SettingsViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var containerView: UIView!
    let screenSize = UIScreen.mainScreen().bounds
    var tableViewItems = ["About Venndor", "Delete Account", "Log Out"]
    var tableView: UITableView!
    
    var sessionStart: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView = UIView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: screenSize.height*0.9))
        containerView.backgroundColor = UIColorFromHex(0xecf0f1)
        self.view.addSubview(containerView)
        
        LocalUser.user.mostRecentAction = "Went to Settings"
        sessionStart = NSDate()
        
        setUpTableView()
        
        //add the generic views of each page ie. header and side menu
        addHeaderOther("Settings")
        sideMenuGestureSetup()
        revealViewController().rightViewController = nil
        self.revealViewController().delegate = self
        
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: screenSize.height*0.23), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        containerView.addSubview(tableView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .DisclosureIndicator
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel!.text = tableViewItems[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Avenir", size: 14)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            toAbout()
        case 1:
            deleteAccount()
        case 2:
            logOut()
        default:
            break
        }
        if indexPath.row == 2 {
            logOut()
        }
        
//        print("You selected cell #\(indexPath.row)!")
    }
    
    
    //logout button for when the user wants to log out
    func logOut() {
        //logs the user out of facebook along with out app
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    func deleteAccount() {
        //to be filled out by dave
    }
    
    func toAbout() {
        let avc = AboutViewController()
        self.presentViewController(avc, animated: true, completion: nil)
    }
    
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            containerView.userInteractionEnabled = true
            reactivate()
        } else {
            containerView.userInteractionEnabled = false
            deactivate()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "SettingsViewController")
    }
    
    
}