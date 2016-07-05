//
//  DraggableViewBackground.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

public class DraggableViewBackground: UIView, DraggableViewDelegate {
//    var currentCategory: String?
    
    var exampleCardLabels: [Item]!
    var allCards: [DraggableView]!

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let bvc = BrowseViewController()
    
//    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height*0.7
    let CARD_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width*0.9
    var MAX_BUFFER_SIZE: Int!

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    
    var itemName: UILabel!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        exampleCardLabels = GlobalItems.items
        MAX_BUFFER_SIZE = exampleCardLabels.count
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
    }
    
    init(frame: CGRect, category: String) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        exampleCardLabels = GlobalItems.items
        MAX_BUFFER_SIZE = exampleCardLabels.count
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        print(currentCategory)
        self.loadCards()
    }

    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)

//        xButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 35, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
//        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
//        xButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)
//
//        checkButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 85, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
//        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
//        checkButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
//
//        self.addSubview(xButton)
//        self.addSubview(checkButton)
    }
    
    func createDraggableViewFromItem(item: Item) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT), item: item)
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.information.text = item.name
        draggableView.delegate = self
        setupItemInfo(item)
        return draggableView

    }

    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2.8, CARD_WIDTH, CARD_HEIGHT), item: exampleCardLabels[index])
        draggableView.layer.cornerRadius = 20
        draggableView.layer.masksToBounds = true
        draggableView.information.text = exampleCardLabels[index].name
        draggableView.delegate = self
        setupItemInfo(exampleCardLabels[index])
        return draggableView
    }
    
    func setupItemInfo(item: Item) {
        let itemInfo = UIView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2.8 + CARD_HEIGHT, width: CARD_WIDTH, height: self.frame.height*0.1))
        itemInfo.backgroundColor = UIColor.whiteColor()
        itemInfo.layer.cornerRadius = 20
        itemInfo.layer.masksToBounds = true
        itemName = UILabel(frame: CGRect(x: itemInfo.frame.width*0.05, y: itemInfo.frame.height*0.2, width: itemInfo.frame.width, height: itemInfo.frame.height*0.6))
        itemInfo.addSubview(itemName)
        self.addSubview(itemInfo)
    }

    func loadCards() -> Void {
        if exampleCardLabels.count > 0 {
            let numLoadedCardsCap = exampleCardLabels.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : exampleCardLabels.count
            for var i = 0; i < exampleCardLabels.count; i++ {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }

            for var i = 0; i < loadedCards.count; i++ {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
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
                    print ("\(tempItem[0].id)")
                    self.allCards[0] = self.createDraggableViewFromItem(tempItem[0])
                }
            }
        }
    }

    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)

        loadedCards.append(allCards[0])
        cardsLoadedIndex = cardsLoadedIndex + 1
        self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])

        loadAnotherCard()
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
//        bvc.showOfferView()
        
        loadedCards.append(allCards[0])
        cardsLoadedIndex = cardsLoadedIndex + 1
        self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        
        loadAnotherCard()
    }

    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }

    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}