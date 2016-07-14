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
        
        super.viewDidLoad()
        
        let manager = ItemManager()
        
        //set up prelimenary variables to make for-loop more readable
        var index:CGFloat = 0.0
        let yOrigin = screenSize.height * 0.17 + 20
        let containerHeight = screenSize.height * 0.2
        
        
        //populate the matchContainerView
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
        addHeaderItems()
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
        postsButton = makeTextButton("Posts", frame: postsButtonFrame, target: #selector(MyPostsViewController.matchesPressed(_:)))
        soldButton = makeTextButton("Sold", frame: soldButtonFrame, target: #selector(MyPostsViewController.boughtPressed(_:)))
        postsButton.selected = true
        postsBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        buttonBar.addSubview(postsBar)
        buttonBar.addSubview(soldBar)
        buttonBar.addSubview(postsButton)
        buttonBar.addSubview(soldButton)
        self.view.addSubview(buttonBar)
        self.view.bringSubviewToFront(buttonBar)
    }
    
    func addContainerContent(postContainer: UIView, item: Item) {
        //temporary function that is to be later changed
        //function used to add the item images to the price container.
        
        //setup the image view and assign some variables around its dimensions
        let imgView = createImgView(CGRect(x: screenSize.width*0.05, y: 5, width: screenSize.width*0.3, height: screenSize.width*0.3), action: #selector(MyPostsViewController.none(_:)), superView: postContainer)
        imgView.image = item.photos![0]
        let imgHeight = imgView.frame.height
        let imgWidth = imgView.frame.width
        let labelX = imgWidth + imgView.frame.origin.x + 20
        
        //create the match info labels
        let nameLabel = UILabel(frame: CGRect(x: labelX, y: 5, width: postContainer.frame.width - imgWidth, height: imgHeight * 0.15))
        nameLabel.text = item.name
        nameLabel.textAlignment = .Center
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        postContainer.addSubview(nameLabel)
        
        let distanceLabel = UILabel(frame: CGRect(x: labelX, y: postContainer.frame.height * 0.35, width: postContainer.frame.width - imgWidth, height: imgHeight * 0.15))
        distanceLabel.text = "495 Hilldale Road"
        distanceLabel.textAlignment = .Center
        distanceLabel.numberOfLines = 1
        distanceLabel.adjustsFontSizeToFitWidth = true
        postContainer.addSubview(distanceLabel)
        
//        let sellerLabel = UILabel(frame: CGRect(x: labelX, y: matchContainer.frame.height * 0.7, width: matchContainer.frame.width - imgWidth, height: imgHeight * 0.15))
//        sellerLabel.text = "\(match.sellerName)"
//        sellerLabel.textAlignment = .Center
//        postContainer.addSubview(sellerLabel)
        
        
        
        //create the price container + label
        let priceContainer = UIView(frame: CGRect(x: screenSize.width*0.27, y: -8, width: screenSize.width*0.12, height: screenSize.width*0.08))
        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        
        let priceLabel = UILabel(frame: CGRect(x: 2, y: 2, width: priceContainer.frame.width - 5, height: priceContainer.frame.height))
        priceLabel.text = "$\(item.minPrice)"
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        priceContainer.addSubview(priceLabel)
        
        postContainer.addSubview(priceContainer)
        postsContainerView.addSubview(postContainer)
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
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyPostsViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MyPostsViewController.respondToSwipeGesture(_:)))
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