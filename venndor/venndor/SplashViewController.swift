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
                LocalUser.user.nuVisits! += 1
                LocalUser.user.mostRecentAction = "Logged in through Facebook."
                
                /**************************************************************************/
                //to be taken out later when the users profile picture is addded to database.
                
                //LocalUser.user.profilePictureURL = LocalUser.profilePictureURL
                
                /**************************************************************************/
                seenPostsMade = true
            }
            else {
                
                //create the user on the server
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email, gender: LocalUser.gender, ageRange: LocalUser.ageRange) { user, error in
                    LocalUser.user = user
                    LocalUser.seenPosts = [String:AnyObject]()
                    LocalUser.user.mostRecentAction = "Logged in through Facebook."
                    LocalUser.seenPosts["_id"] = LocalUser.user.id
             
                    //create the seenPosts object on the server
                    seenPostsManager.createSeenPostsById(LocalUser.user.id, completionHandler: { error in
                        guard error == nil else {
                            print("Error creating user's seen posts: \(error)")
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
                print("Error pulling seen posts by id: \(error)")
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
        
        MatchesManager.globalManager.retrieveUserMatches(LocalUser.user) { matches, error in
            guard error == nil else {
                print("Error retrieving user matches from server: \(error)")
                return
            }
            if let matches = matches {
                LocalUser.matches = matches
                print("Succesfully set the LocalUser's matches")
            }
        }
        
        PostManager.globalManager.retrieveUserPosts(LocalUser.user) { posts, error in
            guard error == nil else {
                print("Error retrieving user posts from the server: \(error)")
                return
            }
            
            if let posts = posts {
                LocalUser.posts = posts
                let posts = LocalUser.posts
                print("Succesfully set the LocalUser's posts.")
            }
        }
            
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
        
        SeenPostsManager.globalManager.patchSeenPostsById(LocalUser.user.id) { error in
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


