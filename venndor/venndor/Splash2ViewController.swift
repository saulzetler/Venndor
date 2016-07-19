//
//  SplashViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-20.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

//splash view controller to allow for data to be loaded before displaying browse
class Splash2ViewController: UIViewController {
    
    //perform during load to allow for a shorter splash screen/early call.
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let background = UIImage(named: "background.jpg")
        let backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        backgroundView.image = background
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.performSegueWithIdentifier("showBrowse", sender: self)
    }
    
}


