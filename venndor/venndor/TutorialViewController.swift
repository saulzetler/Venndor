//
//  TutorialViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

//view controller for the tutorial which a user is directed to after login screen if the user didnt already exist
class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    let screenSize = UIScreen.mainScreen().bounds
    
    //decalre the outlets for the scroll view
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl!
    var startButton: UIButton!
    var curPage: Int = 0
    var viewsRemoved: Bool = false
    
    //the button action when the user gets to the end of the tutorial and needs to be directed to the actual app
    func goToBrowse(sender: UIButton) {
        self.performSegueWithIdentifier("goBrowse", sender: self)
    }
    
    func nextPage(sender: UIButton) {
        curPage += 1
        goToPage(curPage)
        if curPage == 3 {
            removeViews()
        }
        else if viewsRemoved {
            bringThemBack()
        }
        
    }
    
    func goToPage(page: Int) {
        let xOffset = CGPointMake(screenSize.width*CGFloat(page), 0);
        self.scrollView.setContentOffset(xOffset, animated: true)
        self.pageControl.currentPage = page
    }
    
    func removeViews() {
        for view in self.view.subviews {
            if view.tag == 10 {
                view.removeFromSuperview()
            }
        }
        viewsRemoved = true
    }
    
    func bringThemBack() {
        setupNextButtons()
        setupSkipButtons()
        viewsRemoved = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Went through the Tutorial"
        
        setupScrollView()
        setupPageControl()
        setupButton()
        setupSkipButtons()
        setupNextButtons()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupScrollView() {
        //first create the scroll view frame specifcations
        let scrollViewFrame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        scrollView = UIScrollView(frame: scrollViewFrame)
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        self.view.addSubview(scrollView)
        
        //third set the image for each pages background, 1 for page 1 and etc.
        let imgOne = UIImageView(frame: CGRectMake(0, 0,scrollViewWidth, scrollViewHeight))
        imgOne.image = UIImage(named: "Step1.png")
        let imgTwo = UIImageView(frame: CGRectMake(scrollViewWidth, 0,scrollViewWidth, scrollViewHeight))
        imgTwo.image = UIImage(named: "Step2.png")
        let imgThree = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0,scrollViewWidth, scrollViewHeight))
        imgThree.image = UIImage(named: "Step3.png")
        let imgFour = UIImageView(frame: CGRectMake(scrollViewWidth*3, 0,scrollViewWidth, scrollViewHeight))
        imgFour.image = UIImage(named: "Step4.png")
        
        //add the images to the view
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        
        //lastly declare the correct size of the scroll views content and other variables
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.decelerationRate = 0.1
        self.scrollView.delaysContentTouches = true
        self.scrollView.delegate = self
        
        containerView.frame = CGRectMake(0, 0, screenSize.width*4, screenSize.height)
        
    }
    
    func setupPageControl() {
        //setup page control
        let pageControlFrame = CGRect(x: screenSize.width*0.4, y: screenSize.height*0.75, width: screenSize.width*0.2, height: screenSize.height*0.05)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.tintColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.view.addSubview(pageControl)
        self.view.bringSubviewToFront(pageControl)
        self.pageControl.currentPage = 0
        curPage = 0
    }
    
    func setupButton() {
        let buttonFrame = CGRect(x: screenSize.width*3.2, y: screenSize.height*0.83, width: screenSize.width*0.6, height: screenSize.height*0.1)
        startButton = makeTextButton("GET STARTED!", frame: buttonFrame, target: #selector(TutorialViewController.goToBrowse(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: true, backgroundColor: UIColorFromHex(0x16a085), textSize: 18)
        startButton.layer.cornerRadius = 10
        startButton.layer.masksToBounds = true
        startButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        scrollView.addSubview(startButton)
    }
    
    func setupSkipButtons() {
        let skipFrame = CGRect(x: screenSize.width*0.8, y: screenSize.height*0.05, width: screenSize.width*0.15, height: screenSize.height*0.1)
        let skipButton = makeTextButton("Skip", frame: skipFrame, target: #selector(TutorialViewController.goToBrowse(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: true, backgroundColor: UIColor.clearColor(), textSize: 18)
        skipButton.tag = 10
        self.view.addSubview(skipButton)
    }
    
    func setupNextButtons() {
        let nextFrame = CGRect(x: screenSize.width*0.45, y: screenSize.height*0.83, width: screenSize.width*0.1, height: screenSize.height*0.1)
        let nextButton = makeImageButton("Right-50.png", frame: nextFrame, target: #selector(TutorialViewController.nextPage(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        nextButton.tag = 10
        nextButton.imageView?.contentMode = .Center
        self.view.addSubview(nextButton)
    }
    
    //2 functions are called when a user uses a scroll view, thus both functions need to call another to help adjust the page and set the contents of the page correctly.
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        pageAdjust()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pageAdjust()
    }
    
    //function to appropriately manage the page handling
    func pageAdjust() {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        curPage = Int(currentPage)
        //check which current page it is supposed to be and then correctly adjust the content to fit the correct page.
        for x in 0...3 {
            if x == Int(currentPage) {
                let xOffset = CGPointMake(pageWidth*CGFloat(x), 0);
                self.scrollView.setContentOffset(xOffset, animated: true)
            }
        }
        if curPage == 3 {
            removeViews()
        }
        else if viewsRemoved {
            bringThemBack()
        }
    }
}