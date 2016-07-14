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
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let background = UIImage(named: "background.jpg")
        let backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        backgroundView.image = background
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        
        //declare managers to pull data of each object
        let userManager = UserManager()

        let seenPostsManager = SeenPostsManager()
        var seenPostsMade = false
        
        /////////////////////////////////////// IF NOT GUEST //////////////////////////////////////
        
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
                /**************************************************************************/
                //to be taken out later when the users profile picture is addded to database.
                LocalUser.user.profilePicture = LocalUser.profilePicture
                /**************************************************************************/
                seenPostsMade = true
            }
            else {
                
                //create the user on the server
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email) { user, error in
                    LocalUser.user = user
                    LocalUser.seenPosts = [String:AnyObject]()
                    LocalUser.seenPosts["_id"] = LocalUser.user.id
                    
                    /**************************************************************************/
                    //to be taken out later when the users profile picture is addded to database.
                    LocalUser.user.profilePicture = LocalUser.profilePicture
                    /**************************************************************************/
                    
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
        
        //get all the posts the user has seen
        seenPostsManager.getSeenPostsById(LocalUser.user.id) { seenPosts, error in
            
            guard error == nil else {
                print("YOU AINT PULLIN SHIT YOU PUNKASS")
                print("\(error)")
                return
            }
            
            if let posts = seenPosts {
                LocalUser.seenPosts = posts
                print("Dictionary loaded")
            }
        }
        
        while LocalUser.seenPosts == nil {
            continue
        }
        updateSeenPosts()
        
        let matchManager = MatchesManager()
        matchManager.retrieveUserMatches(LocalUser.user) { matches, error in
            guard error == nil else {
                print("Error retrieving user matches from server: \(error)")
                return
            }
            if let matches = matches {
                LocalUser.matches = matches
                print("Succesfully set the LocalUser's matches")
            }
        }
        
        print("Ready to segue")
            
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showBrowse", sender: self)
        }
    }
    
    func updateSeenPosts() {
        for (key, value) in LocalUser.seenPosts {
            if key == "_id" {
                continue
            }
            let postDate = value as! NSDate
            let timeInterval = ( (postDate.timeIntervalSinceNow) / 60 * -1)
            
            if timeInterval >= 5 {
               LocalUser.seenPosts.removeValueForKey(key)
            }
        }
        
        let manager = SeenPostsManager()
        manager.patchSeenPostsById(LocalUser.user.id) { error in
            guard error == nil else {
                print("Error patching LocalUser's seen posts: \(error)")
                return
            }
            
            print("Succesfully patched LocalUser's seen posts")
        }
        
    }
    
    func triggerSegueTutorial(){
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("goTutorial", sender: self)
        }
    }
    
}


