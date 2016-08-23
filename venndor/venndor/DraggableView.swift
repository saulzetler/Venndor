//
//  DraggableView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView) -> Void
    func cardSwipedRight(card: UIView) -> Void
}

public class DraggableView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var screenSize = UIScreen.mainScreen().bounds
    
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView!
    var information: UILabel!
    var xFromCenter: Float!
    var yFromCenter: Float!
    
    //for scroll view
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl! = UIPageControl()
    var picNum: Int!
    var prevPicNum: Int!
    var numberOfPics: Int!
    
    //save current item
    var currentItem: Item!
    var firstPhoto: UIImage!
    
    var itemInfo: UIView!
    var itemName: UILabel!
    var itemDescription: UILabel!
    var infoOpen: Bool!
    
    //for map
    var mapView: GMSMapView!
    var distText: String!
    var distanceSet: Bool!
    
    //for seller
    var sellerPic: UIImageView!
    var sellerNameLabel: UILabel!
    var sellerRatingLabel: UILabel!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, item: Item, myLocation: CLLocation?) {
        
        super.init(frame: frame)

        self.setupView()
        currentItem = item
        
        setupScrollView(item)
        setupItemInfo(item, myLocation: myLocation)

        self.backgroundColor = UIColor.whiteColor()

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged(_:)))

        self.addGestureRecognizer(panGestureRecognizer)
            
        overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-100, 0, 100, 100))
        overlayView.alpha = 0
        self.addSubview(overlayView)
        
        xFromCenter = 0
        yFromCenter = 0
    
    }
    
    func setupItemInfo(item: Item, myLocation: CLLocation?) {
        
        itemInfo = UIView(frame: CGRect(x: 0, y: self.frame.height*0.9, width: self.frame.width, height: self.frame.height*0.1))
        itemInfo.backgroundColor = UIColor.whiteColor()
        itemInfo.layer.cornerRadius = 20
        itemInfo.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DraggableView.handleTap(_:)))
        tap.delegate = self
        itemInfo.addGestureRecognizer(tap)
        itemName = UILabel(frame: CGRect(x: itemInfo.frame.width*0.05, y: itemInfo.frame.height*0.1, width: itemInfo.frame.width*0.7, height: itemInfo.frame.height*0.6))
        itemName.text = item.name
        itemInfo.addSubview(itemName)
        itemDescription = UILabel(frame: CGRect(x: itemInfo.frame.width*0.05, y: itemInfo.frame.height, width: itemInfo.frame.width*0.95, height: itemInfo.frame.height*1.6))
        itemDescription.text = item.details
        itemDescription.font = itemDescription.font.fontWithSize(10)
//        itemDescription.sizeToFit()
        itemDescription.numberOfLines = 0
        itemInfo.addSubview(itemDescription)
        
//        mapView = GMSMapView(frame: CGRect(x: 0, y: itemInfo.frame.height*3, width: itemInfo.frame.width, height: itemInfo.frame.height*3.5))
//        let location = CLLocationCoordinate2DMake(CLLocationDegrees(item.latitude), CLLocationDegrees(item.longitude))
//        mapView.camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
//        let pin = GMSMarker(position: location)
//        pin.map = mapView
//        itemInfo.addSubview(mapView)
        
        infoOpen = false
        
//        setupDistance(item, myLocation: myLocation)
        
        UserManager.globalManager.retrieveUserById(item.owner) { user, error in
            guard error == nil else {
                print("Error retrieving item owner for item info: \(error)")
                return
            }
            
            if let user = user {
                dispatch_async(dispatch_get_main_queue()) {
                    self.sellerPic = self.setupSellerPic(user.profilePictureURL)
                    self.itemInfo.addSubview(self.sellerPic)
                    
                    
                    let lastInitial = user.lastName.substringToIndex(user.lastName.startIndex.advancedBy(1))
                    let sellerName = "\(user.firstName) \(lastInitial)"
                    let label = self.setupSellerNameLabel(sellerName)
                    self.sellerNameLabel = label
                    self.itemInfo.addSubview(self.sellerNameLabel)
                    
                    self.sellerRatingLabel = self.setupSellerRatingLabel(user.rating)
                    self.itemInfo.addSubview(self.sellerRatingLabel)
                    
                    let star = UIImageView(frame: CGRect(x: self.itemInfo.frame.width*0.77, y: self.itemInfo.frame.height * 8.76, width: self.screenSize.width*0.05, height: self.screenSize.width*0.05))
                    star.image = UIImage(named: "Star_Filled.png")
                    // star.contentMode = .ScaleToFill
                    self.itemInfo.addSubview(star)
                    
                }
            }
        }
        
        self.addSubview(itemInfo)
        self.bringSubviewToFront(itemInfo)
    }
    
    func setupSellerNameLabel(name: String) -> UILabel {
        let sellerNameLabel = UILabel(frame: CGRect(x: self.itemInfo.frame.width*0.65, y: self.itemInfo.frame.height * 6.7, width: self.screenSize.width*0.3, height: self.screenSize.width*0.45))
        sellerNameLabel.text = name
        sellerNameLabel.font = UIFont.boldSystemFontOfSize(20)
        return sellerNameLabel
    }
    
    func setupSellerRatingLabel(rating: Double) -> UILabel {
        let sellerRatingLabel = UILabel(frame: CGRect(x: self.itemInfo.frame.width*0.71, y: self.itemInfo.frame.height * 7.3, width: self.screenSize.width*0.20, height: self.screenSize.width*0.45))
        sellerRatingLabel.text = "\(Int(rating))"
        sellerRatingLabel.adjustsFontSizeToFitWidth = true
        return sellerRatingLabel
    }
    
    func setupSellerPic(url: String) -> UIImageView {
        let sellerPicView = UIImageView(frame: CGRect(x: self.itemInfo.frame.width*0.22, y: self.itemInfo.frame.height * 7.53, width: self.screenSize.width*0.30, height: self.screenSize.width*0.30))
        let link = NSURL(string: url)
        let pictureData = NSData(contentsOfURL: link!)
        sellerPicView.image = UIImage(data: pictureData!)
        sellerPicView.layer.masksToBounds = false
        sellerPicView.layer.cornerRadius = (sellerPicView.frame.size.width)/2
        sellerPicView.clipsToBounds = true
        sellerPicView.contentMode = .ScaleAspectFill
        return sellerPicView
        
    }
    
//    func calculateDistance(item: Item, myLocation: CLLocation?) {
//        
//        if let myLocation = myLocation  {
//            let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
//            let itemLatitude = CLLocationDegrees(item.latitude)
//            let itemLongitude = CLLocationDegrees(item.longitude)
//            let myLatitude = myLocation.coordinate.latitude
//            let myLongitude = myLocation.coordinate.longitude
//            
//            let origins = "origins=\(myLatitude),\(myLongitude)&"
//            let destinations = "destinations=\(itemLatitude),\(itemLongitude)&"
//            let key = "KEY=AIzaSyBGJFI_sQFJZUpVu4cHd7bD5zlV5lra-FU"
//            let url = baseURL+origins+destinations+key
//            
//            let requestURL: NSURL = NSURL(string: url)!
//            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//            let session = NSURLSession.sharedSession()
//            let task = session.dataTaskWithRequest(urlRequest) {
//                (data, response, error) -> Void in
//                
//                let httpResponse = response as! NSHTTPURLResponse
//                let statusCode = httpResponse.statusCode
//                
//                if (statusCode == 200) {
//                    
//                    do {
//                        
//                        
//                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//                        if let rows = json["rows"] as? [[String:AnyObject]] {
//                            let first = rows[0]
//                            let elements = first["elements"] as! Array<AnyObject>
//                            let firstElement = elements[0]
//                            if let distDict = firstElement["distance"] as? [String:AnyObject] {
//                                self.distText = String(distDict["text"]!)
//                                self.distanceSet = true
//                            }
//                            else {
//                                self.distText = "none"
//                                self.distanceSet = true
//                            }
//                        }
//                    } catch {
//                        print("Error with Json: \(error)")
//                    }
//                    
//                }
//            }
//            task.resume()
//        }
//            
//        else {
//            self.distText = "none"
//            self.distanceSet = true
//            return
//        }
//        
//        
//    }
    
    // called from setup item info
//    func setupDistance(item: Item, myLocation: CLLocation?) {
//        distanceSet = false
//        let distIcon = UIImage(named: "Marker Filled-100.png")
//        let distIconView = UIImageView(frame: CGRect(x: itemInfo.frame.width*0.65, y: itemInfo.frame.height*0.1, width: itemInfo.frame.width*0.1, height: itemInfo.frame.height*0.6))
//        distIconView.image = distIcon
//        itemInfo.addSubview(distIconView)
////        calculateDistance(item, myLocation: myLocation)
//        while (!distanceSet) {
//        }
//        let itemDist = UILabel(frame: CGRect(x: itemInfo.frame.width*0.75, y: itemInfo.frame.height*0.1, width: itemInfo.frame.width*0.25, height: itemInfo.frame.height*0.6))
////        itemDist.text = distText
//        itemDist.text = "HI TEST"
//        itemDist.textAlignment = .Center
//        itemInfo.addSubview(itemDist)
//        
//    }

    //scroll view funcs
    func setupScrollView(item: Item) {
        numberOfPics = item.photoCount
        scrollView = UIScrollView()
        let cardWidth = self.frame.width
        let cardHeight = self.frame.height
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, cardWidth, cardHeight*0.9)
        scrollView.contentSize = CGSizeMake(cardWidth, cardHeight*0.9*CGFloat(item.photoCount))
        scrollView.decelerationRate = 0.1
        pageControl.currentPage = 0
        containerView.frame = CGRectMake(0, 0, cardWidth, cardHeight*0.9*CGFloat(item.photoCount))
        picNum = 0
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        let temp = ItemManager()
        for x in 0..<item.photoCount {
            temp.retrieveItemImage(item, imageIndex: x) { img, error in
                guard error == nil else {
                    print("Error getting the image from the server: \(error)")
                    return
                }
                if x == 0 {
                    self.firstPhoto = img
                }
                
                if let phonto = img {
                    dispatch_async(dispatch_get_main_queue()) {
                        let temp2 = UIImageView(frame: CGRectMake(0, scrollViewHeight*CGFloat(x),scrollViewWidth, scrollViewHeight))
                        temp2.image = phonto
                        temp2.contentMode = .ScaleAspectFill
                        temp2.clipsToBounds = true
                        self.containerView.addSubview(temp2)
                    }
                }
            }
        }
        scrollView.addSubview(containerView)
        
        self.addSubview(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        adjustPage()
        if picNum == numberOfPics-1 && prevPicNum == picNum {
            openInfo()
        }
    }

    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        adjustPage()
    }
    
    func adjustPage() {
        
        // Test the offset and calculate the current page after scrolling ends
        let pageHeight:CGFloat = CGRectGetHeight(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/2)/pageHeight)+1
        // Change the indicator
        prevPicNum = picNum
        picNum = Int(currentPage)
        self.pageControl.currentPage = picNum
        
        for y in 0...6 {
            if y == picNum {
                let yOffset = CGPointMake(0, pageHeight*CGFloat(y));
                self.scrollView.setContentOffset(yOffset, animated: true)
            }
        }
    }

    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }
    
    
    func handleTap(sender: AnyObject?) {
        if infoOpen == false { //open info
            openInfo()
        }
        else { //close info
            closeInfo()
        }
    }
    
    func openInfo() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.itemInfo.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.itemInfo.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.95)
        }) { (finished: Bool) -> Void in
        }
        infoOpen = true
    }
    
    func closeInfo() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.itemInfo.frame = CGRect(x: 0, y: self.frame.height*0.9, width: self.frame.width, height: self.frame.height*0.1)
            self.itemInfo.backgroundColor = UIColor.whiteColor()
        }) { (finished: Bool) -> Void in
        }
        infoOpen = false
    }

    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translationInView(self).x)
        yFromCenter = Float(gestureRecognizer.translationInView(self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            self.originPoint = self.center
        case UIGestureRecognizerState.Changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)

//            self.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y + CGFloat(yFromCenter))

            self.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y)
            
            let transform = CGAffineTransformMakeRotation(CGFloat(rotationAngle))
            let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
            self.transform = scaleTransform
            self.updateOverlay(CGFloat(xFromCenter))
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.Possible:
            fallthrough
        case UIGestureRecognizerState.Cancelled:
            fallthrough
        case UIGestureRecognizerState.Failed:
            fallthrough
        default:
            break
        }
    }

    func updateOverlay(distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        } else {
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100, 0.7))
    }

    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        let floatYFromCenter = Float(yFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        }
        else if floatYFromCenter < -ACTION_MARGIN {
            self.upAction()
        }
        else if floatYFromCenter > ACTION_MARGIN {
            self.downAction()
        }
        else {
            resetView()
        }
    }
    
    func resetView() {
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.center = self.originPoint
            self.transform = CGAffineTransformMakeRotation(0)
            self.overlayView.alpha = 0
        })
    }
    
    func upAction() -> Void {
        //use this function to go to next picture
        print("picNum: \(picNum)")
        print("numberOfPics: \(numberOfPics)")
        
        if picNum == numberOfPics-1 {
            openInfo()
        }
        adjustPage()
        resetView()
    }
    
    func downAction() -> Void {
        //use this function to go to previous picture
        adjustPage()
        resetView()
    }
    
    func rightAction() -> Void {
//        let offerView = OfferView(self.frame = CGRectMake(0, 0, 0, 0))
//        self.parentViewController!.bringUpNewView(offerView)
//        let image: UIImage = currentItem.photos![0]
//        let offerViewController = OfferViewController()
//        offerViewController.setupBackground(firstPhoto)
        
        let bvc = self.parentViewController as! BrowseViewController
        
        bvc.performSegueWithIdentifier("toOfferScreen", sender: self.parentViewController!)
        
        let finishPoint: CGPoint = CGPointMake(500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        
        
        delegate.cardSwipedRight(self)
    }

    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }

    func rightClickAction() -> Void {
        let finishPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
    }

    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
}