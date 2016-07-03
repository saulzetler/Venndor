//
//  SplashViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-20.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userManager = UserManager()
        let itemManager = ItemManager()
        let seenPostsManager = SeenPostsManager()
        var seenPostsMade = false
        
        userManager.retrieveUserByEmail(LocalUser.email) { user, error in
            guard error == nil else {
                print("Error retrieving user from database: \(error)")
                return
                }
            
            if user != nil {
                LocalUser.user = user
                print("\(LocalUser.user.email)")
                seenPostsMade = true
            }
            else {
                
                //create the user on the server
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email) { user, error in
                    LocalUser.user = user
                    LocalUser.seenPosts["_id"] = LocalUser.user.id
                    
                    //create the seenPosts object on the server
                    seenPostsManager.createSeenPostsById(LocalUser.user.id, completionHandler: { error in
                        guard error == nil else {
                            print("IT DOESN'T FUKIN WORK BRO FIGURE IT OUT.")
                            print("\(error)")
                            return
                        }
                        seenPostsMade = true
                        self.triggerSegueTutorial()
                    })
                }
            }
        }
        
        while LocalUser.user == nil {
            continue
        }
            
        while seenPostsMade == false {
            continue
        }
            
        let filterString = constructFilter(LocalUser.seenPosts)
        print("Filter string: \(filterString)")
            
        itemManager.retrieveMultipleItems(5, offset: nil, filter: filterString, fields: nil) { items, error in
            guard error == nil else {
                print("Error retrieving items from server: \(error)")
                return
            }
                
            if let items = items {
                GlobalItems.items = items
            }
        }
            
        while GlobalItems.items.count == 0 {
            continue
        }
            
        for x in 0..<GlobalItems.items.count {
            print("\(GlobalItems.items[x].id)")
            while GlobalItems.items[x].photos == nil {
                continue
            }
        }
            
        print("Ready to segue")
            
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showBrowse", sender: self)
        }
    }
    
    
    func constructFilter(seenPosts: Dictionary<String, AnyObject>) -> String {
        var ids: String!
        var index = 0
        
        for (key, _ ) in seenPosts {
            
            if key == "_id" {
                continue
            }
            else {
                ids = index > 0 ? "\(ids) and (_id != \(key))" : "(_id != \(key))"
            }
            index++
        }
        
        if GlobalItems.categorySelected != nil {
            ids = "\(ids) and (\(GlobalItems.categorySelected))"
        }
        
        return ids
    }

    
    func triggerSegue(){
        performSegueWithIdentifier("showBrowse", sender: self)
    }
    func triggerSegueTutorial(){
        performSegueWithIdentifier("goTutorial", sender: self)
    }
    
}


