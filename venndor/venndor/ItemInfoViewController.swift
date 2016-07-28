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
    var header: UIView!
    var sessionStart: NSDate!
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.77
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    let screenSize: CGRect = UIScreen.mainScreen().bounds
   // var itemView: UnDraggableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered ItemInfo Page."
        
        //setup the item info card
        let itemInfoView = createItemInfoView(item)
        self.view.addSubview(itemInfoView)
        
        //setup the header
        setupHeaderFrame()
        setupHeaderLogo()
        setupBackButton()
        
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
        let backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = CGRectMake(screenSize.width*0, 24, screenSize.width*0.2, 30)
        let backImage = UIImage(named: "Back-50.png")
        backButton.setImage(backImage, forState: .Normal)
        self.header.addSubview(backButton)
    }
    

}
