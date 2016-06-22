//
//  ViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-07.
//  Copyright © 2016 Venndor. All rights reserved.
//

extension UIViewController {
    
    func makeImageButton(imageName: String, frame: CGRect, target: Selector, tinted: Bool, circle: Bool, backgroundColor: UInt32, backgroundAlpha: Double) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: target, forControlEvents: UIControlEvents.TouchUpInside)
        if imageName != "" {
            let buttonImage = UIImage(named: imageName)
            button.setImage(buttonImage, forState: .Normal)
            if tinted == true {
                let tintedButton = buttonImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                button.setImage(tintedButton, forState: .Selected)
            }
        }
        if circle == true {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
        if backgroundAlpha != 0 {
            button.backgroundColor = UIColorFromHex(backgroundColor, alpha: backgroundAlpha)
        }
        return button
    }
    
    func makeTextButton(text: String, frame: CGRect, target: Selector) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: target, forControlEvents: .TouchUpInside)
        button.setTitle(text, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColorFromHex(0x3498db, alpha: 1), forState: UIControlState.Selected)
        return button
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func addHeader() {
        let headerView: HeaderView = HeaderView(frame: self.view.frame)
        headerView.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.categoryButton.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
    }
    
    func sideMenuGestureSetup() {
        if revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //generic scroll view functions
    func createBoarder(view: UIView) {
        let boarderColor : UIColor = UIColor.blackColor()
        view.layer.borderColor = boarderColor.CGColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
    func createImgView(frame: CGRect, action: Selector, superView: UIView) -> UIImageView {
        let imgView = UIImageView(frame: frame)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        imgView.userInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        createBoarder(imgView)
        superView.addSubview(imgView)
        return imgView
    }
    
}

class ViewController: UIViewController {

    
    
}

