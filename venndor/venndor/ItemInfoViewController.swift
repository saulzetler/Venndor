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
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.77
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
   // var itemView: UnDraggableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered ItemInfo Page."
        let infoView = createItemInfoView(item)
        self.view.addSubview(infoView)

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

}
