//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var miniMatches: UIButton!
    var menuTransitionManager = MenuTransitionManager()
    let fadeOut = UIView()
    var headerView: HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let globalItems = GlobalItems()
        
        globalItems.loadNextItem()
        // Do any additional setup after loading the view, typically from a nib.	
//        let user = LocalUser.user
//        let items = GlobalItems.items
        
 
//        let manager = ImageManager()
//        manager.pullImageFromServer("57699883e0e4a810b963dfa7")
        /*
        let image = UIImage(named: "arthas.jpg")
        if let img = image {
            manager.saveImagetoServer(img)
        }
        */
        


        
        self.view.backgroundColor = UIColorFromHex(0xe6f2ff, alpha: 1)
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
        draggableBackground.insertSubview(backgroundImage, atIndex: 0)
        
        
        //add the header
        headerView = HeaderView(frame: self.view.frame)

        
        //MiniMyMatches button at bottom of browse.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonSize = CGRect(x: screenSize.width*0.435, y: screenSize.height*0.91, width: screenSize.width*0.13, height: screenSize.width*0.13)
        miniMatches = makeImageButton("ic_menu_white.png", frame: buttonSize, target: "showAlert:", tinted: false, circle: true, backgroundColor: 0x3498db, backgroundAlpha: 1)
        self.view.addSubview(miniMatches)
        

        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)

    }
    override func viewDidAppear(animated: Bool) {
        
        let subViews = self.view.subviews
        for subView in subViews {
            if subView == fadeOut {
                subView.removeFromSuperview()
            }
            else if subView == miniMatches {
                subView.hidden = false
            }
        }
        headerView.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        headerView.categoryButton.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlert(sender: UIButton) {
        
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let rect = CGRectMake(-10, 0, alertController.view.bounds.size.width, 165.0)
        let customView = UIView(frame: rect)
        let customViewTwo = UIView(frame: CGRect(x: -10, y: 125, width: alertController.view.bounds.size.width+10, height: 75))
        customViewTwo.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)

        let arrowView = UIView(frame: CGRect(x: (alertController.view.bounds.size.width)/2-23, y: 145, width: 30, height: 30))
        arrowView.backgroundColor = UIColor(patternImage: UIImage(named: "ic_keyboard_arrow_down_white.png")!)

        customView.backgroundColor = UIColorFromHex(0xe6e6e6)
        
        customView.layer.cornerRadius = 15

        alertController.view.addSubview(customView)
        alertController.view.addSubview(customViewTwo)
        alertController.view.addSubview(arrowView)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
        
    }
}

