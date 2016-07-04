//
//  MyPostsViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class MyPostsViewController: UIViewController, UIScrollViewDelegate {
    
    //declare sceensize for furture references
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //declare the variables for the 2 types of views on this page
    var postsButton: UIButton!
    var soldButton: UIButton!
    var postsBar: UIView!
    var soldBar: UIView!
    
    //declare variables for the scroll view
    var scrollView: UIScrollView!
    var postsContainerView = UIView()
    var soldContainerView = UIView()
    var onPosts: Bool!
    
    //set up the page accordingly
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addImages()
        addHeader()
        addGestureRecognizer()
        setupButtons()
    }
    
    func setupButtons() {
        //setting up the buttons needed to control the 2 pages within the controller, NEEDS REFACTORING WITH MATCHES
        let buttonBar = UIView(frame: CGRect(x: 0, y: 64, width: screenSize.width, height: 35))
        postsBar = UIView(frame: CGRect(x: 0, y: 32, width: screenSize.width/2, height: 3))
        soldBar = UIView(frame: CGRect(x: screenSize.width/2, y: 32, width: screenSize.width/2, height: 3))
        let postsButtonFrame = CGRectMake(0, 0, screenSize.width/2, 32)
        let soldButtonFrame = CGRectMake(screenSize.width/2, 0, screenSize.width/2, 32)
        buttonBar.backgroundColor = UIColor.whiteColor()
        postsButton = makeTextButton("Posts", frame: postsButtonFrame, target: "matchesPressed:")
        soldButton = makeTextButton("Sold", frame: soldButtonFrame, target: "boughtPressed:")
        postsButton.selected = true
        postsBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        buttonBar.addSubview(postsBar)
        buttonBar.addSubview(soldBar)
        buttonBar.addSubview(postsButton)
        buttonBar.addSubview(soldButton)
        self.view.addSubview(buttonBar)
    }
    
    func addImages() {
        //temporary function that is to be later changed
        //function used to add the item images to the price container.
        let matchContainer = UIView(frame: CGRect(x: 0, y: screenSize.height*0.17, width: screenSize.width, height: screenSize.height*0.4))
        createImgView(CGRect(x: screenSize.width*0.05, y: 5, width: screenSize.width*0.3, height: screenSize.width*0.3), action: "none:", superView: matchContainer)
        let priceContainer = UIView(frame: CGRect(x: screenSize.width*0.27, y: -8, width: screenSize.width*0.12, height: screenSize.width*0.08))
        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        createBoarder(priceContainer)
        matchContainer.addSubview(priceContainer)
        postsContainerView.addSubview(matchContainer)
    }
    
    //function to control when the matches category is pressed
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
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
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
        postsContainerView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight*3)
        onPosts = true
        scrollView.addSubview(postsContainerView)
        self.view.addSubview(scrollView)
    }
    
    //function to control the switching between the 2 possible views given a passed boolean.
    func toggleView(toPosts: Bool) {
        if toPosts {
            //check if the user is on the bought page
            if onPosts == false {
                postsButton.selected = true
                soldButton.selected = false
                soldBar.backgroundColor = UIColor.whiteColor()
                postsBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
                //add the correct subview and remove the previous
                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE
                soldContainerView.removeFromSuperview()
                scrollView.addSubview(postsContainerView)
                onPosts = true
            }
        }
        else {
            //check if the user is on the post page
            if onPosts == true {
                soldButton.selected = true
                postsButton.selected = false
                postsBar.backgroundColor = UIColor.whiteColor()
                soldBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
                //add the correct subview and remove the previous
                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE maybe not TO BE DETERMIENRIDESD
                postsContainerView.removeFromSuperview()
                scrollView.addSubview(soldContainerView)
                onPosts = false
            }
        }
    }
    
    func none(sender: UIButton) {
        
    }
    
    //control for the gesture to allow swipingleft and right for the menu
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            //switch case to distinguish the direction of swiping
            switch swipeGesture.direction {
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