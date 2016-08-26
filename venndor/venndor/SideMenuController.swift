//
//  SideMenuController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-09.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class SideMenuController: UIViewController {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    //declare the various buttons
    var browseButton: UIButton!
    var myMatchesButton: UIButton!
    var myPostsButton: UIButton!
    var settingsButton: UIButton!
    var sellButton: UIButton!
    var myPostsCount: UILabel!
    var myMatchesCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = (UIColorFromHex(0x2c3e50))
        //create and load the users profile picture
        let profilePic: UIImageView! = UIImageView(frame: CGRectMake(screenSize.width*0.16, screenSize.height*0.06, screenSize.width*0.27, screenSize.width*0.27))
        let link = NSURL(string: LocalUser.profilePictureURL)
        let pictureData = NSData(contentsOfURL: link!)
        
        profilePic.image = UIImage(data: pictureData!)
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = (profilePic.frame.size.width)/2
        profilePic.clipsToBounds = true
        profilePic.contentMode = .ScaleAspectFill
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SideMenuController.profilePictureTapped))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(SideMenuController.profilePictureTapped))
        
        profilePic.userInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        let profileName: UILabel = UILabel(frame: CGRectMake(0, screenSize.height*0.21, screenSize.width*0.6, screenSize.height*0.07))
        profileName.textAlignment = .Center
        profileName.text = LocalUser.firstName + " " + LocalUser.lastName
        profileName.textColor = UIColor.whiteColor()
        profileName.font = UIFont(name: "Avenir", size: 16)
        profileName.addGestureRecognizer(tapGestureRecognizer2)
        profileName.userInteractionEnabled = true
        self.view.addSubview(profilePic)
        self.view.addSubview(profileName)
        
        let whiteLine = UIView(frame: CGRectMake(0, screenSize.height*0.28, screenSize.width, 1))
        whiteLine.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(whiteLine)
        
        
        setupButtons()
        sellButton = makeTextButton("SELL", frame: CGRect(x: screenSize.width*0.03, y: screenSize.height*0.8, width: screenSize.width*0.54, height: screenSize.height*0.18), target: #selector(SideMenuController.sellPage(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: false, backgroundColor: UIColorFromHex(0x1abc9c
, alpha: 1))
        sellButton.titleLabel?.font = UIFont(name: "Avenir", size: 42)
        sellButton.layer.cornerRadius = 10
        self.view.addSubview(sellButton)
            //2c3e50
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        sellButton.selected = false
        browseButton.selected = false
        myMatchesButton.selected = false
        myPostsButton.selected = false
//        settingsButton.titleLabel?.textColor = UIColor.whiteColor()
        if LocalUser.CurrentPage == "Browse" {
            browseButton.selected = true
        } else if LocalUser.CurrentPage == "My Matches" {
            myMatchesButton.selected = true
        } else if LocalUser.CurrentPage == "My Posts" {
            myPostsButton.selected = true
        } else if LocalUser.CurrentPage == "Settings" {
            settingsButton.selected = true
        }
//        else if LocalUser.CurrentPage == "Posts" {
//            sellButton.titleLabel?.textColor = UIColorFromHex(0x008dce)
//        }
    }
    func setupButtons() {
        //create the buttons
        browseButton = makeTextButton("BROWSE", frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.33, width: screenSize.width*0.4, height: screenSize.height*0.06), target: #selector(SideMenuController.browsePage(_:)))
        self.view.addSubview(browseButton)
        browseButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        browseButton.titleLabel?.textAlignment = .Center
        browseButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        
        myMatchesButton = makeTextButton("MY MATCHES", frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.45, width: screenSize.width*0.4, height: screenSize.height*0.06), target: #selector(SideMenuController.myMatchesPage(_:)))
        self.view.addSubview(myMatchesButton)
        myMatchesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myMatchesButton.titleLabel?.textAlignment = .Center
        myMatchesButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        if LocalUser.matches.count > 0 {
            myMatchesCount = UILabel(frame: CGRect(x: screenSize.width*0.5, y: screenSize.height*0.45, width: screenSize.width*0.1, height: screenSize.height*0.06))
            myMatchesCount.text = "(\(LocalUser.matches.count))"
            myMatchesCount.font = UIFont(name: "Avenir", size: 18)
            myMatchesCount.textColor = UIColor.redColor()
            myMatchesCount.textAlignment = .Center
            self.view.addSubview(myMatchesCount)
        }
        
        myPostsButton = makeTextButton("MY POSTS", frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.57, width: screenSize.width*0.4, height: screenSize.height*0.06), target: #selector(SideMenuController.myPostsPage(_:)))
        myPostsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myPostsButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        myPostsButton.titleLabel?.textAlignment = .Center
        self.view.addSubview(myPostsButton)
        
        if LocalUser.posts.count > 0 {
            myPostsCount = UILabel(frame: CGRect(x: screenSize.width*0.46, y: screenSize.height*0.57, width: screenSize.width*0.1, height: screenSize.height*0.06))
            myPostsCount.text = "(\(LocalUser.posts.count))"
            myPostsCount.textAlignment = .Center
            myPostsCount.font = UIFont(name: "Avenir", size: 18)
            myPostsCount.textColor = UIColor.redColor()
            self.view.addSubview(myPostsCount)
        }
        
        settingsButton = makeTextButton("SETTINGS", frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.69, width: screenSize.width*0.4, height: screenSize.height*0.06), target: #selector(SideMenuController.settingsPage(_:)))
        self.view.addSubview(settingsButton)
        settingsButton.titleLabel?.textAlignment = .Center
        settingsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        settingsButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
    }
    
    
    //various functions to perform the buttons segues
    
    //add check facebook login token anf if none log them in.
    
    func sellPage(sender: UIButton) {
        self.performSegueWithIdentifier("toSellPage", sender: self)
    }
    
    func settingsPage(sender: UIButton) {
        self.performSegueWithIdentifier("toSettings", sender: self)
    }
    
    func myPostsPage(sender: UIButton) {
        self.performSegueWithIdentifier("toMyPosts", sender: self)
    }
    
    func myMatchesPage(sender: UIButton) {
        self.performSegueWithIdentifier("toMyMatches", sender: self)
    }
    
    func browsePage(sender: UIButton) {
        self.performSegueWithIdentifier("toBrowse", sender: self)
    }
    
    func profilePictureTapped() {
        self.performSegueWithIdentifier("showProfile", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfile" {
            let ovc = segue.destinationViewController as! ProfilePageViewController
            ovc.user = LocalUser.user
        }
    }
    
}