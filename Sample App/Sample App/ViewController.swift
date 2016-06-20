//
//  ViewController.swift
//  Sample App
//
//  Created by David Tamrazov on 2016-06-20.
//  Copyright © 2016 David Tamrazov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //instantiated manager objects to make calls with
        let userManager = UserManager()
        let itemManager = ItemManager ()
        
        //creating a user object and setting the local user 
        userManager.createUser("David", last: "Tamrazov", email: "dt15217@gmail.com") {user, error in
            guard error == nil else {
                print("Error creating user on server: \(error)")
                return
            }
            
            //just in case, avoid accessing nil
            if let user = user {
                //self-explanatory
                LocalUser.user = user
                
                //do whatever else you wanna do with the newly created user object here
            }
        }
        
        //use this when signing in through Facebook as the email is the only info we'll have at the time
        userManager.retrieveUserByEmail("dt15217@gmail.com") { user, error in
            guard user == nil else {
                print("Error retrieving user from server: \(error)")
                return
            }
            
            if let user = user {
                //do whatever you wanna do with the retrieved user object here
            }
        }
        
        
        //use this to retrieve users through the "owner" property of an item
        userManager.retrieveUserById(id) { user, error in
            guard user == nil else {
                print("Error retrieving user from server: \(error)")
                return
            }
            
            if let user = user {
                //do whatever you wanna do with the retrieved user object here
            }
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

