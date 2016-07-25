//
//  SettingsViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var containerView: UIView!
    let screenSize = UIScreen.mainScreen().bounds
    
    var sessionStart: NSDate!

    //logout button for when the user wants to log out
    @IBAction func logOut(sender: UIButton) {
        //logs the user out of facebook along with out app
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView = UIView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: screenSize.height*0.9))
        
        LocalUser.user.mostRecentAction = "Went to Settings"
        sessionStart = NSDate()
        
        //add lable for the title, NEEDS REFACTORING
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Settings"
        containerView.addSubview(label)
        
        //add the generic views of each page ie. header and side menu
        addHeaderOther("Settings")
        sideMenuGestureSetup()
        
        self.revealViewController().delegate = self
        
    }
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            print("active")
            containerView.userInteractionEnabled = true
            reactivate()
        } else {
            print("inactive")
            containerView.userInteractionEnabled = false
            deactivate()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "SettingsViewController")
    }
    
    
}