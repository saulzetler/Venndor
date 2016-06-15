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
    
    @IBAction func logOut(sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Settings"
        self.view.addSubview(label)
        
        
        //add header
        let headerView: HeaderView = HeaderView(frame: self.view.frame)
        headerView.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.categoryButton.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
        
    }
    
    
    
}