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
    
    let messageComposer = TextMessageComposer()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "MyMatchesViewController")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("has been reloaded")
        LocalUser.CurrentPage = "My Matches"
        LocalUser.user.mostRecentAction = "Browsed MyMatches"
        sessionStart = NSDate()
        
        self.revealViewController().delegate = self
        setupMatchesScrollContent()
        
        
        addHeaderItems("My Matches")
        sideMenuGestureSetup()
        revealViewController().rightViewController = nil
        
    }
    
    func setupMatchesScrollContent() {
        //set up prelimenary variables to make for-loop more readable
        var index:CGFloat = 0.0
        let yOrigin = screenSize.height * 0.1
        let containerHeight = screenSize.height * 0.27
        var boughtTitle = CGFloat(40)
        var matchTitle = CGFloat(40)
        
        if LocalUser.matches.count != 0 {
            setupScrollView(containerHeight + 10)
            var tempBought = false
            var tempMatch = false
            for match in LocalUser.matches {
                if match.bought == 1 {
                    tempBought = true
                } else if match.bought == 0 {
                    tempMatch = true
                }
            }
            if tempBought == false {
                boughtTitle = 0
            }
            if tempMatch == false {
                matchTitle = 0
            }
            let boughtLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height * 0.08, width: screenSize.width, height: boughtTitle))
            boughtLabel.text = "Bought Items"
            boughtLabel.backgroundColor = UIColorFromHex(0x2c3e50)
            boughtLabel.font = UIFont(name: "Avenir", size: 20)
            boughtLabel.textColor = UIColor.whiteColor()
            boughtLabel.textAlignment = .Center
            self.matchContainerView.addSubview(boughtLabel)
            distSet = false
            
            //populate the matchContainerView
            for match in LocalUser.matches {
                if match.bought == 1 {
                    //create the match container view
                    let matchContainer = ItemContainer(frame: CGRect(x: 0, y: yOrigin + (index * containerHeight) + boughtTitle, width: screenSize.width, height: containerHeight))
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(MyMatchesViewController.toggleMatchItemInfo(_:)))
                    matchContainer.addGestureRecognizer(tap)
                    
                    
                    matchContainer.match = match
                    
                    //self.addContainerContent(matchContainer, img: img, match: match)
                    dispatch_async(dispatch_get_main_queue()) {
                        matchContainer.match = match
                        self.addContainerContent(matchContainer)
                        self.distSet = false
                    }
                    matchContainerView.addSubview(matchContainer)
                    index += 1
                }
            }
            
            //matchtitle to distinguis the shit fuck shit
            let matchLabel = UILabel(frame: CGRect(x: 0, y: screenSize.height * 0.10 + (index * containerHeight) + boughtTitle - screenSize.height*0.016, width: screenSize.width, height: matchTitle))
            matchLabel.text = "Match Items"
            matchLabel.backgroundColor = UIColorFromHex(0x2c3e50)
            matchLabel.font = UIFont(name: "Avenir", size: 22)
            matchLabel.textColor = UIColor.whiteColor()
            matchLabel.textAlignment = .Center
            self.matchContainerView.addSubview(matchLabel)
            
            //populate the matchContainerView
            for match in LocalUser.matches {
                if match.bought == 0 {
                    //create the match container view
                    let matchContainer = ItemContainer(frame: CGRect(x: 0, y: screenSize.height * 0.11 + (index * containerHeight) + matchTitle + boughtTitle-screenSize.height*0.018, width: screenSize.width, height: containerHeight))
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(MyMatchesViewController.toggleMatchItemInfo(_:)))
                    matchContainer.addGestureRecognizer(tap)
                    
                    ItemManager.globalManager.retrieveItemById(match.itemID) { item, error in
                        guard error == nil else {
                            print("Error retrieving item to assign to match container in MyMatches: \(error)")
                            return
                        }
                        
                        if let item = item {
                            matchContainer.item = item
                        }
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        matchContainer.match = match
                        self.addContainerContent(matchContainer)
                        self.distSet = false
                    }
                    
                    matchContainerView.addSubview(matchContainer)
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
            emptyLabel2.text = "Start browsing and start matching!"
            emptyLabel2.font = UIFont(name: "Avenir", size: 22)
            emptyLabel2.adjustsFontSizeToFitWidth = true
            emptyLabel2.textColor = UIColorFromHex(0x2c3e50)
            emptyLabel2.textAlignment = .Center
            emptyView.addSubview(emptyLabel2)
            
            self.view.addSubview(emptyView)
        }
        
    }
    func DropdownAction() {
        
    }
    
    func addContainerContent(matchContainer: ItemContainer) {
        let match = matchContainer.match
        //create the match photo
        let imgView = createImgView(CGRect(x: 0, y: 0, width: screenSize.width*0.4, height: screenSize.width*0.4), action: #selector(MyMatchesViewController.none(_:)), superView: matchContainer)

        imgView.image = match.thumbnail

        let tap = UITapGestureRecognizer(target: self, action: #selector(MyMatchesViewController.toggleMatchItemInfo(_:)))
        imgView.addGestureRecognizer(tap)
        
        let imgHeight = imgView.frame.height
        let imgWidth = imgView.frame.width
        
        let descriptionLabel = UILabel(frame: CGRect(x: imgWidth+10, y: 5+imgHeight * 0.15, width: matchContainer.frame.width - imgWidth - 5, height: imgHeight * 0.30))
 
        descriptionLabel.text = match.itemDescription
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.font = UIFont(name: "Avenir", size: 20)
        descriptionLabel.textColor = self.UIColorFromHex(0x808080)
        descriptionLabel.numberOfLines = 2
        
        let blueLine = UIView(frame: CGRectMake(15, screenSize.height * 0.245, matchContainer.frame.width-30, 1))
        blueLine.backgroundColor = UIColorFromHex(0x2c3e50)
        matchContainer.addSubview(blueLine)
        
        //create the match info labels
        let nameLabel = UILabel(frame: CGRect(x: imgWidth+10, y: 5, width: matchContainer.frame.width - imgWidth - 40, height: imgHeight * 0.15))
        nameLabel.text = match.itemName
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont(name: "Avenir", size: 20)
        matchContainer.addSubview(nameLabel)
        
//        let distanceLabel = UILabel(frame: CGRect(x: matchContainer.frame.width - 45, y: 5, width:45, height: imgHeight * 0.15))
//        calculateDistanceFromLocation(match.itemLatitude, longitude: match.itemLongitude, myLocation: LocalUser.myLocation)
////        print("is trying to get distances")
//        while(distSet == false){
////            print("im stuck")
//        }
//        
//        distanceLabel.text = "\(self.distText)"
//        distanceLabel.font = UIFont(name: "Avenir", size: 16)
//        matchContainer.addSubview(distanceLabel)

        
        matchContainer.addSubview(descriptionLabel)
        
        if match.bought == 0 {
            let buyButton = makeTextButton("Buy", frame: CGRect(x: imgWidth+42, y: 34+imgHeight * 0.45, width: matchContainer.frame.width*0.34, height: imgHeight * 0.28), target: #selector(MyMatchesViewController.toggleBuy(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: false, backgroundColor: UIColorFromHex(0x404040))
            buyButton.titleLabel?.font = UIFont(name: "Avenir", size: 14)
            buyButton.layer.cornerRadius = 5
            matchContainer.addSubview(buyButton)
        } else {
            let messageButton = makeTextButton("Message Seller", frame: CGRect(x: imgWidth+42, y: 34+imgHeight * 0.45, width: matchContainer.frame.width*0.34, height: imgHeight * 0.28), target: #selector(MyMatchesViewController.messageSeller(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: false, backgroundColor: UIColorFromHex(0x404040))
            messageButton.layer.cornerRadius = 5
            messageButton.titleLabel?.font = UIFont(name: "Avenir", size: 14)
            matchContainer.addSubview(messageButton)
        }
        
        
        
        //create the price container + label
        
        let priceContainer = UIImageView(frame: CGRect(x: screenSize.width*0.27, y: screenSize.width*0.27, width: screenSize.width*0.22, height: screenSize.width*0.15))
        priceContainer.image = UIImage(named: "venn.png")
//        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        
        let priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: priceContainer.frame.width - 5, height: priceContainer.frame.height))
        let temp = Int(match.matchedPrice)
        priceLabel.text = "$\(temp)"
        priceLabel.textAlignment = .Center
        priceLabel.font = UIFont(name: "Avenir", size: 20)
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        priceContainer.addSubview(priceLabel)
        
//        createBorder(priceContainer)
        matchContainer.addSubview(priceContainer)
        
    }
    
    //hard coded for now but we can change to size scroll view based on number of matches
    func setupScrollView(containerHeight: CGFloat) {
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        //set up scroll view frame and create variables for the contentView frame
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let contentWidth: CGFloat = scrollView.frame.width
        let contentHeight = CGFloat(LocalUser.user.matches.count) * containerHeight * CGFloat(1.2) + CGFloat(80)
        
        
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        scrollView.decelerationRate = 0.1
        matchContainerView.frame = CGRectMake(0, 10, contentWidth, contentHeight)
        onMatches = true
        
        //add subviews accordingly
        scrollView.addSubview(matchContainerView)
        view.addSubview(scrollView)
    }
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            matchContainerView.userInteractionEnabled = true
            reactivate()
        } else {
            matchContainerView.userInteractionEnabled = false
            deactivate()
        }
    }
    
    func toggleBuy(sender: UIButton) {
        print("Buy tapped!")
        let matchContainer = sender.superview as! ItemContainer
        
        let match = matchContainer.match
        let boughtItem = matchContainer.item
        
        self.definesPresentationContext = true
        UserManager.globalManager.retrieveUserById(match.sellerID) { user, error in
            guard error == nil else {
                print("Error retrieving seller in Buy screen: \(error)")
                return
            }
            
            if let user = user {
                let bvc = BuyViewController()
                bvc.item = boughtItem
                bvc.match = match
                bvc.seller = user
                bvc.item = matchContainer.item
                bvc.fromInfo = false
                bvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                bvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                self.presentViewController(bvc, animated: true, completion: nil)
            }
            else {
                print("Error with parsing user in buy screen. Returning now.")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    
    func none(sender: UIButton) {
        
    }
    
    func messageSeller(sender: UIButton) {
        print("Message tapped!")
        let container = sender.superview as! ItemContainer
        let match = container.match
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController("\(LocalUser.firstName) \(LocalUser.lastName) wants to buy your item \(match.itemName) for $\(match.matchedPrice)")
            
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
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
//                print("Everyone is fine, file downloaded successfully.")
                
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
    
}