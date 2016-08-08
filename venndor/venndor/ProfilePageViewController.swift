//
//  ProfilePageViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-04.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    var user: User!
    
//    let user = LocalUser.user

    var profilePicView: UIImageView!
    var nameLabel: UILabel!
    var rating: UILabel!
    var numMatches: UILabel!
    var numBought: UILabel!
    var numSold: UILabel!
    var amtSaved: UILabel!
    var contentScroll: UIScrollView!
    var matchesButton: UIButton!
    var boughtButton: UIButton!
    var soldButton: UIButton!
    

    
    var sessionStart: NSDate!
    var headerView: HeaderView!
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "ProfilePageViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Viewed Personal Profile"
        sessionStart = NSDate()
    
        dispatch_async(dispatch_get_main_queue()) {
            //add profile picture
            self.setupProfilePhoto()
            self.setupNameLabel()
            self.setupButtons()
            
//            //set up the side menu
//            self.setSideMenu()
//            
//            //set the labels
//            self.setLabels()
//            
            //add the header
            self.addHeaderOther("Your Profile")
//
//            //default content scroll
//            self.updateScrollview(self.user.matches)

        }
    }
    
    func setupProfilePhoto() {
        
        //setup profile picture frame
        let frame = CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.15, width: 150, height: 150)
        profilePicView = UIImageView(frame: frame)
        
        //setup profile image
        let link = NSURL(string: user.profilePictureURL)
        let pictureData = NSData(contentsOfURL: link!)
        profilePicView.image = UIImage(data: pictureData!)
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width/2
        profilePicView.clipsToBounds = true
        self.view.addSubview(profilePicView)
        
    }
    
    func setupNameLabel() {
        //setup the name label frame
        let frame = CGRect(x: self.view.frame.width / 2 - 125, y: self.view.frame.height * 0.37, width: 250, height: 125)
        nameLabel = UILabel(frame: frame)
        
        //setup the label
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 20)
        self.view.addSubview(nameLabel)
    }
    
    func setupButtons() {
        let buttonDimension = self.view.frame.width * 0.2
        
        for index in 0...2 {
            
            //set up each button's frame
            let xOrigin = index == 0 ? self.view.frame.width * 0.11 : self.view.frame.width * 0.11 + CGFloat(30 * index) + CGFloat(buttonDimension) * CGFloat(index)
            let yOrigin = self.view.frame.height * 0.55
            let frame = CGRect(x: xOrigin, y: yOrigin, width: buttonDimension, height: buttonDimension)
            
            let button = UIButton(frame: frame)
            button.titleLabel!.font = UIFont(name: "Avenir-Medium", size: 20)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.layer.cornerRadius = button.frame.size.width / 2
            button.backgroundColor = UIColorFromHex(0x1abc9c)
            button.clipsToBounds = true
            
            switch index {
            case 0:
                matchesButton = button
                matchesButton.setTitle("\(LocalUser.matches.count)", forState: .Normal)

            case 1:
                boughtButton = button
                boughtButton.setTitle("\(LocalUser.user.nuItemsBought)", forState: .Normal)
                
            case 2:
                soldButton = button
                soldButton.setTitle("\(LocalUser.user.nuItemsSold)", forState: .Normal)
            default:
                print("Error creating button on profile view: hit default clause for whatever reason.")
            }
            
            self.view.addSubview(button)
        }
    }
    
    func setSideMenu() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    
    func toggleContent(sender: UIButton) {
        var content: [String:AnyObject]!
        
        switch sender {
        case matchesButton:
            content = user.matches
        case boughtButton:
            content = user.boughtItems
        case soldButton:
            content = user.soldItems
        default:
            print("Idk why the fuck you're getting this here error, bruh, but lets set a default...")
            content = user.matches
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.updateScrollview(content)
        })
        
    }

    func updateScrollview(content: [String:AnyObject]) {
        self.contentScroll.subviews.forEach({ $0.removeFromSuperview() })
        let scalar:Double = 8/19
        let contentViewDimension = self.contentScroll.frame.width * CGFloat(scalar)
        let contentScrollWidth = CGFloat(content.count) * (contentViewDimension + CGFloat(8)) - CGFloat(8)
        
        for index in 0..<content.count {
            
            //create the frame for each content view, incrementing the x origin by which contentView it is (place in queue)
            let xOrigin = index == 0 ? 0 : CGFloat(index) * contentViewDimension + ( CGFloat(8) * CGFloat(index))
            
            //let xOrigin: CGFloat = CGFloat(index) * contentViewDimension + CGFloat(8)
            let frame = CGRectMake(xOrigin, 10, contentViewDimension, contentViewDimension)
            let contentView = UIView(frame: frame)
            contentView.backgroundColor = UIColor.redColor()
            self.contentScroll.addSubview(contentView)
            
        }
        
        contentScroll.contentSize = CGSizeMake(contentScrollWidth, contentScroll.frame.height)
    }
    
    

}

