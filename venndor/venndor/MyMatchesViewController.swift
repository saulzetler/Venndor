//
//  MyMatchesViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class MyMatchesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "My Matches"
        self.view.addSubview(label)
        
        addHeader()
        sideMenuGestureSetup()
    }
    
}