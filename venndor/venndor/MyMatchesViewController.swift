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
    var tappedItem: Item!
    var distSet: Bool!
    var distText: String!
    
    //declaring the buttons needed for the 2 views
//    var matchesButton: UIButton!
//    var boughtButton: UIButton!
//    var matchesBar: UIView!
//    var boughtBar: UIView!
    
    //variables needed for the scroll view
    var scrollView: UIScrollView!
    var matchContainerView = UIView()
    var boughtContainerView = UIView()
    var matchObjects = [Match]()
    var onMatches: Bool!
    var sessionStart: NSDate!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "MyMatchesViewController")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalUser.user.mostRecentAction = "Browsed MyMatches"
        sessionStart = NSDate()
        
        let manager = MatchesManager()
        
        //set up prelimenary variables to make for-loop more readable
        var index:CGFloat = 0.0
        let yOrigin = screenSize.height * 0.1
        let containerHeight = screenSize.height * 0.27
        let boughtTitle = CGFloat(40)
        
        setupScrollView(containerHeight + 10)
        
        let boughtLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height * 0.08, width: screenSize.width, height: boughtTitle))
        boughtLabel.text = "Bought Items"
        boughtLabel.backgroundColor = UIColorFromHex(0x2c3e50)
        boughtLabel.font = UIFont(name: "Avenir", size: 22)
        boughtLabel.textColor = UIColor.whiteColor()
        boughtLabel.textAlignment = .Center
        self.matchContainerView.addSubview(boughtLabel)
        distSet = false
        
        //populate the matchContainerView
        for match in LocalUser.matches {
            
            //create the match container view
            let matchContainer = ItemContainer(frame: CGRect(x: 0, y: yOrigin + (index * containerHeight) + boughtTitle, width: screenSize.width, height: containerHeight))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyMatchesViewController.toggleItemInfo(_:)))
            matchContainer.addGestureRecognizer(tap)
            
            //retrieve the match thumbnail
            manager.retrieveMatchThumbnail(match) { img, error in
                guard error == nil else {
                    print("Error retrieving match images: \(error)")
                    return
                }
                if let img = img {
                    match.thumbnail = img
                    matchContainer.match = match
                    //self.addContainerContent(matchContainer, img: img, match: match)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.addContainerContent(matchContainer, img: img, match: match)
                        self.distSet = false
                    }
                }
            }
            
            matchContainerView.addSubview(matchContainer)
            index += 1
        }
        
        //matchtitle to distinguis the shit fuck shit
        let matchTitle = CGFloat(40)
        let matchLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height * 0.09 + (index * containerHeight) + boughtTitle - screenSize.height*0.016, width: screenSize.width, height: matchTitle))
        matchLabel.text = "Match Items"
        matchLabel.backgroundColor = UIColorFromHex(0x2c3e50)
        matchLabel.font = UIFont(name: "Avenir", size: 22)
        matchLabel.textColor = UIColor.whiteColor()
        matchLabel.textAlignment = .Center
        self.matchContainerView.addSubview(matchLabel)
        
        //populate the matchContainerView
        for match in LocalUser.matches {
            
            //create the match container view
            let matchContainer = ItemContainer(frame: CGRect(x: 0, y: screenSize.height * 0.11 + (index * containerHeight) + matchTitle + boughtTitle-screenSize.height*0.018, width: screenSize.width, height: containerHeight))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyMatchesViewController.toggleItemInfo(_:)))
            matchContainer.addGestureRecognizer(tap)
            
            //retrieve the match thumbnail
            manager.retrieveMatchThumbnail(match) { img, error in
                guard error == nil else {
                    print("Error retrieving match images: \(error)")
                    return
                }
                if let img = img {
                    match.thumbnail = img
                    matchContainer.match = match
                    //self.addContainerContent(matchContainer, img: img, match: match)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.addContainerContent(matchContainer, img: img, match: match)
                        self.distSet = false
                    }
                }
            }
            
            matchContainerView.addSubview(matchContainer)
            index += 1
        }

        
        
        
        addHeaderItems("Your Matches")
//        addGestureRecognizer()
//        setupButtons()
        
    }
    func DropdownAction() {
        
    }
    
    func toggleItemInfo(sender: UITapGestureRecognizer) {
        print("Match tapped!")
        let containerView = sender.view as! ItemContainer
        let manager = ItemManager()
        manager.retrieveItemById(containerView.match.itemID) { item, error in
            guard error == nil else {
                print("error pulling item data from tapped match: \(error)")
                return
            }
            if let item = item {
                self.tappedItem = item
                dispatch_async(dispatch_get_main_queue()) {
                   self.performSegueWithIdentifier("showItemInfo", sender: self)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItemInfo" {
            let ivc = segue.destinationViewController as! ItemInfoViewController
            ivc.item = tappedItem
        }
    }
    
//    func setupButtons() {
//        //setting up the buttons needed to control the 2 pages within the controller, NEEDS REFACTORING WITH POST
//        let buttonBar = UIView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: 35))
//        buttonBar.backgroundColor = UIColor.whiteColor()
//        
//        matchesBar = UIView(frame: CGRect(x: 0, y: 32, width: screenSize.width/2, height: 3))
//        boughtBar = UIView(frame: CGRect(x: screenSize.width/2, y: 32, width: screenSize.width/2, height: 3))
//        
//        
//        //setup the buttons on the button bar
//        let boughtButtonFrame = CGRectMake(screenSize.width/2, 0, screenSize.width/2, 32)
//        boughtButton = makeTextButton("Bought", frame: boughtButtonFrame, target: #selector(MyMatchesViewController.boughtPressed(_:)))
//        
//        let matchesButtonFrame = CGRectMake(0, 0, screenSize.width/2, 32)
//        matchesButton = makeTextButton("Matches", frame: matchesButtonFrame, target: #selector(MyMatchesViewController.matchesPressed(_:)))
//        matchesButton.selected = true
//        matchesBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
//        
//        //set up the subviews for the bar and add it to the master view hierarchy
//        buttonBar.addSubview(matchesBar)
//        buttonBar.addSubview(boughtBar)
//        buttonBar.addSubview(matchesButton)
//        buttonBar.addSubview(boughtButton)
//        
//        self.view.addSubview(buttonBar)
//        self.view.bringSubviewToFront(buttonBar)
//    }
    

    func addContainerContent(matchContainer: UIView, img: UIImage, match: Match) {
        
        //create the match photo
        let imgView = createImgView(CGRect(x: 0, y: 0, width: screenSize.width*0.4, height: screenSize.width*0.4), action: #selector(MyMatchesViewController.none(_:)), superView: matchContainer)
        imgView.image = img
        
        let imgHeight = imgView.frame.height
        let imgWidth = imgView.frame.width
        
        let descriptionLabel = UILabel(frame: CGRect(x: imgWidth+10, y: 5+imgHeight * 0.15, width: matchContainer.frame.width - imgWidth - 5, height: imgHeight * 0.30))
 
        print("Succesfully set the LocalUser's matches")
        descriptionLabel.text = match.itemDescription
        descriptionLabel.font = UIFont(name: "Avenir", size: 14)
        descriptionLabel.textColor = self.UIColorFromHex(0x808080)
        descriptionLabel.numberOfLines = 2
        
        let blueLine = UIView(frame: CGRectMake(15, screenSize.height * 0.245, matchContainer.frame.width-30, 1))
        blueLine.backgroundColor = UIColorFromHex(0x2c3e50)
        matchContainer.addSubview(blueLine)
        
        //create the match info labels
        let nameLabel = UILabel(frame: CGRect(x: imgWidth+10, y: 5, width: matchContainer.frame.width - imgWidth - 40, height: imgHeight * 0.15))
        nameLabel.text = match.itemName
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont(name: "Avenir", size: 16)
//        nameLabel.textAlignment = .Center
        matchContainer.addSubview(nameLabel)
        
        let distanceLabel = UILabel(frame: CGRect(x: matchContainer.frame.width - 45, y: 5, width:45, height: imgHeight * 0.15))
        calculateDistanceFromLocation(match.itemLatitude, longitude: match.itemLongitude, myLocation: LocalUser.myLocation)
        while(distSet == false){
        }
        distanceLabel.text = "\(self.distText)"
        distanceLabel.font = UIFont(name: "Avenir", size: 10)
//        distanceLabel.textAlignment = .Center
        matchContainer.addSubview(distanceLabel)
        
        
//        descriptionLabel.textAlignment = .Center
        matchContainer.addSubview(descriptionLabel)
        
        //CHANGE TARGET
        let buyButton = makeTextButton("Buy", frame: CGRect(x: imgWidth+42, y: 20+imgHeight * 0.45, width: matchContainer.frame.width*0.34, height: imgHeight * 0.28), target: #selector(MyMatchesViewController.none(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: false, backgroundColor: UIColorFromHex(0x404040))
//        buyButton.backgroundColor = UIColorFromHex(0x404040)
//        buyButton.titleLabel?.textColor = UIColor.whiteColor()
        buyButton.layer.cornerRadius = 5
        matchContainer.addSubview(buyButton)
        
        
        
        //create the price container + label
        let priceContainer = UIImageView(frame: CGRect(x: screenSize.width*0.27, y: screenSize.width*0.27, width: screenSize.width*0.22, height: screenSize.width*0.15))
        priceContainer.image = UIImage(named: "venn.png")
//        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        
        let priceLabel = UILabel(frame: CGRect(x: 0, y: 2, width: priceContainer.frame.width - 5, height: priceContainer.frame.height))
        let temp = Int(match.matchedPrice)
        priceLabel.text = "$\(temp)"
        priceLabel.textAlignment = .Center
        priceLabel.font = UIFont(name: "Avenir", size: 22)
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        priceContainer.addSubview(priceLabel)
        
//        createBorder(priceContainer)
        matchContainer.addSubview(priceContainer)
        
    }
    
//    //function to control when the bought category is pressed
//    func matchesPressed(sender: UIButton) {
//        print("matches pressed")
//        //calls a function to adjust the page correctly
//        toggleView(true)
//    }
//    
//    //function to control when the bought category is pressed
//    func boughtPressed(sender: UIButton) {
//        print("bought pressed")
//        //calls a function to adjust the page correctly
//        toggleView(false)
//    }
//    
//    //gesture recognizer function to allow functionality of swipping left or right to control which menu to look at
//    func addGestureRecognizer() {
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyMatchesViewController.respondToSwipeGesture(_:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        self.view.addGestureRecognizer(swipeRight)
//        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MyMatchesViewController.respondToSwipeGesture(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        self.view.addGestureRecognizer(swipeLeft)
//    }
    
    //hard coded for now but we can change to size scroll view based on number of matches
    func setupScrollView(containerHeight: CGFloat) {
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        //set up scroll view frame and create variables for the contentView frame
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let contentWidth: CGFloat = scrollView.frame.width
        let contentHeight = CGFloat(LocalUser.user.matches.count) * 2 * containerHeight * CGFloat(1.2) + CGFloat(80)
        
        
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        scrollView.decelerationRate = 0.1
        matchContainerView.frame = CGRectMake(0, 10, contentWidth, contentHeight)
        onMatches = true
        
        //add subviews accordingly
        scrollView.addSubview(matchContainerView)
        view.addSubview(scrollView)
//        view.sendSubviewToBack(scrollView)
//        view.sendSubviewToBack(matchContainerView)
    }
//    
//    //function to control the switching between the 2 possible views given a passed boolean.
//    func toggleView(toMatches: Bool) {
//        if toMatches {
//            //check if the user is on the bought page
//            if onMatches == false {
//                matchesButton.selected = true
//                boughtButton.selected = false
//                boughtBar.backgroundColor = UIColor.whiteColor()
//                matchesBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
//                //add the correct subview and remove the previous
//                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE maybe not TO BE DETERMIENRIDESD
//                boughtContainerView.removeFromSuperview()
//                scrollView.addSubview(matchContainerView)
//                onMatches = true
//            }
//        }
//        else {
//            //check if the user is on the match page
//            if onMatches == true {
//                boughtButton.selected = true
//                matchesButton.selected = false
//                matchesBar.backgroundColor = UIColor.whiteColor()
//                boughtBar.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
//                //add the correct subview and remove the previous
//                //MAY NEED TO BE CHANGED TO HIDDEN INSTEAD OF REMOVE maybe not TO BE DETERMIENRIDESD
//                matchContainerView.removeFromSuperview()
//                scrollView.addSubview(boughtContainerView)
//                onMatches = false
//            }
//        }
//    }
    
    func none(sender: UIButton) {
        
    }
    func calculateDistanceFromLocation(latitude: Double, longitude: Double, myLocation: CLLocation){
        
        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
        let itemLatitude = CLLocationDegrees(latitude)
        let itemLongitude = CLLocationDegrees(longitude)
        let myLatitude = myLocation.coordinate.latitude
        let myLongitude = myLocation.coordinate.longitude
        
        let origins = "origins=\(myLatitude),\(myLongitude)&"
        let destinations = "destinations=\(itemLatitude),\(itemLongitude)&"
        let key = "KEY=AIzaSyBGJFI_sQFJZUpVu4cHd7bD5zlV5lra-FU"
        let url = baseURL+origins+destinations+key
        
        let requestURL: NSURL = NSURL(string: url)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let rows = json["rows"] as? [[String:AnyObject]] {
                        let first = rows[0]
                        let elements = first["elements"] as! Array<AnyObject>
                        let firstElement = elements[0]
                        if let distDict = firstElement["distance"] as? [String:AnyObject] {
                            self.distText = String(distDict["text"]!)
                            self.distSet = true
                        }
                        else {
                            self.distText = "none"
                            self.distSet = true
                        }
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        task.resume()
    }

//    //control for the gesture to allow swipingleft and right for the menu
//    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction {
//            //switch case to distinguish the direction of swiping
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