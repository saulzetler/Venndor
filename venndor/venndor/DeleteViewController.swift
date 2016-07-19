//
//  DeleteViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-04.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController {
    
    
    override func viewDidLoad() {
        FBSDKLoginManager().logOut()
        TimeManager.timeStamp = NSDate()
        let manager = UserManager()
        let spManager = SeenPostsManager()
        manager.deleteUserById(LocalUser.user.id) { error in
            guard error == nil else {
                print("Error deleting user from database: \(error)")
                return
            }
            print("Succesfully deleted user from server")
            spManager.deleteSeenPostsById(LocalUser.user.id) { error in
                guard error == nil else {
                    print("Error deleting user's seen posts.")
                    return
                }
                print("Succesfully deleted SeenPosts.")
                self.clearLocalUser()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("showLogin", sender: self)
                }
            }
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let interval = TimeManager.globalManager.getSessionDuration(TimeManager.timeStamp)
        LocalUser.user.timePerController["DeleteViewController"] += interval
    }
    func clearLocalUser() {
        LocalUser.user = nil
        LocalUser.email = nil
        LocalUser.firstName = nil
        LocalUser.lastName = nil
        LocalUser.seenPosts = nil
    }
    
}
