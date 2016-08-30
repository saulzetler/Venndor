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
        var matches = [String]()
        var posts = [String]()
        var items = [String]()
        
        for match in LocalUser.matches {
            matches.append(match.id!)
        }

        
        for post in LocalUser.posts {
            posts.append(post.id)
            items.append(post.itemID)
        }

        
        MatchesManager.globalManager.deleteMultipleMatchesById(matches, filter: nil) { error in
            guard error == nil else {
                print("Error deleting users's matches: \(error)")
                return
            }
        }
        
        
        ItemManager.globalManager.deleteMultipleItemsById(items, filter: nil) { error in
            guard error == nil else {
                print("Error deleting users's items: \(error)")
                return
            }
        }
        
        
        
        PostManager.globalManager.deleteMultiplePostsById(posts, filter: nil) { error in
            guard error == nil else {
                print("Error deleting users's posts: \(error)")
                return
            }
        }

        UserManager.globalManager.deleteUserById(LocalUser.user.id) { error in
            guard error == nil else {
                print("Error deleting user from database: \(error)")
                return
            }
            
            print("Succesfully deleted user from server")
            
            SeenPostsManager.globalManager.deleteSeenPostsById(LocalUser.user.id) { error in
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
    }
    func clearLocalUser() {
        LocalUser.user = nil
        LocalUser.email = nil
        LocalUser.firstName = nil
        LocalUser.lastName = nil
        LocalUser.seenPosts = nil
    }
    
}
