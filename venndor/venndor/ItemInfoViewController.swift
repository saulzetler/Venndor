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
    var sessionStart: NSDate!
    
    //view attributes
    var header: UIView!
    var backButton: UIButton!
    var buyButton: UIButton!
    
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.77
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered ItemInfo Page."
        
        //setup the item info card
        let itemInfoView = createItemInfoView(item)
        self.view.addSubview(itemInfoView)
        
        setupHeaderFrame()
        setupHeaderLogo()
        setupBackButton()
        setupBuyButton()
        
        self.view.backgroundColor = UIColorFromHex(0xecf0f1)
        sessionStart = NSDate()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "ItemInfoViewController")
    }
    
    func createItemInfoView(item: Item) -> ItemInfoView {
        let frame = CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)
        let infoView = ItemInfoView(frame: frame, item: item, myLocation: LocalUser.myLocation)
        infoView.layer.cornerRadius = 20
        infoView.layer.masksToBounds = true
        return infoView
    }
    
    func setupHeaderFrame() {
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.height*0.1)
        self.header = UIView(frame: frame)
        self.header.backgroundColor = UIColorFromHex(0x1abc9c, alpha: 1)
        self.view.addSubview(header)
    }
    
    func setupHeaderLogo() {
        let logoView = UIView(frame: CGRectMake(screenSize.width*0.25, 24, screenSize.width*0.5, 30))
        logoView.backgroundColor = UIColor.redColor()
        self.header.addSubview(logoView)
    }
    
    func setupBackButton() {
        
        let backImage = UIImage(named: "Back-50.png")

        backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = CGRectMake(20, 27, screenSize.width*0.1, 20)
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
        self.view.addSubview(buyButton)
    }
    
    
    func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
