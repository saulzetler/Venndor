//
//  BuyViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-08-03.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class BuyViewController: UIViewController {
    var seller: User!
    var match: Match!
    
    var popupView: UIView!
    var messageButton: UIButton!
    var closeButton: UIButton!
    var sellerNameLabel : UILabel!
    var itemLabel: UILabel!
    var sellerPhotoView: UIImageView!
    
    let messageComposer = TextMessageComposer()
    
    override func viewDidLoad() {
    
        print("Buy Presented!")
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.view.backgroundColor = UIColor.clearColor()
            self.view.alpha = 0.5
            let view = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.blackColor()
            view.alpha = 0.5
            
            self.view.addSubview(view)
            self.setupPopupView()
            self.setupCloseButton()
            self.setupMessageButton()
            self.setupItemLabel()
            self.setupSellerPhoto()
            self.setupSellerLabel()
        }
       
    }
    
    func setupPopupView() {
       popupView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 150, y: self.view.frame.height / 2 - 150, width: 300, height: 240))
       popupView.layer.cornerRadius = 10
       popupView.backgroundColor = UIColor.whiteColor()
       popupView.layer.shadowColor = UIColor.blackColor().CGColor
       popupView.layer.shadowOpacity = 0.6
       popupView.layer.shadowRadius = 15
       popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
       popupView.layer.masksToBounds = false
    
       self.view.addSubview(popupView)
    }
    
    func setupMessageButton() {
        
        //setup the button
        let buttonFrame = CGRect(x: 0, y: popupView.frame.size.height * 0.75, width: popupView.frame.size.width, height: popupView.frame.size.height * 0.3)
        let roundFrame = CGRect(x: 0, y: popupView.frame.size.height * 0.75, width: popupView.frame.size.width, height: popupView.frame.size.height * 0.35)
        
        let roundView = UIView(frame: roundFrame)
        roundView.backgroundColor = UIColorFromHex(0x1abc9c)
        roundView.clipsToBounds = true
        roundView.layer.cornerRadius = 10
        popupView.addSubview(roundView)
        
        messageButton = UIButton(frame: buttonFrame)
        messageButton.backgroundColor = UIColorFromHex(0x1abc9c)
        messageButton.setTitle("  Message Seller", forState: .Normal)
        messageButton.titleLabel?.textColor = UIColor.whiteColor()
        messageButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 40)
        
        //create the rounded button image
        
        //set the rounded button image and its insets
        
        messageButton.setImage(UIImage(named: "Speech Bubble.png"), forState: .Normal)
        messageButton.imageView?.clipsToBounds = true
        messageButton.imageView?.layer.masksToBounds = false
        messageButton.imageView?.layer.cornerRadius = messageButton.imageView!.frame.height / 2
        
        messageButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 70, bottom: 5, right: 180)

        messageButton.addTarget(self, action: #selector(BuyViewController.messageSeller), forControlEvents: .TouchUpInside)
        
        //round the bottom 2 corners 
        
        popupView.addSubview(messageButton)
    }
    
    func setupCloseButton() {
        let buttonFrame = CGRect(x: popupView.frame.width - 35, y: -9, width: 45, height: 45)
        closeButton = makeImageButton("Cancel-48.png", frame: buttonFrame, target: #selector(BuyViewController.dismissController), tinted: false, circle: false, backgroundColor: 12, backgroundAlpha: 0)
        closeButton.imageView?.contentMode = .ScaleAspectFill
        self.popupView.addSubview(closeButton)
    }
    
    func setupSellerPhoto() {
        let sellerPhotoWidth = popupView.frame.width * 0.32
        let sellerPhotoFrame = CGRect(x: popupView.frame.width * 0.18, y: popupView.frame.width * 0.20, width: sellerPhotoWidth, height: sellerPhotoWidth)
        sellerPhotoView = UIImageView(frame: sellerPhotoFrame)
        let link = NSURL(string: seller.profilePictureURL)
        let sellerPhotoData = NSData(contentsOfURL: link!)
        sellerPhotoView.image = UIImage(data: sellerPhotoData!)
        sellerPhotoView.layer.masksToBounds = false
        sellerPhotoView.layer.cornerRadius = sellerPhotoView.frame.size.width / 2
        sellerPhotoView.clipsToBounds = true
        sellerPhotoView.contentMode = .ScaleAspectFill
        popupView.addSubview(sellerPhotoView)

    }
    
    func setupSellerLabel() {
        let sellerLabelFrame = CGRect(x: popupView.frame.width * 0.45, y: popupView.frame.height * 0.3, width: popupView.frame.width * 0.55, height: popupView.frame.height * 0.3)
        sellerNameLabel = UILabel(frame: sellerLabelFrame)
        let lastInitial = seller.lastName.substringToIndex(seller.lastName.startIndex.advancedBy(1))
        let sellerName = "\(seller.firstName) \(lastInitial)"
        sellerNameLabel.text = sellerName
        sellerNameLabel.textAlignment = .Center
        sellerNameLabel.font = sellerNameLabel.font.fontWithSize(20)
        popupView.addSubview(sellerNameLabel)
        
    }
    
    func setupItemLabel() {
        let labelFrame = CGRect(x: 0, y: popupView.frame.height * 0.05, width: popupView.frame.width, height: popupView.frame.height * 0.15)
        itemLabel = UILabel(frame: labelFrame)
        itemLabel.text = "\(match.itemName) - $\(match.matchedPrice)"
        itemLabel.textAlignment = .Center
        itemLabel.font = UIFont.boldSystemFontOfSize(20)
        popupView.addSubview(itemLabel)
    }
    
    func dismissController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageSeller() {
        print("Message tapped!")
        
        if (messageComposer.canSendText()) {
            UserManager.globalManager.retrieveUserById(match.sellerID) { user, error in
                guard error == nil else {
                    print("Error retrieving seller in Buy screen: \(error)")
                    return
                }
                
                if let user = user {
                   self.messageComposer.setRecipients([user.phoneNumber])
                    
                    // Obtain a configured MFMessageComposeViewController
                    let messageComposeVC = self.messageComposer.configuredMessageComposeViewController("\(LocalUser.firstName) wants to buy your item \(self.match.itemName) for $\(self.match.matchedPrice)")
                    
                    // Present the configured MFMessageComposeViewController instance
                    // Note that the dismissal of the VC will be handled by the messageComposer instance,
                    // since it implements the appropriate delegate call-back
                    self.presentViewController(messageComposeVC, animated: true, completion: nil)
                }
            }
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
}