//
//  TestViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class TestViewController: UIViewController {
    var menuTransitionManager = MenuTransitionManager()
    let fadeOut = UIView()
    
    override func viewDidAppear(animated: Bool) {
        let subViews = self.view.subviews
        for subView in subViews {
            if subView == fadeOut {
                subView.removeFromSuperview()
            }
        }
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let MiniMatchViewController = segue.destinationViewController as! MiniMyMatchesViewController
        fadeOut.frame = self.view.frame
        fadeOut.backgroundColor = UIColorFromHex(0xFFFFFF, alpha: 0.6)
        view.addSubview(fadeOut)
        MiniMatchViewController.transitioningDelegate = self.menuTransitionManager
    }

}