//
//  MiniMyMatchesViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class MiniMyMatchesViewController: UIViewController {
    
    var miniMatches: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        //MiniMyMatches button at bottom of browse.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let miniMatchesImage = UIImage(named: "ic_menu_white.png");
        miniMatches = UIButton(type: UIButtonType.Custom) as UIButton
        miniMatches.frame = CGRectMake(screenSize.width*0.435, screenSize.height*0.91, screenSize.width*0.13, screenSize.width*0.13)
        miniMatches.layer.cornerRadius = 0.5 * miniMatches.bounds.size.width
        miniMatches.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        miniMatches.setImage(miniMatchesImage, forState: .Normal)
        miniMatches.tag = 1
        self.view.addSubview(miniMatches)
        miniMatches.addTarget(self, action: "goBack:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func goBack (sender: UIButton) {
        self.performSegueWithIdentifier("ExitMiniMatch", sender: self)
    }
}