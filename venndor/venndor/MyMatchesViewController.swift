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
        
        let manager = MatchesManager()
        
        //set up prelimenary variables to make for-loop more readable
        var index:CGFloat = 0.0
        let yOrigin = screenSize.height * 0.17
        let containerHeight = screenSize.height * 0.2
        
        
        //populate the matchContainerView
        for match in LocalUser.matches {
            
            //create the match container view
            let matchContainer = UIView(frame: CGRect(x: 0, y: yOrigin + (index * containerHeight), width: screenSize.width, height: containerHeight))
            
            //retrieve the match thumbnail
            manager.retrieveMatchThumbnail(match) { img, error in
                guard error == nil else {
                    print("Error retrieving match images: \(error)")
                    return
                }
                if let img = img {
                    //self.addContainerContent(matchContainer, img: img, match: match)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.addContainerContent(matchContainer, img: img, match: match)
                    }
                    
                }
            }
            
            matchContainerView.addSubview(matchContainer)
            index += 1
        }
        
        setupScrollView()
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
    

    func addContainerContent(matchContainer: UIView, img: UIImage, match: Match) {
        
        //create the match photo
        let imgView = createImgView(CGRect(x: screenSize.width*0.05, y: 5, width: screenSize.width*0.3, height: screenSize.width*0.3), action: "none:", superView: matchContainer)
        imgView.image = img
        
        let imgHeight = imgView.frame.height
        let imgWidth = imgView.frame.width
        
        
        let labelX = imgWidth + imgView.frame.origin.x + 20
        
        //create the match info labels
        let nameLabel = UILabel(frame: CGRect(x: labelX, y: 5, width: matchContainer.frame.width - imgWidth, height: imgHeight * 0.15))
        nameLabel.text = match.itemID
        nameLabel.textAlignment = .Center
        matchContainer.addSubview(nameLabel)
        
        let distanceLabel = UILabel(frame: CGRect(x: labelX, y: matchContainer.frame.height * 0.35, width: matchContainer.frame.width - imgWidth, height: imgHeight * 0.15))
        distanceLabel.text = "495 Hilldale Road"
        distanceLabel.textAlignment = .Center
        matchContainer.addSubview(distanceLabel)
        
        let sellerLabel = UILabel(frame: CGRect(x: labelX, y: matchContainer.frame.height * 0.7, width: matchContainer.frame.width - imgWidth, height: imgHeight * 0.15))
        sellerLabel.text = "\(match.sellerID)"
        sellerLabel.textAlignment = .Center
        matchContainer.addSubview(sellerLabel)
        
        
        
        //create the price container + label
        let priceContainer = UIView(frame: CGRect(x: screenSize.width*0.27, y: -8, width: screenSize.width*0.12, height: screenSize.width*0.08))
        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
       
        let priceLabel = UILabel(frame: CGRect(x: 2, y: 2, width: priceContainer.frame.width - 5, height: priceContainer.frame.height))
        priceLabel.text = "$\(match.matchedPrice)"
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        priceContainer.addSubview(priceLabel)
        
        createBoarder(priceContainer)
        matchContainer.addSubview(priceContainer)
        
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