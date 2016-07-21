//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPopoverPresentationControllerDelegate, DraggableViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, SWRevealViewControllerDelegate {

    var allCards: [DraggableView]!
    var itemList: [Item]!
    
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.77
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    var MAX_BUFFER_SIZE: Int!
    
    var cardsLoadedIndex: Int!
    var currentCardIndex: Int!
    var loadedCards: [DraggableView]!
    var loadedInfos: [DraggableView]!

    //variables for miniMatches
    var miniMatchContainer = [UIImageView]()
    var tappedItem: Item!
    
    //declare the current category so we know what cards we need to filter
    var currentCategory: String!
    var itemInfo: UIView!
    var draggableInfo: DraggableView!
    var itemName: UILabel!
    var itemDescription: UILabel!
    var itemCondtion: UIView!
    
    //variables to help declare and set things
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var miniMatches: UIButton!
    let fadeOut = UIView()
    var headerView: HeaderView!
    
    var infoOpen: Bool!
    var loaded: Bool!
    
    //location variables
    
    let locationManager = CLLocationManager()
    var myLocation: CLLocation!
    var locationAuthorized: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaded = false
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.revealViewController().delegate = self
        
//        let temp = 45.00
//        let temp2 = 0.00
//        var conversion = LocationConverter()
//        let geoHash = conversion.coordToGeo(temp, longitudeInput: temp2)
//        print ("THIS IS THE CURRENT GEOHASH YOU GETTING DAWG: " + geoHash)
//        
//        print(GlobalItems.currentCategory)
        
//        self.view.backgroundColor = UIColor(red: 0.92, green: 0.95, blue: 0.93, alpha: 1)
        
//        let globalItems = GlobalItems()

        
        //intialize the global items in this controller
//        let globalItems = GlobalItems()
        
        /* ADD FUNCTION ON WHEN SWIPPING TO ROTATE THE GLOBAL ITEM */
        
        // Do any additional setup after loading the view, typically from a nib.	
//        let user = LocalUser.user
//        let items = GlobalItems.items
        
        
        let manager = ItemManager()
        let filter = manager.constructFeedFilter()
        manager.retrieveMultipleItems(5, offset: nil, filter: filter, fields: nil) { items, error in
            guard error == nil else {
                print("Error retrieving items for browse feed: \(error)")
                return
            }
            
            if let items = items {
                GlobalItems.items = items
                dispatch_async(dispatch_get_main_queue()) {
                    self.setupView()
//                    self.setupItemInfo()
                }
            }
        }
//        setupView()
//        setupItemInfo()
        
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        //cover view
//        let cover = UIView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: screenSize.height*0.9))
//        cover.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.6)
//        cover.hidden = false
//        self.view.addSubview(cover)
        
        //MiniMyMatches button at bottom of browse.
        let buttonSize = CGRect(x: screenSize.width*0.435, y: screenSize.height*0.91, width: screenSize.width*0.13, height: screenSize.width*0.13)
        miniMatches = makeImageButton("ic_keyboard_arrow_up_white.png", frame: buttonSize, target: #selector(BrowseViewController.showAlert(_:)), tinted: false, circle: true, backgroundColor: 0x2c3e50, backgroundAlpha: 1)
        
        miniMatches.layer.cornerRadius = 0.5 * miniMatches.bounds.size.width
        miniMatches.layer.masksToBounds = true
        
        let bottomBar = CGRect(x: 0, y: screenSize.height*0.93, width: screenSize.width, height: screenSize.height*0.07)
        let bottomBarButton = UIButton(frame: bottomBar)
        bottomBarButton.backgroundColor = UIColorFromHex(0x2c3e50)
        bottomBarButton.addTarget(self, action: #selector(BrowseViewController.showAlert(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(bottomBarButton)

        self.view.addSubview(miniMatches)
        
        //prepare the reveal view controller to allow swipping and side menus.
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        //add the headerview
        addHeader()
//        self.view.bringSubviewToFront(cover)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //code to for when the user swipes right to make an offer
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "toOfferScreen":
            let ovc = segue.destinationViewController as! OfferViewController
            ovc.offeredItem = itemList[currentCardIndex]
            
        case "showItemInfo":
            let ivc = segue.destinationViewController as! ItemInfoViewController
            ivc.item = self.tappedItem
        default:
            print("The fuck kind of segue are you trying to do?!?!")
            return
        }
    }
    
    func setupView() {
        self.view.backgroundColor = UIColorFromHex(0xecf0f1, alpha: 1)
        MAX_BUFFER_SIZE = GlobalItems.items.count
        itemList = []
        allCards = []
        loadedCards = []
        currentCardIndex = 0
        cardsLoadedIndex = 0
        loadCards(GlobalItems.items)
    }
    
    //function to bring up mini matches bottom menu
    func showAlert(sender: UIButton) {
        
        //create the controller for the bottom menu
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // create the custom view for the bottom menu
        let rect = CGRectMake(-10, 0, alertController.view.bounds.size.width, 165.0)
        let customView = UIView(frame: rect)
        let contentScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: customView.frame.width, height: customView.frame.height))
        setupMiniContentScroll(contentScroll)
        
        customView.addSubview(contentScroll)
        
        
        let customViewTwo = UIView(frame: CGRect(x: -10, y: 125, width: alertController.view.bounds.size.width+10, height: 75))
        customViewTwo.backgroundColor = UIColorFromHex(0x1abc9c, alpha: 1)

        //create the custom cancel view for the user to quit the menu
        //note this function also cancels when a user presses outside the frame
        let arrowView = UIView(frame: CGRect(x: (alertController.view.bounds.size.width)/2-23, y: 145, width: 30, height: 30))
        arrowView.backgroundColor = UIColor(patternImage: UIImage(named: "ic_keyboard_arrow_down_white.png")!)

        customView.backgroundColor = UIColorFromHex(0xe6e6e6)
        //round the corners to look more appealing
        customView.layer.cornerRadius = 15

        alertController.view.addSubview(customView)
        alertController.view.addSubview(customViewTwo)
        alertController.view.addSubview(arrowView)
        
        //declare the type of alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
        
    }
    
    //function to create contentScrollView for MiniMyatches
    func setupMiniContentScroll(contentScroll: UIScrollView) {
        let scalar:Double = 4/19
        let contentViewDimension = contentScroll.frame.width * CGFloat(scalar)
        let contentScrollWidth = CGFloat(LocalUser.matches.count) * (contentViewDimension + CGFloat(12)) - CGFloat(12)
        let matchManager = MatchesManager()
        
        for index in 0..<LocalUser.matches.count {
            let match = LocalUser.matches[index]
            matchManager.retrieveMatchThumbnail(match) { img, error in
                
                if let img = img {
                    
                    //create the mini matches views
                    let xOrigin = index == 0 ? 12 : CGFloat(index) * contentViewDimension + (CGFloat(12) * CGFloat(index) + CGFloat(12))
                    let contentFrame = CGRectMake(xOrigin, 10, contentViewDimension, contentViewDimension)
                    let contentView = self.makeMiniContentView(contentFrame, image: img, matchedPrice: match.matchedPrice)
                    contentView.match = match
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(BrowseViewController.toggleItemInfo(_:)))
                    contentView.addGestureRecognizer(tap)
                    //self.miniMatchContainer.append(contentView)
                    //print("MiniMatchContainer Index: \(self.miniMatchContainer.indexOf(contentView)), Match at Index: \(match.itemName)")
                                        
                    //update the contentScrollView
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        let contentLabelFrame = CGRect(x: xOrigin, y: contentFrame.height + 15, width: contentFrame.width, height: 20)
                        let contentLabel = self.makeMiniContentLabel(contentLabelFrame, itemName: match.itemName)
                        let priceLabel = self.makeMiniPriceLabel(contentFrame, matchedPrice: match.matchedPrice)

                        contentScroll.addSubview(contentView)
                        contentScroll.addSubview(contentLabel)
                        contentScroll.addSubview(priceLabel)
                        contentScroll.contentSize = CGSizeMake(contentScrollWidth + CGFloat(16), contentScroll.frame.height)
                    }
                }
               
            }
        }

    }
    
    func toggleItemInfo(sender: UITapGestureRecognizer) {
        let container = sender.view  as! ItemContainer
        let manager = ItemManager()
        print("MiniMatch Tapped!")
        
        let match = container.match
        manager.retrieveItemById(match.itemID) { item, error in
            guard error == nil else {
                print("Error pulling item from server in miniMatches: \(error)")
                return
            }
                
            if let item = item {
                self.tappedItem = item
                self.performSegueWithIdentifier("showItemInfo", sender: self)
            }
        }
    }
    
    func backToSplash() {
        self.performSegueWithIdentifier("backToSplash", sender: self)
    }
    
    
    func makeMiniPriceLabel(contentLabelFrame: CGRect, matchedPrice: Double) -> UIView {
        let priceLabelHeight = contentLabelFrame.height * 0.25
        let priceLabelWidth = contentLabelFrame.width * 0.55
        let priceLabelFrame = CGRect(x: contentLabelFrame.origin.x + contentLabelFrame.width - CGFloat(30), y: contentLabelFrame.origin.y - 7, width: priceLabelWidth, height: priceLabelHeight)
        
        //create the price container
        let priceContainer = UIView(frame: priceLabelFrame)
        priceContainer.backgroundColor = UIColorFromHex(0x2ecc71)
        
        //create the price label
        let priceLabel = UILabel(frame: CGRect(x: 3, y:0, width: priceContainer.frame.width, height: priceContainer.frame.height))
        priceLabel.text = "$\(matchedPrice)"
        priceLabel.numberOfLines = 1
        //priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.font = priceLabel.font.fontWithSize(8)
        
        priceContainer.addSubview(priceLabel)
        createBorder(priceContainer)
        return priceContainer

    }
    
    //functions to create labels and imgViews for MiniMyMatches
    
    func makeMiniContentView(frame: CGRect, image: UIImage, matchedPrice: Double) -> ItemContainer {
        
        let containerView = ItemContainer(frame: frame)
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
        imgView.image = image
        imgView.userInteractionEnabled = true
        
        createBorder(imgView)
        containerView.addSubview(imgView)
        return containerView
    }
    
    func makeMiniContentLabel(frame: CGRect, itemName: String) -> UILabel {
        let contentLabel = UILabel(frame: frame)
        contentLabel.text = itemName
        contentLabel.numberOfLines = 2
        contentLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.textAlignment = .Center
        return contentLabel

    }
    
    //functions to create dragable views
    
    func createDraggableViewFromItem(item: Item) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT), item: item, myLocation: myLocation)
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.delegate = self
        return draggableView
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
//        while locationAuthorized == false {
//        }
        myLocation = CLLocation(latitude: 10, longitude: 10)
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT), item: GlobalItems.items[index], myLocation: myLocation)
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.delegate = self
        return draggableView
    }
    
    //Dragable view delegate functions
    
    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
//        loadedInfos.removeAtIndex(0)
        LocalUser.seenPosts[itemList[currentCardIndex].id] = NSDate()
        loadAnotherCard()
        nextCard()
        
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
//        loadedInfos.removeAtIndex(0)
        loadAnotherCard()
        nextCard()
    }
    
    //inserts a new card to the back of the view
    func nextCard() {
        currentCardIndex = currentCardIndex + 1
        //to avoid that backgroung thread autolayout error
        dispatch_async(dispatch_get_main_queue(), {
            self.insertNewCard()
        })
    }
    func insertNewCard() {
        if cardsLoadedIndex - currentCardIndex > 0 {
            let newCard = loadedCards[cardsLoadedIndex - currentCardIndex - 1]
            self.view.addSubview(newCard)
            self.view.sendSubviewToBack(newCard)
//            self.view.addSubview(newInfo)
//            self.view.sendSubviewToBack(newInfo)
//            updateItemInfo()
        }
        else {
//            itemInfo.removeFromSuperview()
        }
    }
    
    //loading cards
    
    //loads one new card
    func loadAnotherCard() -> Void {
        let itemManager = ItemManager()

        let feedFilter = itemManager.constructFeedFilter()
        itemManager.retrieveMultipleItems(1, offset: cardsLoadedIndex, filter: feedFilter, fields: nil) { items, error in

            guard error == nil else {
                print("Error retrieving items from server: \(error)")
                return
            }
            
            if items != nil {
                let tempItem = items!
                
                //check that item is returned before creating slide to avoid null pointer exceptions
                if tempItem.count > 0 {
                    self.itemList.append(tempItem[0])
                    let newCard: DraggableView = self.createDraggableViewFromItem(tempItem[0])
                    self.loadedCards.append(newCard)
                    self.cardsLoadedIndex = self.cardsLoadedIndex + 1
                }
            }
        }
    }

    //loads the intial 5 cards
    func loadCards(items: [Item]) -> Void {
        if items.count > 0 {
            let numLoadedCardsCap = items.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : items.count
            for i in 0 ..< items.count {
                itemList.append(items[i])
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            while cardsLoadedIndex < loadedCards.count {
                if cardsLoadedIndex == 0 {
                    self.view.addSubview(loadedCards[cardsLoadedIndex])
                }
                else {
                    self.view.insertSubview(loadedCards[cardsLoadedIndex], belowSubview: loadedCards[cardsLoadedIndex - 1])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
            loaded = true
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let manager = SeenPostsManager()
        manager.updateSeenPostsById(LocalUser.user.id) { error in
            guard error == nil else {
                print("Error updating LocalUser's seen posts: \(error)")
                return
            }
            
            print("Succesfully updated the LocalUser's seen posts.")
        }
    }
    
    //delegate functions
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationAuthorized = true
            myLocation = location
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        if status == .AuthorizedWhenInUse {            
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func revealController(revealController: SWRevealViewController, willMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
//            self.view.userInteractionEnabled = true
            if loaded == true {
                loadedCards[currentCardIndex].userInteractionEnabled = true
                reactivate()
            }
            
        }else {
//            self.view.userInteractionEnabled = false
            if loaded == true {
                loadedCards[currentCardIndex].userInteractionEnabled = false
                print("deactivated")
                deactivate()
            }
            
        }
    }
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
//            self.view.userInteractionEnabled = true
            if loaded == true {
                loadedCards[currentCardIndex].userInteractionEnabled = true
            }
        } else {
            if loaded == true {
                loadedCards[currentCardIndex].userInteractionEnabled = false
            }
//            self.view.userInteractionEnabled = false
            
        }
    }
    
    
    
    
}

