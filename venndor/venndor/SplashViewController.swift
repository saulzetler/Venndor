//
//  SplashViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-20.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

//splash view controller to allow for data to be loaded before displaying browse
class SplashViewController: UIViewController {
    
    //perform during load to allow for a shorter splash screen/early call.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //declare managers to pull data of each object
        let userManager = UserManager()
        let itemManager = ItemManager()
        
        //first pull the user/check he/she exist
        userManager.retrieveUserByEmail(LocalUser.email) { user, error in
            guard error == nil else {
                print("Error retrieving user from database: \(error)")
                return
                }
            
            if user != nil {
                
                //if they do set the data!
                LocalUser.user = user
                print("\(LocalUser.user.email)")
                
                //fix for ui testing
                //self.triggerSegue()
                
            }
            else {
                //otherwise create a new user to add to our system
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email) { user, error in
                    LocalUser.user = user
                    
                    //since were creating a new user this is their first time send them to tutorial.
                    self.performSegueWithIdentifier("goTutorial", sender: self)
                    
                    
                    
                    
                    /* ADD FUNCTION TO PULL ITEMS EVEN IF GOING TO TUTORIAL*/
                    
                    
                    
                }
            }
            //now that we have the user data set up pull items to load into browse.
            itemManager.retrieveMultipleItems(5, offset: nil, filter: GlobalItems.currentCategory) { items, error in
                guard error == nil else {
                    print("Error retrieving items from server: \(error)")
                    return
                }
                
                if items != nil {
                    //set the global items so we can keep track of what items are loaded
                    GlobalItems.items = items!
                    
                    //for loop to check every item followed by a...
                    for x in 0..<GlobalItems.items.count{
                        //while loop to ensure each item is loaded before transitioning to give the user a seemless experience
                        while GlobalItems.items[x].photos == nil {
                            continue
                        }
                    }
                    self.performSegueWithIdentifier("showBrowse", sender: self)
                }
            }
        }
    }
}

