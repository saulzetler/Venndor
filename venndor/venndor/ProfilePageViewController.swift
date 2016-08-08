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
    var matchesButton: UIView!
    var boughtButton: UIStackView!
    var soldButton: UIStackView!
    

    
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
        
        //add profile picture
        let link = NSURL(string: user.profilePictureURL)
        let pictureData = NSData(contentsOfURL: link!)
        profilePicView.image = UIImage(data: pictureData!)
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width/2
        profilePicView.clipsToBounds = true
        
        //set up the side menu
        setSideMenu()
        
        //set the labels
        setLabels()
        
        //add the header
        addHeaderOther("Your Profile")
        
        //default content scroll
        dispatch_async(dispatch_get_main_queue(), {
            self.updateScrollview(self.user.matches)
        })
    }
    
    
    func setSideMenu() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    func setLabels() {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        numMatches.text = "\(user.matches.count)"
        numBought.text = "\(user.boughtItems.count)"
        numSold.text = "\(user.soldItems.count)"
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

