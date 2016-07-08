//
//  MyMatchesViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class MyMatchesViewController: UIViewController, UIScrollViewDelegate {
    //declaring screen size for future reference
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    //declaring the buttons needed for the 2 views
    var matchesButton: UIButton!
    var boughtButton: UIButton!
    var matchesBar: UIView!
    var boughtBar: UIView!
    //variables needed for the scroll view
    var scrollView: UIScrollView!
    var matchContainerView = UIView()
    var boughtContainerView = UIView()
    var onMatches: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addImages()
        addHeader()
        addGestureRecognizer()
        setupButtons()
    } 
    
    func setupButtons() {
        //setting up the buttons needed to control the 2 pages within the controller, NEEDS REFACTORING WITH POST
        let buttonBar = UIView(frame: CGRect(x: 0, y: 64, width: screenSize.width, height: 35))
        matchesBar = UIView(frame: CGRect(x: 0, y: 32, width: screenSize.width/2, height: 3))
        boughtBar = UIView(frame: CGRect(x: screenSize.width/2, y: 32, width: screenSize.width/2, height: 3))
        let matchesButtonFrame = CGRectMake(0, 0, screenSize.width/2, 32)
        let boughtButtonFrame = CGRectMake(screenSize.width/2, 0, screenSize.width/2, 32)
        buttonBar.backgroundColor = UIColor.whiteColor()
        matchesButton = makeTextButton("Matches", frame: matchesButtonFrame, target: #selector(MyMatchesViewController.matchesPressed(_:)))
        boughtButton = makeTextButton("Bought", frame: boughtButtonFrame, target: #selector(MyMatchesViewController.boughtPressed(_:)))
        matchesButton.selected = true
        matchesBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        buttonBar.addSubview(matchesBar)
        buttonBar.addSubview(boughtBar)
        buttonBar.addSubview(matchesButton)
        buttonBar.addSubview(boughtButton)
        self.view.addSubview(buttonBar)
    }
    
    func addImages() {
        //temporary function that is to be later changed
        //function used to add the item images to the price container.
        let matchContainer = UIView(frame: CGRect(x: 0, y: screenSize.height*0.17, width: screenSize.width, height: screenSize.height*0.4))
        createImgView(CGRect(x: screenSize.width*0.05, y: 5, width: screenSize.width*0.3, height: screenSize.width*0.3), action: #selector(MyMatchesViewController.none(_:)), superView: matchContainer)
        let priceContainer = UIView(frame: CGRect(x: screenSize.width*0.27, y: -8, width: screenSize.width*0.12, height: screenSize.width*0.08))
        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        createBoarder(priceContainer)
        matchContainer.addSubview(priceContainer)
        matchContainerView.addSubview(matchContainer)
    }
    
    //function to control when the bought category is pressed
    func matchesPressed(sender: UIButton) {
        print("matches pressed")
        //calls a function to adjust the page correctly
        toggleView(true)
    }
    
    //function to control when the bought category is pressed
    func boughtPressed(sender: UIButton) {
        print("bought pressed")
        //calls a function to adjust the page correctly
        toggleView(false)
    }
    
    //gesture recognizer function to allow functionality of swipping left or right to control which menu to look at
    func addGestureRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyMatchesViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MyMatchesViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    //hard coded for now but we can change to size scroll view based on number of matches
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let scrollViewWidth: CGFloat = scrollView.frame.width
        let scrollViewHeight: CGFloat = scrollView.frame.height
        scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*3)
        scrollView.decelerationRate = 0.1
        matchContainerView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight*3)
        onMatches = true
        scrollView.addSubview(matchContainerView)
        view.addSubview(scrollView)
    }
    
    //function to control the switching between the 2 possible views given a passed boolean.
    func toggleView(toMatches: Bool) {
        if toMatches {
            //check if the user is on the bought page
            if onMatches == false {
                matchesButton.selected = true
                boughtButton.selected = false
                boughtBar.backgroundColor = UIColor.whiteColor()
                matchesBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
                //add the correct subview and remove the previous
                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE maybe not TO BE DETERMIENRIDESD
                boughtContainerView.removeFromSuperview()
                scrollView.addSubview(matchContainerView)
                onMatches = true
            }
        }
        else {
            //check if the user is on the match page
            if onMatches == true {
                boughtButton.selected = true
                matchesButton.selected = false
                matchesBar.backgroundColor = UIColor.whiteColor()
                boughtBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
                //add the correct subview and remove the previous
                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE maybe not TO BE DETERMIENRIDESD
                matchContainerView.removeFromSuperview()
                scrollView.addSubview(boughtContainerView)
                onMatches = false
            }
        }
    }
    
    func none(sender: UIButton) {
        
    }
    
    //control for the gesture to allow swipingleft and right for the menu
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            //switch case to distinguish the direction of swiping
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
                toggleView(true)
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                toggleView(false)
            default:
                break
            }
        }
    }
    
}