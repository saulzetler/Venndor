//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPopoverPresentationControllerDelegate, DraggableViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    var allCards: [DraggableView]!
    var itemList: [Item]!
    
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.77
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.96
    var MAX_BUFFER_SIZE: Int!
    
    var cardsLoadedIndex: Int!
    var currentCardIndex: Int!
    var loadedCards: [DraggableView]!
    var loadedInfos: [DraggableView]!

//    //variables for miniMatches
//    var tappedItem: Item!
//    var miniAlertController: UIAlertController!
    
    //declare the current category so we know what cards we need to filter
    var currentCategory: String!
    
    var itemInfo: UIView!
    var draggableInfo: DraggableView!
    var itemName: UILabel!
    var itemDescription: UILabel!
    var itemCondtion: UIView!
    var mainView: UIView!
    
    //variables to help declare and set things
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var miniMatches: UIButton!
    let fadeOut = UIView()
    var headerView: HeaderView!
    
    var infoOpen: Bool!
    var loaded: Bool!
    
    //location variables
//    let locationManager = CLLocationManager()
//    var locationAuthorized: Bool = false
    
    var sessionStart: NSDate!
    var itemsNeedingUpdates = [Item]()


    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.CurrentPage = "Browse"
        LocalUser.user.mostRecentAction = "Browsed Item Feed."
        sessionStart = NSDate()
        
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(mainView)
        
        let loadingLabelFrame = CGRect(x: 0, y: screenSize.height*0.4, width: screenSize.width, height: screenSize.height*0.2)
        let loadingLabel = customLabel(loadingLabelFrame, text: "Loading...", color: UIColorFromHex(0x34495e), fontSize: 35)
        mainView.addSubview(loadingLabel)
        
        loaded = false
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        self.revealViewController().delegate = self
        
        let filter = ItemManager.globalManager.constructFeedFilter()
        ItemManager.globalManager.retrieveMultipleItems(5, offset: nil, filter: filter, fields: nil) { items, error in
            guard error == nil else {
                print("Error retrieving items for browse feed: \(error)")
                return
            }
            
            if let items = items {
                GlobalItems.items = items
                dispatch_async(dispatch_get_main_queue()) {
                    self.setupView()
                }
            }
        }
        
        setupSellButton()
        
        //prepare the reveal view controller to allow swipping and side menus.
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.5
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
            let ovc = segue.destinationViewController as! NewOfferViewController
            ovc.offeredItem = itemList[currentCardIndex]
            
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
        dispatch_async(dispatch_get_main_queue()) { self.loadCards(GlobalItems.items) }
        
    }
    
    func setupSellButton() {
        let bottomBar = CGRect(x: screenSize.width*0.02, y: screenSize.height*0.9, width: screenSize.width*0.96, height: screenSize.height*0.08)
        let bottomBarButton = makeTextButton("POST AN ITEM", frame: bottomBar, target: #selector(BrowseViewController.toSellPage), circle: false, textColor: UIColor.whiteColor(), tinted: false, backgroundColor: UIColorFromHex(0x1abc9c), textSize: 22)
        bottomBarButton.layer.cornerRadius = 10
        bottomBarButton.layer.masksToBounds = true
        mainView.addSubview(bottomBarButton)
    }
    
    func toSellPage() {
        self.performSegueWithIdentifier("browseToPost", sender: self)
    }
    
    
   //segue & transition functions
    
    func backToSplash() {
        self.performSegueWithIdentifier("backToSplash", sender: self)
    }
   
    
    //functions to create dragable views
    
   
    func createDraggableViewFromItem(item: Item) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT), item: item)
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.delegate = self
        return draggableView
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
//        while locationAuthorized == false {
//            
//        }
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT), item: GlobalItems.items[index])
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.delegate = self
        return draggableView
    }
    
   
    
    //Dragable view delegate functions
   
    
    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        let item = itemList[currentCardIndex]
//        loadedInfos.removeAtIndex(0)
        LocalUser.seenPosts[item.id] = NSDate()
        
        //update user metrics
        LocalUser.user.mostRecentAction = "Swiped left."
        LocalUser.user.nuSwipesLeft! += 1
        LocalUser.user.nuSwipesTotal! += 1
        
        //add the item to the array of items that need updating
        item.nuSwipesLeft! += 1
        GlobalItems.itemsToUpdate.append(item)
//        
        dispatch_async(dispatch_get_main_queue()) { self.loadAnotherCard() }
//        
        nextCard()
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
//        loadedInfos.removeAtIndex(0)
        let item = itemList[currentCardIndex]
        
        //update user metrics
        LocalUser.user.mostRecentAction = "Swiped right."
        LocalUser.user.nuSwipesRight! += 1
        LocalUser.user.nuSwipesTotal! += 1
        
        //update item metrics
        item.nuSwipesRight! += 1
        
        //add the item to the array of items that need updating
        GlobalItems.itemsToUpdate.append(item)
        
        dispatch_async(dispatch_get_main_queue()) { self.loadAnotherCard() }
        nextCard()


//        self.performSegueWithIdentifier("toOfferScreen", sender: self)
    }
    
    //inserts a new card to the back of the view
    func nextCard() {
        currentCardIndex = currentCardIndex + 1
        //to avoid that backgroung thread autolayout error
        dispatch_async(dispatch_get_main_queue()) {
            self.insertNewCard()
        }
       
    }
    
    func insertNewCard() {
        if self.cardsLoadedIndex - self.currentCardIndex > 0 {
            let newCard = self.loadedCards[self.cardsLoadedIndex - self.currentCardIndex - 1]
            self.mainView.addSubview(newCard)
            self.mainView.sendSubviewToBack(newCard)
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
                    dispatch_async(dispatch_get_main_queue()) {
                        self.itemList.append(tempItem[0])
                        let newCard: DraggableView = self.createDraggableViewFromItem(tempItem[0])
                        self.loadedCards.append(newCard)
                        self.cardsLoadedIndex = self.cardsLoadedIndex + 1
                    }
                    
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
                    mainView.addSubview(loadedCards[cardsLoadedIndex])
                }
                else {
                    mainView.insertSubview(loadedCards[cardsLoadedIndex], belowSubview: loadedCards[cardsLoadedIndex - 1])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
            loaded = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "BrowseViewController")
        SeenPostsManager.globalManager.updateSeenPostsById(LocalUser.user.id) { error in
            guard error == nil else {
                print("Error updating LocalUser's seen posts: \(error)")
                return
            }
            
            print("Succesfully updated the LocalUser's seen posts.")
        }
        
        ItemManager.globalManager.updateItemMetrics(GlobalItems.itemsToUpdate) { error in
            guard error == nil else {
                print("Error updating item metrics: \(error)")
                return
            }
            print("Succesfully updated item metrics.")
            GlobalItems.itemsToUpdate = [Item]()
        }
    }
    
    //delegate functions
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            locationAuthorized = true
//            LocalUser.myLocation = location
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        // 3
//        if status == .AuthorizedWhenInUse {            
//            locationManager.startUpdatingLocation()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("an error fucked this up: \(error)")
//    }
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            mainView.userInteractionEnabled = true
            reactivate()
        } else {
            mainView.userInteractionEnabled = false
            deactivate()
        }
    }
}


/***************
 DEPRECATED: MINI MY MATCHES
 **************/

//    //function to bring up mini matches bottom menu
//    func showAlert(sender: UIButton) {
//
//        LocalUser.user.mostRecentAction = "Browsed MiniMatches."
//        //create the controller for the bottom menu
//        self.miniAlertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//
//        // create the custom view for the bottom menu
//        let rect = CGRectMake(-10, 0, self.miniAlertController.view.bounds.size.width, 165.0)
//        let customView = UIView(frame: rect)
//        let contentScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: customView.frame.width, height: customView.frame.height))
//        setupMiniContentScroll(contentScroll)
//
//        customView.addSubview(contentScroll)
//
//
//        let customViewTwo = UIView(frame: CGRect(x: -10, y: 125, width: self.miniAlertController.view.bounds.size.width+10, height: 75))
//        customViewTwo.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 1)
//
//        //create the custom cancel view for the user to quit the menu
//        //note this function also cancels when a user presses outside the frame
//        let arrowView = UIView(frame: CGRect(x: (self.miniAlertController.view.bounds.size.width)/2-23, y: 145, width: 30, height: 30))
//        arrowView.backgroundColor = UIColor(patternImage: UIImage(named: "ic_keyboard_arrow_down_white.png")!)
//
//        customView.backgroundColor = UIColorFromHex(0xe6e6e6)
//        //round the corners to look more appealing
//        customView.layer.cornerRadius = 15
//
//        self.miniAlertController.view.addSubview(customView)
//        self.miniAlertController.view.addSubview(customViewTwo)
//        self.miniAlertController.view.addSubview(arrowView)
//
//        //declare the type of alert controller
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
//        self.miniAlertController.addAction(cancelAction)
//
//        self.presentViewController(self.miniAlertController, animated: true, completion:{})
//
//    }

//    //function to create contentScrollView for MiniMyatches
//    func setupMiniContentScroll(contentScroll: UIScrollView) {
//        let scalar:Double = 6/19
//        let contentViewDimension = contentScroll.frame.width * CGFloat(scalar)
//        let contentScrollWidth = CGFloat(LocalUser.matches.count) * (contentViewDimension + CGFloat(12)) - CGFloat(12)
//        contentScroll.backgroundColor = UIColorFromHex(0x34495e)
//
//        for index in 0..<LocalUser.matches.count {
//            let match = LocalUser.matches[index]
//            MatchesManager.globalManager.retrieveMatchThumbnail(match) { img, error in
//
//                if let img = img {
//
//                    //create the mini matches views
//                    let xOrigin = index == 0 ? 12 : CGFloat(index) * contentViewDimension + (CGFloat(12) * CGFloat(index) + CGFloat(12))
//                    let contentFrame = CGRectMake(xOrigin, 10, contentViewDimension, contentViewDimension)
//
//                    //update the contentScrollView
//                    dispatch_async(dispatch_get_main_queue()) {
//                        let contentView = self.makeMiniContentView(contentFrame, image: img, matchedPrice: match.matchedPrice)
//                        contentView.match = match
//
//                        let tap = UITapGestureRecognizer(target: self, action: #selector(BrowseViewController.toggleItemInfo(_:)))
//                        contentView.addGestureRecognizer(tap)
//
//                        contentScroll.addSubview(contentView)
//                        contentScroll.contentSize = CGSizeMake(contentScrollWidth + CGFloat(16), contentScroll.frame.height)
//                    }
//                }
//
//            }
//        }
//    }

//functions to create labels and imgViews for MiniMyMatches

//    func makeMiniContentView(frame: CGRect, image: UIImage, matchedPrice: Int) -> ItemContainer {
//
//        let containerView = ItemContainer(frame: frame)
//
//        //create the item image
//        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
//        imgView.image = image
//        imgView.layer.cornerRadius = 5
//        imgView.contentMode = .ScaleAspectFill
//        imgView.layer.masksToBounds = true
//        imgView.userInteractionEnabled = true
//
//        //create the price label
//        let priceLabel = VennPriceLabel(containerView: containerView, price: matchedPrice, adjustment: nil)
//        containerView.addSubview(imgView)
//        containerView.addSubview(priceLabel)
//        return containerView
//    }

//    func toggleItemInfo(sender: UITapGestureRecognizer) {
//        let container = sender.view  as! ItemContainer
//
//        let match = container.match
//        ItemManager.globalManager.retrieveItemById(match.itemID) { item, error in
//            guard error == nil else {
//                print("Error pulling item from server in miniMatches: \(error)")
//                return
//            }
//
//            if let item = item {
//                let itemInfoViewController = ItemInfoViewController()
//                itemInfoViewController.item = item
//                itemInfoViewController.match = match
//                itemInfoViewController.isPost = false
//                itemInfoViewController.headerTitle = "Your Matches"
//                itemInfoViewController.isPost = false
//                self.miniAlertController.dismissViewControllerAnimated(true, completion: nil)
//                self.presentViewController(itemInfoViewController, animated: true, completion: nil)
//            }
//        }
//    }

////MiniMyMatches button at bottom of browse.
//let buttonSize = CGRect(x: screenSize.width*0.435, y: screenSize.height*0.91, width: screenSize.width*0.13, height: screenSize.width*0.13)
//miniMatches = makeImageButton("ic_keyboard_arrow_up_white.png", frame: buttonSize, target: #selector(BrowseViewController.showAlert(_:)), tinted: false, circle: true, backgroundColor: 0x2c3e50, backgroundAlpha: 1)
//
//miniMatches.layer.cornerRadius = 0.5 * miniMatches.bounds.size.width
//miniMatches.layer.masksToBounds = true
//
//let bottomBar = CGRect(x: 0, y: screenSize.height*0.93, width: screenSize.width, height: screenSize.height*0.07)
//let bottomBarButton = UIButton(frame: bottomBar)
//bottomBarButton.backgroundColor = UIColorFromHex(0x2c3e50)
//bottomBarButton.addTarget(self, action: #selector(BrowseViewController.showAlert(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//
//mainView.addSubview(bottomBarButton)
//
//mainView.addSubview(miniMatches)


