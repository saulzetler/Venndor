//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    //declare the current category so we know what cards we need to filter
    var currentCategory: String!
    
    //variabls to help declare and set things
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var miniMatches: UIButton!
    var menuTransitionManager = MenuTransitionManager()
    let fadeOut = UIView()
    var headerView: HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the header
        headerView = HeaderView(frame: self.view.frame)
        
        //intialize the global items in this controller
//        let globalItems = GlobalItems()
        
        /* ADD FUNCTION ON WHEN SWIPPING TO ROTATE THE GLOBAL ITEM */
        
        // Do any additional setup after loading the view, typically from a nib.	
//        let user = LocalUser.user
//        let items = GlobalItems.items
        
        self.view.backgroundColor = UIColorFromHex(0xe6f2ff, alpha: 1)
        
        //MiniMyMatches button at bottom of browse.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonSize = CGRect(x: screenSize.width*0.435, y: screenSize.height*0.91, width: screenSize.width*0.13, height: screenSize.width*0.13)
        miniMatches = makeImageButton("ic_menu_white.png", frame: buttonSize, target: "showAlert:", tinted: false, circle: true, backgroundColor: 0x3498db, backgroundAlpha: 1)
        //end minimatches decleration, could use refactoring instead of ugly code
        
        
        
        //prepare the reveal view controller to allow swipping and side menus.
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        //add the headerview
        self.view.addSubview(headerView)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //create the item slides using draggableviewbackground
        
        /* THIS CODE NEEDS REFACTORING, WE NEED TO CREATE AND ALTER THE CARDS IN BROWSE VIEW CONTROLLER NOT THE VIEW*/
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        if currentCategory == nil {
            let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
            self.view.addSubview(draggableBackground)
            draggableBackground.insertSubview(backgroundImage, atIndex: 0)
        }
        else {
            let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame, category: currentCategory)
            self.view.addSubview(draggableBackground)
            draggableBackground.insertSubview(backgroundImage, atIndex: 0)
        }
        
        /* THIS CODE NEEDS REFACTORING, WE NEED TO CREATE AND ALTER THE CARDS IN BROWSE VIEW CONTROLLER NOT THE VIEW*/

        //add mini matches to view after background to stop covering it
        self.view.addSubview(miniMatches)
        
        //brings the header view to front as the draggable background covers it
        self.view.bringSubviewToFront(headerView)
        
        headerView.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        headerView.categoryButton.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //code to for when the user swipes right to make an offer
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "toOfferScreen") {
//            let ovc = segue.destinationViewController as! OfferViewController
//        }
//    }
    
//    func showOfferView(){
//        let offerView = OfferView(frame: CGRectMake(0, 0, 0, 0))
//        bringUpNewView(offerView)
//    }
    
    
    //function to bring up mini matches bottom menu
    func showAlert(sender: UIButton) {
        
        //create the controller for the bottom menu
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // create the custom view for the bottom menu
        let rect = CGRectMake(-10, 0, alertController.view.bounds.size.width, 165.0)
        let customView = UIView(frame: rect)
        let customViewTwo = UIView(frame: CGRect(x: -10, y: 125, width: alertController.view.bounds.size.width+10, height: 75))
        customViewTwo.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)

        //create the custom cancel view for the user to quit the menu
        //note this function also cancels when a user presses outside the frame
        let arrowView = UIView(frame: CGRect(x: (alertController.view.bounds.size.width)/2-23, y: 145, width: 30, height: 30))
        arrowView.backgroundColor = UIColor(patternImage: UIImage(named: "ic_keyboard_arrow_down_white.png")!)

        customView.backgroundColor = UIColorFromHex(0xe6e6e6)
        //round the corners to look more appealing
        customView.layer.cornerRadius = 15

        alertController.view.addSubview(customView)
        alertController.view.addSubview(customViewTwo)
        alertController.view.addSubview(arrowView)
        
        //declare the type of alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
        
    }
}

