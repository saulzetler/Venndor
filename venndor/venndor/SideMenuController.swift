//
//  SideMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-09.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class SideMenuController: UITableViewController {
    
    @IBAction func logOut(sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
        
    }
    
    @IBAction func postItem() {
        self.performSegueWithIdentifier("postInfo", sender: self)
    }
    
}