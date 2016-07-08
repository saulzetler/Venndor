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
        let filePath = NSBundle.mainBundle().pathForResource("splashGif", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        
        //declare managers to pull data of each object
        let userManager = UserManager()
        let itemManager = ItemManager()

        let seenPostsManager = SeenPostsManager()
        var seenPostsMade = false
        

        
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
                seenPostsMade = true
            }
            else {
                
                //create the user on the server
                userManager.createUser(LocalUser.firstName, last: LocalUser.lastName, email: LocalUser.email) { user, error in
                    LocalUser.user = user
                    LocalUser.seenPosts = [String:AnyObject]()
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
        
        //while loop to ensure each item is loaded before transitioning to give the user a seemless experience
        for x in 0..<GlobalItems.items.count {
            print("\(GlobalItems.items[x].id)")
            while GlobalItems.items[x].photos == nil {
                continue
            }
        }
        
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
    
    
    func constructFilter(seenPosts: Dictionary<String, AnyObject>) -> String? {
        var ids: String!
        var index = 0
        
        //filter out seenPosts
        for (key, _ ) in seenPosts {
            
            if key == "_id" {
                continue
            }
            else {
                ids = index > 0 ? "\(ids) and (_id != \(key))" : "(_id != \(key))"
            }
            index += 1
        }
        
        //filter out user matches
        for (_, value) in LocalUser.user.matches {

            ids = ids == nil ? "(_id != \(value))" : "\(ids) and (_id != \(value)"
            
        }
        
        //filter out user's ads
        for (key, _) in LocalUser.user.ads {
            ids = ids == nil ? "(_id != \(key))" : "\(ids) and (_id != \(key))"
        }
        
        //filter by category
        if GlobalItems.currentCategory != nil {
            ids = ids == nil ? GlobalItems.currentCategory : "\(ids) and (\(GlobalItems.currentCategory))"
        }
        
        return ids
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


