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
    //declaring screen size for future reference
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var distSet: Bool!
    var distText: String!
    
    var tappedItem: Item!
    var tappedPost: Post!
    
    //variables needed for the scroll view
    var scrollView: UIScrollView!
    var postContainerView = UIView()
    var postObjects = [Post]()
    var onPosts: Bool!
    var sessionStart: NSDate!
    
    
    override func togglePostItemInfo(sender: UITapGestureRecognizer){
        let containerView: ItemContainer!
        
        if let imgView = sender.view as? UIImageView {
            containerView = imgView.superview as! ItemContainer
        }
        else {
            containerView = sender.view as! ItemContainer
        }
        
        ItemManager.globalManager.retrieveItemById(containerView.post.itemID) { item, error in
            guard error == nil else {
                print("error pulling item data from tapped post: \(error)")
                return
            }
            
            if let item = item {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tappedItem = item
                    self.tappedPost = containerView.post
                    self.performSegueWithIdentifier("showItemInfo", sender: self)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItemInfo" {
            let iivc = segue.destinationViewController as! ItemInfoViewController
            iivc.isPost = true
            print("This got called...")
            iivc.item = tappedItem
            iivc.post = tappedPost
            iivc.headerTitle = "My Posts"
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "MyPostsViewController")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.CurrentPage = "My Posts"
        LocalUser.user.mostRecentAction = "Browsed MyPost"
        sessionStart = NSDate()
        
        self.revealViewController().delegate = self
        
        //set up prelimenary variables to make for-loop more readable
        var index:CGFloat = 0.0
        let yOrigin = screenSize.height * 0.1
        let containerHeight = screenSize.height * 0.27
        var soldTitle = CGFloat(40)
        var postTitle = CGFloat(40)
        
        if LocalUser.posts.count != 0 {
            setupScrollView(containerHeight + 10)
            var tempSold = false
            var tempPost = false
            for post in LocalUser.posts {
                if post.sold == 1 {
                    tempSold = true
                } else if post.sold == 0 {
                    tempPost = true
                }
            }
            if tempSold == false {
                soldTitle = 0
            }
            if tempPost == false {
                postTitle = 0
            }
            
            let soldLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height * 0.08, width: screenSize.width, height: soldTitle))
            soldLabel.text = "Sold Items"
            soldLabel.backgroundColor = UIColorFromHex(0x2c3e50)
            soldLabel.font = UIFont(name: "Avenir", size: 20)
            soldLabel.textColor = UIColor.whiteColor()
            soldLabel.textAlignment = .Center
            self.postContainerView.addSubview(soldLabel)
            distSet = false
            
            //populate the postContainerView
            for post in LocalUser.posts {
                if post.sold == 1 {
                    
                    //create the match container view
                    let postContainer = ItemContainer(frame: CGRect(x: 0, y: yOrigin + (index * containerHeight) + soldTitle, width: screenSize.width, height: containerHeight))
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(MyPostsViewController.togglePostItemInfo(_:)))
                    postContainer.addGestureRecognizer(tap)
                    

                    dispatch_async(dispatch_get_main_queue()) {
                        postContainer.post = post
                        self.addContainerContent(postContainer)
                        self.distSet = false
                    }
                    
                    postContainerView.addSubview(postContainer)
                    index += 1
                }
            }
            
            //matchtitle to distinguis the shit fuck shit
            let postLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height * 0.09 + (index * containerHeight) + soldTitle - screenSize.height*0.016, width: screenSize.width, height: postTitle))
            postLabel.text = "Posted Items"
            postLabel.backgroundColor = UIColorFromHex(0x2c3e50)
            postLabel.font = UIFont(name: "Avenir", size: 20)
            postLabel.textColor = UIColor.whiteColor()
            postLabel.textAlignment = .Center
            self.postContainerView.addSubview(postLabel)
            
            //populate the postContainerView
            for post in LocalUser.posts {
                if post.sold == 0 {
                    //create the match container view
                    let postContainer = ItemContainer(frame: CGRect(x: 0, y: screenSize.height * 0.11 + (index * containerHeight) + postTitle + soldTitle-screenSize.height*0.018, width: screenSize.width, height: containerHeight))
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(MyPostsViewController.togglePostItemInfo(_:)))
                    postContainer.addGestureRecognizer(tap)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        postContainer.post = post
                        self.addContainerContent(postContainer)
                        self.distSet = false
                    }
                    
                    postContainerView.addSubview(postContainer)
                    index += 1
                }
            }
        }
        else {
            let emptyView = UIView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: screenSize.height-screenSize.height*0.1))
            let emptyLogo = UIImageView(frame: CGRect(x: screenSize.width*0.35, y: screenSize.height*0.15, width: screenSize.width*0.3, height: screenSize.width*0.3))
            emptyLogo.image = UIImage(named: "iphone-icon.png")
            //            emptyLogo.contentMode = .ScaleAspectFit
            emptyLogo.layer.cornerRadius = emptyLogo.bounds.size.width * 0.5
            emptyLogo.layer.masksToBounds = true
            emptyView.addSubview(emptyLogo)
            let emptyLabel = UILabel(frame: CGRect(x: screenSize.width*0.05, y: screenSize.height*0.2, width: screenSize.width*0.9, height: screenSize.height*0.3))
            emptyLabel.text = "Nothing here yet!"
            emptyLabel.font = UIFont(name: "Avenir", size: 26)
            emptyLabel.adjustsFontSizeToFitWidth = true
            emptyLabel.textColor = UIColorFromHex(0x2c3e50)
            emptyLabel.textAlignment = .Center
            emptyView.addSubview(emptyLabel)
            let emptyLabel2 = UILabel(frame: CGRect(x: screenSize.width*0.05, y: screenSize.height*0.25, width: screenSize.width*0.9, height: screenSize.height*0.3))
            emptyLabel2.text = "Post an item and make a sale today!"
            emptyLabel2.font = UIFont(name: "Avenir", size: 22)
            emptyLabel2.adjustsFontSizeToFitWidth = true
            emptyLabel2.textColor = UIColorFromHex(0x2c3e50)
            emptyLabel2.textAlignment = .Center
            emptyView.addSubview(emptyLabel2)
//            let emptyButton = 
            
            self.view.addSubview(emptyView)
        }
        
        addHeaderItems("My Posts")
        sideMenuGestureSetup()
        revealViewController().rightViewController = nil
        
        //        addGestureRecognizer()
        //        setupButtons()
        
    }
    func DropdownAction() {
        
    }
    
    
    func addContainerContent(postContainer: ItemContainer) {
        let post = postContainer.post
        
        //create the match photo
        let imgHeight = screenSize.width*0.4
        let imgWidth = screenSize.width*0.4
        let imgView = createImgView(CGRect(x: postContainer.frame.width - imgWidth + 5, y: 0, width: screenSize.width*0.4, height: screenSize.width*0.4), action: #selector(MyMatchesViewController.none(_:)), superView: postContainer)
        imgView.image = post.thumbnail
        imgView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyPostsViewController.togglePostItemInfo(_:)))
        imgView.addGestureRecognizer(tap)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 5+imgHeight * 0.20, width: postContainer.frame.width - imgWidth - 5, height: imgHeight * 0.50))
        descriptionLabel.text = post.itemDescription
        descriptionLabel.font = UIFont(name: "Avenir", size: 20)
        descriptionLabel.textColor = self.UIColorFromHex(0x808080)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        
        
        let blueLine = UIView(frame: CGRectMake(15, screenSize.height * 0.245, postContainer.frame.width-30, 1))
        blueLine.backgroundColor = UIColorFromHex(0x2c3e50)
        postContainer.addSubview(blueLine)
        
        //create the match info labels
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 5, width: postContainer.frame.width - imgWidth - 20, height: imgHeight * 0.19))
        nameLabel.text = post.itemName
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont(name: "Avenir", size: 20)
        //        nameLabel.textAlignment = .Center
        postContainer.addSubview(nameLabel)
        
        
        //        descriptionLabel.textAlignment = .Center
        postContainer.addSubview(descriptionLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: 10, y: screenSize.width*0.29, width: postContainer.frame.width - imgWidth - 20, height: screenSize.width*0.15))
        let temp = post.sold == 1 ? post.soldPrice : post.minPrice
        priceLabel.text = "$\(temp)"
        priceLabel.textAlignment = .Center
        priceLabel.font = UIFont(name: "Avenir", size: 24)
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        postContainer.addSubview(priceLabel)
    }
    
    //hard coded for now but we can change to size scroll view based on number of matches
    func setupScrollView(containerHeight: CGFloat) {
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        //set up scroll view frame and create variables for the contentView frame
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let contentWidth: CGFloat = scrollView.frame.width
        let contentHeight = CGFloat(LocalUser.user.posts.count) * containerHeight * CGFloat(1.2) + CGFloat(80)
        
        
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        scrollView.decelerationRate = 0.1
        postContainerView.frame = CGRectMake(0, 10, contentWidth, contentHeight)
        onPosts = true
        
        //add subviews accordingly
        scrollView.addSubview(postContainerView)
        view.addSubview(scrollView)
    }
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            postContainerView.userInteractionEnabled = true
            reactivate()
        } else {
            postContainerView.userInteractionEnabled = false
            deactivate()
        }
    }
    
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