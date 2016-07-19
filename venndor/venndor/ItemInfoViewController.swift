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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered ItemInfo Page."

        TimeManager.timeStamp = NSDate()
    
        
        let item = self.item
        print("WHO KNOWS?!!?!")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let interval = TimeManager.globalManager.getSessionDuration(TimeManager.timeStamp)
        LocalUser.user.timePerController["ItemInfoViewController"] += interval
    }
}
