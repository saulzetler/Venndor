//
//  PopUpViewControllerSwift.swift
//  NMPopUpView
//
//  Created by Nikos Maounis on 13/9/14.
//  Copyright (c) 2014 Nikos Maounis. All rights reserved.
//

import UIKit
import QuartzCore

class PopUpViewControllerSwift : UIViewController {
    
    var screenSize = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    func setupBackground() {
        self.view.frame = screenSize
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        let backgroundImage = UIImage(named: "match background.png")
        let backgroundImageView = UIImageView(frame: screenSize)
        backgroundImageView.image = backgroundImage
        self.view.addSubview(backgroundImageView)
    }
    
    func showInView(aView: UIView!, price: Double, item: Item)
    {
        let message = UILabel(frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.2, width: screenSize.width*0.8, height: screenSize.height*0.2))
        message.text = "You Matched!"
        self.view.addSubview(message)
        message.textColor = UIColor.whiteColor()
        message.textAlignment = .Center
        message.font = message.font.fontWithSize(40)
        let matchPrice = UILabel(frame: CGRect(x: screenSize.width*0.1, y: screenSize.height*0.33, width: screenSize.width*0.8, height: screenSize.height*0.2))
        matchPrice.textColor = UIColor.whiteColor()
        matchPrice.textAlignment = .Center
        matchPrice.font = message.font.fontWithSize(60)
        matchPrice.text = "$\(price)"
        self.view.addSubview(matchPrice)
        let widthFactor: CGFloat = 0.033
        let promptFrame = CGRectMake(screenSize.width*widthFactor, screenSize.height*0.55, screenSize.width*(1-2*widthFactor), screenSize.height*0.15)
        setupPrompt(item.name, item: item, screenSize: screenSize, frame: promptFrame)
        
        aView.addSubview(self.view)
        self.showAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func closePopup(sender: AnyObject) {
        self.removeAnimate()
    }
}
