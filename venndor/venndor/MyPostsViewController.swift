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
//    var postsButton: UIButton!
//    var soldButton: UIButton!
//    var postsBar: UIView!
//    var soldBar: UIView!
    
    //declare variables for the scroll view
    var scrollView: UIScrollView!
    var postsContainerView = UIView()
    var soldContainerView = UIView()
    var onPosts: Bool!
    var sessionStart: NSDate!
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "MyPostsViewController")
    }

    //set up the page accordingly
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalUser.user.mostRecentAction = "Browsed MyPosts"
        sessionStart = NSDate()
    
        
        let manager = ItemManager()
        
        //set up prelimenary variables to make for-loop more readable
        var index:CGFloat = 0.0
        let yOrigin = screenSize.height * 0.12
        let containerHeight = screenSize.height * 0.27
        
        
        //populate the postContainerView
        for (post, _) in LocalUser.user.ads {
            
            //create the match container view
            let postContainer = UIView(frame: CGRect(x: 0, y: yOrigin + (index * containerHeight), width: screenSize.width, height: containerHeight))
            
            //pull the item info
            manager.retrieveItemById(post) { item, error in
                guard error == nil else {
                    print("Error retrieving item for myPosts: \(error)")
                    return
                }
                
                if let item = item {
                    
                    //pull item images
                    manager.retrieveItemImageById(item.id, imageIndex: 0) { img, error in
                        guard error == nil else {
                            print("Error retrieving image for myPosts: \(error)")
                            return
                        }
                        if let img = img {
                            item.photos = [img]
                            
                            //set postContainer view with retrieved data
                            dispatch_async(dispatch_get_main_queue()) {
                                self.addContainerContent(postContainer, item: item)
                            }
                            
                        }
                    }
                    
                }
            }
            
            postsContainerView.addSubview(postContainer)
            index += 1
        }
        
        setupScrollView()
        addHeaderItems("Your Posts")
//        addGestureRecognizer()
//        setupButtons()
    }
    
    func addContainerContent(postContainer: UIView, item: Item) {
        //create the match photo
        let imgHeight = screenSize.width*0.4
        let imgWidth = screenSize.width*0.4
        let imgView = createImgView(CGRect(x: postContainer.frame.width - imgWidth + 5, y: 0, width: screenSize.width*0.4, height: screenSize.width*0.4), action: #selector(MyMatchesViewController.none(_:)), superView: postContainer)
        imgView.image = item.photos![0]
        
        
        
        let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 5+imgHeight * 0.20, width: postContainer.frame.width - imgWidth - 5, height: imgHeight * 0.30))
        print("Succesfully set the LocalUser's matches")
        descriptionLabel.text = item.details
        descriptionLabel.font = UIFont(name: "Avenir", size: 14)
        descriptionLabel.textColor = self.UIColorFromHex(0x808080)
        descriptionLabel.numberOfLines = 2

        
        let blueLine = UIView(frame: CGRectMake(15, screenSize.height * 0.245, postContainer.frame.width-30, 1))
        blueLine.backgroundColor = UIColorFromHex(0x2c3e50)
        postContainer.addSubview(blueLine)
        
        //create the match info labels
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 5, width: postContainer.frame.width - imgWidth - 20, height: imgHeight * 0.15))
        nameLabel.text = item.name
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont(name: "Avenir", size: 16)
        //        nameLabel.textAlignment = .Center
        postContainer.addSubview(nameLabel)
        
        
        //        descriptionLabel.textAlignment = .Center
        postContainer.addSubview(descriptionLabel)

        let priceLabel = UILabel(frame: CGRect(x: 10, y: screenSize.width*0.27, width: postContainer.frame.width - imgWidth - 20, height: screenSize.width*0.15))
        let temp = Int(item.minPrice)
        priceLabel.text = "$\(temp)"
        priceLabel.textAlignment = .Center
        priceLabel.font = UIFont(name: "Avenir", size: 22)
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        postContainer.addSubview(priceLabel)
    }
//    
//    //function to control when the matches category is pressed
//    func matchesPressed(sender: UIButton) {
//        print("matches pressed")
//        //calls a function to adjust the page correctly
//        toggleView(true)
//    }
//    //function to control when the bought category is pressed
//    func boughtPressed(sender: UIButton) {
//        print("bought pressed")
//        //calls a function to adjust the page correctly
//        toggleView(false)
//    }
    
    //gesture recognizer function to allow functionality of swipping left or right to control which menu to look at
//    func addGestureRecognizer() {
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyPostsViewController.respondToSwipeGesture(_:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        self.view.addGestureRecognizer(swipeRight)
//        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MyPostsViewController.respondToSwipeGesture(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        self.view.addGestureRecognizer(swipeLeft)
//    }
    
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
//    func toggleView(toPosts: Bool) {
//        if toPosts {
//            //check if the user is on the bought page
//            if onPosts == false {
//                postsButton.selected = true
//                soldButton.selected = false
//                soldBar.backgroundColor = UIColor.whiteColor()
//                postsBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
//                //add the correct subview and remove the previous
//                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE
//                soldContainerView.removeFromSuperview()
//                scrollView.addSubview(postsContainerView)
//                onPosts = true
//            }
//        }
//        else {
//            //check if the user is on the post page
//            if onPosts == true {
//                soldButton.selected = true
//                postsButton.selected = false
//                postsBar.backgroundColor = UIColor.whiteColor()
//                soldBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
//                //add the correct subview and remove the previous
//                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE maybe not TO BE DETERMIENRIDESD
//                postsContainerView.removeFromSuperview()
//                scrollView.addSubview(soldContainerView)
//                onPosts = false
//            }
//        }
//    }
    
    func none(sender: AnyObject) {
        
    }
    
//    //control for the gesture to allow swipingleft and right for the menu
//    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            //switch case to distinguish the direction of swiping
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizerDirection.Right:
//                print("Swiped right")
//                toggleView(true)
//            case UISwipeGestureRecognizerDirection.Left:
//                print("Swiped left")
//                toggleView(false)
//            default:
//                break
//            }
//        }
//    }
    
}