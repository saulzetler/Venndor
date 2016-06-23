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
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var postsButton: UIButton!
    var soldButton: UIButton!
    var postsBar: UIView!
    var soldBar: UIView!
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl! = UIPageControl()
    var pageNum: Int!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addImages()
        addHeader()
        addGestureRecognizer()
        setupButtons()
    }
    
    func setupButtons() {
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
        let matchContainer = UIView(frame: CGRect(x: 0, y: screenSize.height*0.17, width: screenSize.width, height: screenSize.height*0.4))
        createImgView(CGRect(x: screenSize.width*0.05, y: 5, width: screenSize.width*0.3, height: screenSize.width*0.3), action: "none:", superView: matchContainer)
        let priceContainer = UIView(frame: CGRect(x: screenSize.width*0.27, y: -8, width: screenSize.width*0.12, height: screenSize.width*0.08))
        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        createBoarder(priceContainer)
        matchContainer.addSubview(priceContainer)
        containerView.addSubview(matchContainer)
    }
    
    func matchesPressed(sender: UIButton) {
        print("matches pressed")
        toggleView(true)
    }
    
    func boughtPressed(sender: UIButton) {
        print("bought pressed")
        toggleView(false)
    }
    
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
        pageControl.currentPage = 0
        containerView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight*3)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }
    
    func toggleView(toPosts: Bool) {
        if toPosts {
            postsButton.selected = true
            soldButton.selected = false
            soldBar.backgroundColor = UIColor.whiteColor()
            postsBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        }
        else {
            soldButton.selected = true
            postsButton.selected = false
            postsBar.backgroundColor = UIColor.whiteColor()
            soldBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        }
    }
    
    func none(sender: UIButton) {
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
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