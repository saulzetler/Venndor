//
//  ItemInfoView.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-27.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class ItemInfoView: UIView, UIScrollViewDelegate {

    var information: UILabel!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
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
    
    //infoVariables
    var itemInfo: UIView!
    var itemName: UILabel!
    var itemDescription: UILabel!
    var itemCondition: UIView!
    var itemConditionLabel: UILabel!
    var itemAge: UILabel! 
    var infoOpen: Bool!
    
    //for map
    var mapView: GMSMapView!
    var distText: String!
    var distanceSet: Bool!
    
    //for seller ifo
    var sellerPic: UIImageView!
    var sellerNameLabel: UILabel!
    var sellerRatingLabel: UILabel!
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, item: Item, myLocation: CLLocation) {
        
        super.init(frame: frame)
        
        self.setupView()
        
        setupScrollView(item)
        setupItemInfo(item, myLocation: myLocation)
        
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    func setupItemInfo(item: Item, myLocation: CLLocation) {
        
        itemInfo = UIView(frame: CGRect(x: 0, y: self.frame.height*0.9, width: self.frame.width, height: self.frame.height*0.1))
        itemInfo.backgroundColor = UIColor.whiteColor()
        itemInfo.layer.cornerRadius = 20
        itemInfo.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ItemInfoView.handleTap(_:)))
        itemInfo.addGestureRecognizer(tap)
       
        itemName = UILabel(frame: CGRect(x: itemInfo.frame.width*0.05, y: itemInfo.frame.height*0.1, width: itemInfo.frame.width*0.7, height: itemInfo.frame.height*0.6))
        itemName.text = item.name
        itemInfo.addSubview(itemName)
        
        let grayBar = UIView(frame: CGRect(x: itemInfo.frame.origin.x, y: itemInfo.frame.height, width: itemInfo.frame.width, height: 1))
        grayBar.backgroundColor = UIColor.lightGrayColor()
        itemInfo.addSubview(grayBar)
        
        
        itemCondition = UIView(frame: CGRect(x: itemInfo.frame.width*0.27, y: itemInfo.frame.height * 1.2, width: itemInfo.frame.width*0.30, height: itemInfo.frame.height*0.45))
        itemCondition.userInteractionEnabled = false
        itemInfo.addSubview(itemCondition)
        //self.setupItemCondition()
        
        itemConditionLabel = UILabel(frame:CGRect(x: itemInfo.frame.width*0.03, y: itemInfo.frame.height * 1.2, width: itemInfo.frame.width*0.22, height: itemInfo.frame.height*0.37))
        itemConditionLabel.text = "Condition"
        itemConditionLabel.adjustsFontSizeToFitWidth = true
        itemInfo.addSubview(itemConditionLabel)

        
        itemDescription = UILabel(frame: CGRect(x: itemInfo.frame.width*0.04, y: itemInfo.frame.height * 1.8, width: itemInfo.frame.width*0.95, height: itemInfo.frame.height*1.6))
        itemDescription.text = item.details
        itemDescription.font = itemDescription.font.fontWithSize(10)
//        itemDescription.sizeToFit()
        itemDescription.numberOfLines = 0
        itemInfo.addSubview(itemDescription)
        
        mapView = GMSMapView(frame: CGRect(x: 0, y: itemInfo.frame.height*3.7, width: itemInfo.frame.width, height: itemInfo.frame.height*3.5))
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(item.latitude), CLLocationDegrees(item.longitude))
        mapView.camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
        let pin = GMSMarker(position: location)
        pin.map = mapView
        itemInfo.addSubview(mapView)
        
        
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
    
        setupDistance(item, myLocation: myLocation)
        
        
        self.addSubview(itemInfo)
        self.bringSubviewToFront(itemInfo)
    }
    
    func setupItemCondition() {
        let size = 10
        var ratingFrame = CGRect(x: 0, y: 0, width: size, height: size)
        for rating in 0...currentItem.condition {
            let star = UIImageView(frame: ratingFrame)

            ratingFrame.origin.x = CGFloat(rating) * CGFloat(size)
            self.itemCondition.addSubview(star)
        }
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
    
    func calculateDistance(item: Item, myLocation: CLLocation) {
        
        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
        let itemLatitude = CLLocationDegrees(item.latitude)
        let itemLongitude = CLLocationDegrees(item.longitude)
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
                            self.distanceSet = true
                        }
                        else {
                            self.distText = "none"
                            self.distanceSet = true
                        }
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        task.resume()
    }
    
    // called from setup item info
    func setupDistance(item: Item, myLocation: CLLocation) {
        distanceSet = false
        let distIcon = UIImage(named: "Marker Filled-100.png")
        let distIconView = UIImageView(frame: CGRect(x: itemInfo.frame.width*0.65, y: itemInfo.frame.height*0.1, width: itemInfo.frame.width*0.1, height: itemInfo.frame.height*0.6))
        distIconView.image = distIcon
        itemInfo.addSubview(distIconView)
        calculateDistance(item, myLocation: myLocation)
        while (!distanceSet) {
        }
        let itemDist = UILabel(frame: CGRect(x: itemInfo.frame.width*0.75, y: itemInfo.frame.height*0.1, width: itemInfo.frame.width*0.25, height: itemInfo.frame.height*0.6))
        itemDist.text = distText
        itemDist.textAlignment = .Center
        itemInfo.addSubview(itemDist)
        infoOpen = false
    }
    
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
    
    internal func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        adjustPage()
        if picNum == numberOfPics-1 && prevPicNum == picNum {
            openInfo()
        }
    }
    
    internal func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
    

}