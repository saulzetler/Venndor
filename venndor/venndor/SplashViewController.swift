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
            
            while LocalUser.user == nil {
                continue
            }
            
            while seenPostsMade == false {
                continue
            }
            
            seenPostsManager.getSeenPostsById(LocalUser.user.id) { posts, error in
                guard error == nil else {
                    print("YOU AINT PULLIN SHIT YOU PUNKASS")
                    print("\(error)")
                    return
                }
                
                if let posts = posts {
                    LocalUser.seenPosts = posts
                    
                    itemManager.retrieveMultipleItems(10, offset: nil, filter: nil) { items, error in
                        guard error == nil else {
                            print("Error retrieving items from server: \(error)")
                            return
                        }
                        
                        if items != nil {
                            GlobalItems.items = items!
                            for x in 0..<GlobalItems.items.count{
                                while GlobalItems.items[x].photos == nil {
                                    continue
                                }
                            }
                            self.triggerSegue()
                        }
                    }
                }
            }
            
        }
    }
    
    func triggerSegue(){
        self.performSegueWithIdentifier("showBrowse", sender: self)
    }
    func triggerSegueTutorial(){
        self.performSegueWithIdentifier("goTutorial", sender: self)
    }
    
}

