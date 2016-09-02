//
//  ItemInfoViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-13.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class ItemInfoViewController: UIViewController {
    
    var item: Item!
    var match: Match!
    var post: Post!
    var sessionStart: NSDate!
    
    //view attributes
    var header: UIView!
    var headerTitle: String! 
    var backButton: UIButton!
    var buyButton: UIButton!
    var messageButton: UIButton!
    var editButton: UIButton!
    
    var isPost: Bool!
    
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.77
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    let messageComposer = TextMessageComposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered ItemInfo Page."
        
        loadViews()
        
        self.view.backgroundColor = UIColorFromHex(0xecf0f1)
        sessionStart = NSDate()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        dispatch_async(dispatch_get_main_queue()) {
//            self.view.subviews.forEach({ $0.removeFromSuperview() })
//            self.loadViews()
//        }
//        
//    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "ItemInfoViewController")
    }
    
    func loadViews() {
        //setup the item info card
        let itemInfoView = createItemInfoView(item)
        self.view.addSubview(itemInfoView)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.setupHeaderFrame()
            self.setupHeaderTitle()
            self.setupBackButton()
            
            if self.isPost == true {
                self.setupEditButton()
            }
            else {
                if self.match.bought == 1 {
                    self.setupMessageButton()
                } else {
                    self.setupBuyButton()
                }
                self.setupVennLabel()
            }
            
        }
        
        self.view.backgroundColor = UIColorFromHex(0xecf0f1)

        
    }
    
    func createItemInfoView(item: Item) -> ItemInfoView {
        let frame = CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)
        let infoView = ItemInfoView(frame: frame, item: item)
        infoView.layer.cornerRadius = 20
        infoView.layer.masksToBounds = true
        
        
        return infoView
    }
    
    func setupVennLabel() {
        
        let frameX = self.view.frame.size.width * 0.71
        let frameY = (self.view.frame.size.height - CARD_HEIGHT)/2 - 12
        
        let vennFrame = CGRectMake(frameX, frameY, self.view.frame.size.width * 0.30, self.view.frame.size.height * 0.12)
        
        let vennView = VennPriceLabel(frame: vennFrame, price: self.match.matchedPrice)
        
        self.view.addSubview(vennView)
    }

        
    
    
    func setupHeaderFrame() {
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.height*0.1)
        self.header = UIView(frame: frame)
        self.header.backgroundColor = UIColorFromHex(0x1abc9c, alpha: 1)
        self.view.addSubview(header)
    }
    
    func setupHeaderTitle() {
        let logoView = UILabel(frame: CGRectMake(screenSize.width*0.11, 26, screenSize.width*0.8, 30))
        logoView.text = self.headerTitle
        logoView.textAlignment = .Center
        logoView.font = logoView.font.fontWithSize(20)
        logoView.textColor = UIColor.whiteColor()
        self.header.addSubview(logoView)
    }
    
    func setupBackButton() {
        
        let backImage = UIImage(named: "Back-50.png")

        backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = CGRectMake(screenSize.width*0, 31, screenSize.width*0.2, 20)
        backButton.setImage(backImage, forState: .Normal)
        backButton.imageView?.contentMode = UIViewContentMode.Center
        backButton.addTarget(self, action: #selector(ItemInfoViewController.dismissController(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.header.addSubview(backButton)
        self.header.bringSubviewToFront(backButton)
    }
    
    func setupBuyButton() {
        let buttonY = self.view.frame.size.height - self.header.frame.size.height
        let frame = CGRectMake(0, buttonY, self.header.frame.size.width, self.header.frame.size.height)
        buyButton = UIButton(frame: frame)
        buyButton.backgroundColor = UIColorFromHex(0x34495e)
        buyButton.setTitle("BUY", forState: UIControlState.Normal)
        buyButton.titleLabel?.textColor = UIColor.whiteColor()
        buyButton.addTarget(self, action: #selector(ItemInfoViewController.toggleBuy), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buyButton)
    }
    func setupMessageButton() {
        let buttonY = self.view.frame.size.height - self.header.frame.size.height
        let frame = CGRectMake(0, buttonY, self.header.frame.size.width, self.header.frame.size.height)
        messageButton = UIButton(frame: frame)
        messageButton.backgroundColor = UIColorFromHex(0x34495e)
        messageButton.setTitle("MESSAGE SELLER", forState: UIControlState.Normal)
        messageButton.titleLabel?.textColor = UIColor.whiteColor()
        messageButton.addTarget(self, action: #selector(ItemInfoViewController.messageSeller), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(messageButton)
    }
    
    func setupEditButton() {
        let buttonY = self.view.frame.size.height - self.header.frame.size.height
        let frame = CGRectMake(0, buttonY, self.header.frame.size.width, self.header.frame.size.height)
        editButton = UIButton(frame: frame)
        editButton.backgroundColor = UIColorFromHex(0x34495e)
        editButton.setTitle("EDIT", forState: UIControlState.Normal)
        editButton.titleLabel?.textColor = UIColor.whiteColor()
        editButton.addTarget(self, action: #selector(ItemInfoViewController.editTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(editButton)
    }
    
    func editTapped() {
        print("Edit Tapped")
        let editViewController = EditViewControllerTest()
        editViewController.item = self.item
        editViewController.post = self.post
        editViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        editViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(editViewController, animated: true, completion: nil)
    }
    
    
    func toggleBuy() {

        self.definesPresentationContext = true
        
        UserManager.globalManager.retrieveUserById(item.owner) { user, error in
            guard error == nil else {
                print("Error retrieving seller in Buy screen: \(error)")
                return
            }
            
            if let user = user {
                let bvc = BuyViewController()
                bvc.match = self.match
                bvc.seller = user
                bvc.item = self.item
                bvc.fromInfo = true
                bvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                bvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                self.presentViewController(bvc, animated: true, completion: nil)
            }
            else {
                print("Error with parsing user in buy screen. Returning now.")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    func messageSeller() {
        print("Message tapped!")
        
        if (messageComposer.canSendText()) {
            //set recipient
            
            UserManager.globalManager.retrieveUserById(item.owner, completionHandler: { user, error in
                guard error == nil else {
                    print("Error retrieving seller when messaging: \(error)")
                    return
                }
                
                if let user = user {
                    self.messageComposer.setRecipients([user.phoneNumber])
                }
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = self.messageComposer.configuredMessageComposeViewController("\(LocalUser.firstName) \(LocalUser.lastName) wants to buy your item \(self.match.itemName) for $\(self.match.matchedPrice)")
                
                self.presentViewController(messageComposeVC, animated: true, completion: nil)
                
            })
            
            
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
    func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func triggerSegue() {
        self.performSegueWithIdentifier("toSplash", sender: self)
    }
}
