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
    
    var contentScroll: UIScrollView!
    
    var matchesLabel: UILabel!
    var boughtLabel: UILabel!
    var soldLabel: UILabel!
    
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
        
        self.view.backgroundColor = UIColorFromHex(0x34495e)
    
        dispatch_async(dispatch_get_main_queue()) {
            //add profile picture
            self.setupProfilePhoto()
            self.setupNameLabel()
            self.setupButtons()
            
            //set up the side menu
            self.setupSideMenu()
//            
            //add the header
            self.addHeaderOther("Your Profile")
//
            //default content scroll
            self.setupScrollView()
            self.updateScrollview("matches")

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
        nameLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(nameLabel)
    }
    
    func setupButtons() {
        let buttonDimension = self.view.frame.width * 0.2
        
        for index in 0...2 {
            
            //set up each button's frame
            let buttonX = index == 0 ? self.view.frame.width * 0.11 : self.view.frame.width * 0.11 + CGFloat(30 * index) + CGFloat(buttonDimension) * CGFloat(index)
            let buttonY = self.view.frame.height * 0.55
            let buttonFrame = CGRect(x: buttonX, y: buttonY, width: buttonDimension, height: buttonDimension)
            let button = createProfileButton(buttonFrame)
            button.addTarget(self, action: #selector(ProfilePageViewController.toggleContent(_:)), forControlEvents: .TouchUpInside)
            
            //set up each label's frame
            let labelX = buttonX
            let labelY = buttonY + button.frame.height + 10
            let labelFrame = CGRect(x: labelX, y: labelY, width: buttonDimension, height: self.view.frame.height * 0.03)
            let label = createButtonLabel(labelFrame)
            
            
            switch index {
            case 0:
                matchesButton = button
                matchesButton.setTitle("\(LocalUser.matches.count)", forState: .Normal)
                matchesLabel = label
                matchesLabel.text = "MATCHES"
                

            case 1:
                boughtButton = button
                boughtButton.setTitle("\(LocalUser.user.nuItemsBought)", forState: .Normal)
                boughtLabel = label
                boughtLabel.text = "BOUGHT"
                
            case 2:
                soldButton = button
                soldButton.setTitle("\(LocalUser.user.nuItemsSold)", forState: .Normal)
                soldLabel = label
                soldLabel.text = "SOLD"
                
            default:
                print("Error creating button on profile view: hit default clause for whatever reason.")
            }
            
            self.view.addSubview(button)
            self.view.addSubview(label)
        }
    }
    
    func createProfileButton(frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.titleLabel!.font = UIFont(name: "Avenir-Medium", size: 20)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = button.frame.size.width / 2
        button.backgroundColor = UIColorFromHex(0x1abc9c)
        button.clipsToBounds = true
        return button
    }
    
    func createButtonLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = UIFont(name: "Avenir-Medium", size: 10)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        return label
    }
    
    func setupSideMenu() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if revealViewController() != nil {
            revealViewController().rightViewController = nil
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func setupScrollView() {
        let contentY = self.matchesLabel.frame.origin.y + self.matchesLabel.frame.height + 15
        contentScroll = UIScrollView(frame: CGRect(x: 5, y: contentY, width: self.view.frame.width - 10, height: self.view.frame.height * 0.25))
        self.view.addSubview(contentScroll)
    }
    
    func toggleContent(sender: UIButton) {
        var content: String!
        
        switch sender {
        case matchesButton:
            content = "matches"
        case boughtButton:
            content = "bought"
        case soldButton:
            content = "sold"
        default:
            print("Idk why the fuck you're getting this here error, bruh, but lets set a default...")
            content = "matches"
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.updateScrollview(content)
        })
        
    }

    func updateScrollview(contentType: String) {
        //remove the previous contentScroll slides
        self.contentScroll.subviews.forEach({ $0.removeFromSuperview() })
        var content: [AnyObject]!
        
        switch contentType {
        case "bought":
            content = LocalUser.matches.filter({ $0.bought == 1 })
        case "sold":
            content = LocalUser.posts.filter({ $0.sold == 1 })
        default:
            content = LocalUser.matches.filter({ $0.bought == 0 })
        }
        
        
        let scalar:Double = 8/19
        let contentViewDimension = self.contentScroll.frame.width * CGFloat(scalar)
        let contentScrollWidth = CGFloat(content.count) * (contentViewDimension + CGFloat(16)) - CGFloat(16)
        
        
        for index in 0..<content.count {
            
            let xOrigin = index == 0 ? 12 : CGFloat(index) * contentViewDimension + ( CGFloat(16) * CGFloat(index)) + 16
            
            let frame = CGRectMake(xOrigin, 8, contentViewDimension, contentViewDimension)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let contentView = ItemContainer(frame: frame)
                
                if contentType == "sold" {
                    contentView.post = content[index] as! Post
                    let tap = UITapGestureRecognizer(target: MyPostsViewController.self, action: #selector(ProfilePageViewController.togglePostItemInfo(_:)))
                    contentView.addGestureRecognizer(tap)
                
                } else {
                    contentView.match = content[index] as! Match
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ProfilePageViewController.toggleMatchItemInfo(_:)))
                    contentView.addGestureRecognizer(tap)
                }
                
                self.setContentView(contentView)
                self.contentScroll.addSubview(contentView)
            }
        }
        
        contentScroll.contentSize = CGSizeMake(contentScrollWidth, contentScroll.frame.height)
    }
    
    func setContentView(contentView: ItemContainer) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        imgView.image = contentView.post == nil ? contentView.match.thumbnail : contentView.post.thumbnail
        imgView.layer.cornerRadius = 5
        imgView.layer.masksToBounds = true
        imgView.contentMode = .ScaleAspectFill
        
        let price: Int!
        
        //add the price label
        if let post = contentView.post {
            price = post.sold == 1 ? post.soldPrice : post.minPrice
        } else {
            price = contentView.match.matchedPrice
        }
        
        let priceLabel = VennPriceLabel(containerView: contentView, price: price, adjustment: -7)
        
        contentView.addSubview(imgView)
        contentView.addSubview(priceLabel)
    }
}

