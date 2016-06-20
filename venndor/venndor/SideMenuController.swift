//
//  SideMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-09.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class SideMenuController: UITableViewController {
    
    
    @IBOutlet weak var profileCell: UITableViewCell!
    
    @IBOutlet weak var browseCell: UITableViewCell!
    
    @IBOutlet weak var myMatchesCell: UITableViewCell!
    
    @IBOutlet weak var myPostsCell: UITableViewCell!
    
    @IBOutlet weak var notificationsCell: UITableViewCell!
    
    @IBOutlet weak var settingsCell: UITableViewCell!
    
    @IBOutlet weak var sellCell: UITableViewCell!
    
    var profilePic: UIImageView! = UIImageView(frame: CGRectMake(55, 20, 150, 150))
    
    var browseButton: UIButton!
    var myMatchesButton: UIButton!
    var myPostsButton: UIButton!
    var notificationsButton: UIButton!
    var settingsButton: UIButton!
    
    var browseIconButton: UIButton!
    var myMatchesIconButton: UIButton!
    var myPostsIconButton: UIButton!
    var notificationsIconButton: UIButton!
    var settingsIconButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profilePic.layer.borderWidth = 2.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.blackColor().CGColor
        profilePic.layer.cornerRadius = (profilePic.frame.size.width)/2
        profilePic.clipsToBounds = true
        profileCell.selectionStyle = .None
        profileCell.addSubview(profilePic)
        
        setupButtons()
    
    }
    
    func setupButtons() {
        let imageButtonSize = CGRect(x: 10, y: 0, width: 45, height: 45)
        let textButtonSize = CGRect(x: 55, y: 0, width: 200, height: 50)
        
//        browseButton
//        myMatchesButton
//        myPostsButton
//        notifacationsButton
//        settingsButton
        
        // text buttons
        
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
        
        // image buttons
        
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
    
        func sellPage() {
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