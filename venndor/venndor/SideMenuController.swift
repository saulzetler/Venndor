//
//  SideMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-09.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import FBSDKLoginKit


//class to control the side menu which should be available in most pages.
class SideMenuController: UITableViewController {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //declare all the outlets or the buttons
    @IBOutlet weak var profileCell: UITableViewCell!
    
    @IBOutlet weak var browseCell: UITableViewCell!
    
    @IBOutlet weak var myMatchesCell: UITableViewCell!
    
    @IBOutlet weak var myPostsCell: UITableViewCell!
    
    @IBOutlet weak var notificationsCell: UITableViewCell!
    
    @IBOutlet weak var settingsCell: UITableViewCell!
    
    @IBOutlet weak var sellCell: UITableViewCell!
    
    //declare the various buttons
    var postButton: UIButton!
    var browseButton: UIButton!
    var myMatchesButton: UIButton!
    var myPostsButton: UIButton!
    var notificationsButton: UIButton!
    var settingsButton: UIButton!
    //and their icons
    var browseIconButton: UIButton!
    var myMatchesIconButton: UIButton!
    var myPostsIconButton: UIButton!
    var notificationsIconButton: UIButton!
    var settingsIconButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create and load the users profile picture
        let profilePic: UIImageView! = UIImageView(frame: CGRectMake(screenSize.width*0.05, screenSize.height*0.02, screenSize.width*0.4, screenSize.width*0.4))
        
        /*NEEDS REFACTORING*/
        
        profilePic.layer.borderWidth = 2.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.blackColor().CGColor
        profilePic.layer.cornerRadius = (profilePic.frame.size.width)/2
        profilePic.clipsToBounds = true
        profileCell.selectionStyle = .None
        profileCell.addSubview(profilePic)
        
        //create a tap gesture recognizer and assign it to the profile picture view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "profilePictureTapped")
        profilePic.userInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        
        //setupCells()
        //setup calls for the page
        setupButtons()
    
    }
    
    func profilePictureTapped() {
        self.performSegueWithIdentifier("showProfile", sender: self)
    }
    
    
    
    func setupButtons() {
        
        //declare various size variables for the buttons to reference allowing for cleaner code.
        let imageButtonSize = CGRect(x: screenSize.width*0.04, y: screenSize.height*0.01, width: screenSize.width*0.1, height: screenSize.width*0.1)
        let textButtonSize = CGRect(x: screenSize.width*0.2, y: screenSize.height*0.01, width: screenSize.width*0.4, height: screenSize.width*0.1)
        let postButtonSize = CGRect(x: 0, y: 0, width: screenSize.width*0.6, height: screenSize.width*0.3)
        
        // create all the buttons themselves
        
        browseButton = makeTextButton("Browse", frame: textButtonSize, target: "browsePage:")
        browseCell.addSubview(browseButton)
        
        myMatchesButton = makeTextButton("My Matches", frame: textButtonSize, target: "myMatchesPage:")
        myMatchesCell.addSubview(myMatchesButton)
        
        myPostsButton = makeTextButton("My Posts", frame: textButtonSize, target: "myPostsPage:")
        myPostsCell.addSubview(myPostsButton)
        
        notificationsButton = makeTextButton("Notifications", frame: textButtonSize, target: "notificationsPage:")
        notificationsCell.addSubview(notificationsButton)
        
        settingsButton = makeTextButton("Settings", frame: textButtonSize, target: "settingsPage:")
        settingsCell.addSubview(settingsButton)
        
        postButton = makeTextButton("Sell", frame: postButtonSize, target: "sellPage:")
        postButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        postButton.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        sellCell.addSubview(postButton)
        
        
        
        // create all the button icons/images
        
        browseIconButton = makeImageButton("Home-50", frame: imageButtonSize, target: "browsePage:", tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        browseCell.addSubview(browseIconButton)
        
        myMatchesIconButton = makeImageButton("Shopping Cart Loaded-50", frame: imageButtonSize, target: "myMatchesPage:", tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        myMatchesCell.addSubview(myMatchesIconButton)
        
        myPostsIconButton = makeImageButton("New Product-50", frame: imageButtonSize, target: "myPostsPage:", tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        myPostsCell.addSubview(myPostsIconButton)
        
        notificationsIconButton = makeImageButton("Megaphone-50", frame: imageButtonSize, target: "notificationsPage:", tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        notificationsCell.addSubview(notificationsIconButton)
        
        settingsIconButton = makeImageButton("Settings-50", frame: imageButtonSize, target: "settingsPage:", tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        settingsCell.addSubview(settingsIconButton)
        
    }
    

    //various functions to perform the buttons segues

    func sellPage(sender: UIButton) {
        self.performSegueWithIdentifier("toSellPage", sender: self)
    }
    
    func settingsPage(sender: UIButton) {
        self.performSegueWithIdentifier("toSettings", sender: self)
    }
    
    func notificationsPage(sender: UIButton) {
        self.performSegueWithIdentifier("toNotifications", sender: self)
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
    
}