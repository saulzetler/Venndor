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
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var matchesButton: UIButton!
    var boughtButton: UIButton!
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl! = UIPageControl()
    var pageNum: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /*
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "My Matches"
        self.view.addSubview(label)
        */
        
        setupScrollView()
        addImages()
        addHeader()
        sideMenuGestureSetup()
        setupButtons()
        
    } 
    
    func setupButtons() {
        let buttonBar = UIView(frame: CGRect(x: 0, y: 64, width: screenSize.width, height: 32))
        let matchesButtonFrame = CGRectMake(0, 0, screenSize.width/2, 32)
        let boughtButtonFrame = CGRectMake(screenSize.width/2, 0, screenSize.width/2, 32)
        buttonBar.backgroundColor = UIColor.lightGrayColor()
        matchesButton = makeTextButton("Matches", frame: matchesButtonFrame, target: "matchesPressed:")
        boughtButton = makeTextButton("Bought", frame: boughtButtonFrame, target: "boughtPressed:")
        buttonBar.addSubview(matchesButton)
        buttonBar.addSubview(boughtButton)
        self.view.addSubview(buttonBar)
    }
    
    func addImages() {
        createImgView(CGRect(x: screenSize.width*0.1, y: screenSize.height*0.5, width: screenSize.width*0.3, height: screenSize.width*0.3), action: "none:", superView: containerView)
    }
    
    func matchesPressed(sender: UIButton) {
        print("matches pressed")
        matchesButton.selected = true
        boughtButton.selected = false
    }
    
    func boughtPressed(sender: UIButton) {
        print("bought pressed")
        boughtButton.selected = true
        matchesButton.selected = false
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
    
    func none(sender: UIButton) {
        
    }
    
}