//
//  ViewController.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPopoverPresentationControllerDelegate, DraggableViewDelegate, UIGestureRecognizerDelegate {
    
    var allCards: [DraggableView]!
    var itemList: [Item]!
    
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.7
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    var MAX_BUFFER_SIZE: Int!
    
    var cardsLoadedIndex: Int!
    var currentCardIndex: Int!
    var loadedCards: [DraggableView]!

    //declare the current category so we know what cards we need to filter

    var currentCategory: String!
    var itemInfo: UIView!
    var itemName: UILabel!
    
    //variabls to help declare and set things
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var miniMatches: UIButton!
    var menuTransitionManager = MenuTransitionManager()
    let fadeOut = UIView()
    var headerView: HeaderView!
    
    var infoOpen: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        
//        let globalItems = GlobalItems()

        
        //intialize the global items in this controller
//        let globalItems = GlobalItems()
        
        /* ADD FUNCTION ON WHEN SWIPPING TO ROTATE THE GLOBAL ITEM */
        
        // Do any additional setup after loading the view, typically from a nib.	
//        let user = LocalUser.user
//        let items = GlobalItems.items
        
        
        setupView()
        setupItemInfo()
        
        
        //MiniMyMatches button at bottom of browse.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonSize = CGRect(x: screenSize.width*0.435, y: screenSize.height*0.91, width: screenSize.width*0.13, height: screenSize.width*0.13)
        miniMatches = makeImageButton("ic_menu_white.png", frame: buttonSize, target: "showAlert:", tinted: false, circle: true, backgroundColor: 0x3498db, backgroundAlpha: 1)

        self.view.addSubview(miniMatches)

        //end minimatches decleration, could use refactoring instead of ugly code
        
        
        //prepare the reveal view controller to allow swipping and side menus.
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = screenSize.width*0.3
            revealViewController().rearViewRevealWidth = screenSize.width*0.6
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        //add the headerview
        addHeader()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //code to for when the user swipes right to make an offer
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toOfferScreen") {
            let ovc = segue.destinationViewController as! OfferViewController

            ovc.offeredItem = itemList[currentCardIndex]

        }
    }
    
    func setupView() {
        self.view.backgroundColor = UIColorFromHex(0xe6f2ff, alpha: 1)
        MAX_BUFFER_SIZE = GlobalItems.items.count
        itemList = []
        allCards = []
        loadedCards = []
        currentCardIndex = 0
        cardsLoadedIndex = 0
        loadCards(GlobalItems.items)
    }
    
    //functions to create item information
    
    func updateItemInfo() {
        itemName.text = itemList[currentCardIndex].name
        print(itemList[currentCardIndex].name)
    }
    
    func setupItemInfo() {
        itemInfo = UIView(frame: CGRect(x: (self.view.frame.size.width - CARD_WIDTH)/2, y: (self.view.frame.size.height - CARD_HEIGHT)/2.8 + CARD_HEIGHT, width: CARD_WIDTH, height: self.view.frame.height*0.1))
        itemInfo.backgroundColor = UIColor.whiteColor()
        itemInfo.layer.cornerRadius = 20
        itemInfo.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        itemInfo.addGestureRecognizer(tap)
        itemName = UILabel(frame: CGRect(x: itemInfo.frame.width*0.05, y: itemInfo.frame.height*0.2, width: itemInfo.frame.width, height: itemInfo.frame.height*0.6))
        itemInfo.addSubview(itemName)
        updateItemInfo()
        infoOpen = false
        self.view.addSubview(itemInfo)
    }
    
    func handleTap(sender: AnyObject?) {
        if infoOpen == false { //open info
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.itemInfo.frame = CGRect(x: (self.view.frame.size.width - self.CARD_WIDTH)/2, y: (self.view.frame.size.height - self.CARD_HEIGHT)/2.8, width: self.CARD_WIDTH, height: self.view.frame.height*0.1 + self.CARD_HEIGHT)
                self.itemInfo.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.95)
                }) { (finished: Bool) -> Void in
            }
            infoOpen = true
        }
        else { //close info
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.itemInfo.frame = CGRect(x: (self.view.frame.size.width - self.CARD_WIDTH)/2, y: (self.view.frame.size.height - self.CARD_HEIGHT)/2.8 + self.CARD_HEIGHT, width: self.CARD_WIDTH, height: self.view.frame.height*0.1)
                self.itemInfo.backgroundColor = UIColor.whiteColor()
                }) { (finished: Bool) -> Void in
            }
            infoOpen = false
        }
        
        
    }
    
    //function to bring up mini matches bottom menu
    func showAlert(sender: UIButton) {
        
        //create the controller for the bottom menu
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // create the custom view for the bottom menu
        let rect = CGRectMake(-10, 0, alertController.view.bounds.size.width, 165.0)
        let customView = UIView(frame: rect)
        let customViewTwo = UIView(frame: CGRect(x: -10, y: 125, width: alertController.view.bounds.size.width+10, height: 75))
        customViewTwo.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)

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
    
    //functions to create dragable views
    
    func createDraggableViewFromItem(item: Item) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2.8, CARD_WIDTH, CARD_HEIGHT), item: item)
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.information.text = ""
        draggableView.delegate = self
        return draggableView
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.view.frame.size.width - CARD_WIDTH)/2, (self.view.frame.size.height - CARD_HEIGHT)/2.8, CARD_WIDTH, CARD_HEIGHT), item: GlobalItems.items[index])
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.information.text = ""
        draggableView.delegate = self
        return draggableView
    }
    
    //Dragable view delegate functions
    
    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        LocalUser.seenPosts[itemList[currentCardIndex].id] = NSDate()
        loadAnotherCard()
        nextCard()
        
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
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
                updateItemInfo()
        }
        else {
            itemInfo.removeFromSuperview()
        }
    }
    
    //loading cards
    
    //loads one new card
    func loadAnotherCard() -> Void {
        let itemManager = ItemManager()
        itemManager.retrieveMultipleItems(1, offset: cardsLoadedIndex, filter: GlobalItems.currentCategory, fields: nil) { items, error in
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
            for var i = 0; i < items.count; i++ {
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

}

