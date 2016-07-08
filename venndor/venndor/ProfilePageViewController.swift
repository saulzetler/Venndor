//
//  ProfilePageViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-04.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    let user = LocalUser.user

    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var numMatches: UILabel!
    @IBOutlet weak var numBought: UILabel!
    @IBOutlet weak var numSold: UILabel!
    @IBOutlet weak var amtSaved: UILabel!
    @IBOutlet weak var contentScroll: UIScrollView!
    @IBOutlet weak var matchesStack: UIStackView!
    @IBOutlet weak var boughtStack: UIStackView!
    @IBOutlet weak var soldStack: UIStackView!
    @IBOutlet weak var savedStack: UIStackView!
    
    var headerView: HeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the side menu
        setSideMenu()
        
        //set the labels
        setLabels()
        
        //add the header
        headerView = HeaderView(frame: self.view.frame)
        self.view.addSubview(headerView)
        
        //default content scroll
        dispatch_async(dispatch_get_main_queue(), {
            self.updateScrollview(LocalUser.user.matches)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //assign a tap gesture recognizer to each stackview
        setTapsForStackViews()
        
        //present the header view and add the sidemenu toggles to it
        self.view.bringSubviewToFront(headerView)
        headerView.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.categoryButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        

    }
    
    func setTapsForStackViews() {
        let stackViews = [matchesStack, boughtStack, soldStack]
        for stack in stackViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(ProfilePageViewController.toggleContent(_:)))
            stack.addGestureRecognizer(tap)
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
    func setLabels() {
        nameLabel.text = "\(LocalUser.firstName) \(LocalUser.lastName)"
        numMatches.text = "\(LocalUser.user.matches.count)"
        numBought.text = "\(LocalUser.user.boughtItems.count)"
        numSold.text = "\(LocalUser.user.soldItems.count)"
    }
    
    func toggleContent(sender: UITapGestureRecognizer) {
        var content: [String:AnyObject]!
        
        _ = LocalUser.user
        switch sender.view! {
        case matchesStack:
            print("Matches tapped!")
            content = LocalUser.user.matches
        case boughtStack:
            print("Bought tapped!")
            content = LocalUser.user.boughtItems
        case soldStack:
            print("Sold tapped!")
            content = LocalUser.user.soldItems
        default:
            print("Idk why the fuck you're getting this here error, bruh, but lets set a default...")
            content = LocalUser.user.matches
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

