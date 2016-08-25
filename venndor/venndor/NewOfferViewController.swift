//
//  NewOfferViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-08-25.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class NewOfferViewController: UIViewController, UITextFieldDelegate {
    
    //screen size for future reference
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var offeredItem: Item!
    var itemImage: UIImage!
    
    var offerInput: UITextField!
    
    var offer: Double!
    var sessionStart: NSDate!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "OfferViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered the offer screen."
        sessionStart = NSDate()
        
        itemImage = offeredItem.photos![0]
        
        setupBackButton()
        setupBackground()
        setupHint()
        setupPriceInput()
        setupQuestion()
        setupOfferButton()
        
        hideKeyboardWhenTappedAround()
    }

    //to setup the page background to be the items image TO BE DONE
    func setupBackground() {
        self.view.backgroundColor = UIColorFromHex(0x1abc9c)
        
        //setup profile picture frame
        let frame = CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height * 0.2, width: 100, height: 100)
        let imageView = UIImageView(frame: frame)
        
        //setup profile image
        imageView.image = itemImage
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
    }
    
    func setupQuestion() {
        let questionFrame = CGRect(x: 0, y: screenSize.height*0.12, width: screenSize.width, height: 40)
        let question = customLabel(questionFrame, text: "How much would you pay?", color: UIColor.whiteColor(), fontSize: 18)
        self.view.addSubview(question)
    }
    
    func setupOfferButton() {
        let offerButtonFrame = CGRect(x: screenSize.width*0.02, y: screenSize.height*0.88, width: screenSize.width*0.96, height: screenSize.height*0.1)
        let offerButton = makeTextButton("Offer", frame: offerButtonFrame, target: #selector(NewOfferViewController.offer(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: true, backgroundColor: UIColorFromHex(0x34495e), textSize: 24)
        offerButton.layer.cornerRadius = 10
        offerButton.layer.masksToBounds = true
        self.view.addSubview(offerButton)
    }
    
    
    //to create the back button
    func setupBackButton() {
        let buttonSize = CGRect(x: screenSize.width * 0.05, y: screenSize.height * 0.05, width: screenSize.width * 0.17, height: screenSize.width * 0.17)
        let backButton = makeImageButton("Back_Arrow.png", frame: buttonSize, target: #selector(NewOfferViewController.goBack(_:)), tinted: false, circle: true, backgroundColor: 0x000000, backgroundAlpha: 0)
        self.view.addSubview(backButton)
    }
    
    func setupHint() {
        let labelFrame = CGRect(x: 0, y: screenSize.height*0.495, width: screenSize.width, height: screenSize.height*0.07)
        let hint = customLabel(labelFrame, text: "(Offering doesn't commit you to buying)", color: UIColor.blackColor(), fontSize: 12)
        self.view.addSubview(hint)
    }
    
    func setupPriceInput() {
        
        offerInput = UITextField(frame: CGRectMake(self.screenSize.width*0.25, self.screenSize.height*0.4, self.screenSize.width*0.5, screenSize.height*0.1))
        let border = CALayer()
        let width = CGFloat(2.0)
        border.frame = CGRect(x: 0, y: offerInput.frame.size.height - width, width:  offerInput.frame.size.width, height: offerInput.frame.size.height)
        border.borderWidth = width
        border.borderColor = UIColor.whiteColor().CGColor
        offerInput.layer.addSublayer(border)
        offerInput.layer.masksToBounds = true
        offerInput.textColor = UIColor.whiteColor()
        offerInput.textAlignment = .Center
        offerInput.clearsOnBeginEditing = true
        offerInput.font = UIFont(name: "Avenir", size: 50)
        offerInput.returnKeyType = .Done
        offerInput.keyboardType = .NumberPad
        offerInput.delegate = self
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self, action: #selector(NewOfferViewController.doneButtonClicked(_:)))
        
        toolbarDone.items = [flexSpace, barBtnDone] // You can even add cancel button too
        offerInput.inputAccessoryView = toolbarDone
        
        let dollarSignFrame = CGRectMake(0, 0, offerInput.frame.width*0.2, offerInput.frame.height)
        let dollarSign = customLabel(dollarSignFrame, text: "$", color: UIColor.whiteColor(), fontSize: 50)
        offerInput.addSubview(dollarSign)
        
        self.view.addSubview(offerInput)
    }
    
    func doneButtonClicked(sender: AnyObject) {
        offerInput.resignFirstResponder()
    }
    
    func offer(sender: UIButton) {
        offer = Double(offerInput.text!)
        var tempOffer = 0
        if offer != nil {
            tempOffer = Int(offer)
        }
        let offered = Double(tempOffer)
        
        //update item metrics
        offeredItem.offersMade.append(offered)
        offeredItem.setAverageOffer()
        ItemManager.globalManager.updateItemById(offeredItem.id, update: ["offersMade": offeredItem.offersMade, "avgOffer": offeredItem.avgOffer]) { error in
            guard error == nil else {
                print("Error updating offered item: \(error)")
                return
            }
        }
        
        let posted = Double(offeredItem.minPrice)
        let matchController = jonasBoettcherController()
        let temp = matchController.calculateMatchedPrice(offered, posted: posted, item: offeredItem)
        
        //temp for initial release matching controller
        
        if temp[0] != 0.00 {
            let matchControllerView = PopUpViewControllerSwift()
            matchControllerView.ovc = self
            matchControllerView.matchedItem = offeredItem
            matchControllerView.matchedPrice = Int(temp[0] + temp[1])
            matchControllerView.showInView(self.view, price: Int(temp[0] + temp[1]), item: offeredItem)
        }
        else {
            LocalUser.seenPosts[offeredItem.id] = NSDate()
            LocalUser.user.mostRecentAction = "Made an offer on an item."
            let popup = PopoverViewController()
            popup.showInView(self.view, message: "No match, item will reappear in an hour!")
            self.performSegueWithIdentifier("offerToBrowse", sender: self)
        }
    }
    
    //segue to return to browsing
    func goBack(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.performSegueWithIdentifier("offerToBrowse", sender: self)
        }
    }
    
    
    func goBackToBrowse() {
        
        LocalUser.seenPosts[offeredItem.id] = NSDate()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.performSegueWithIdentifier("offerToBrowse", sender: self)
        }
        
    }
    
    func toMatches() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.performSegueWithIdentifier("offerToMatches", sender: self)
            
        }
    }
    
    func toBuy() {
        
    }
    
}