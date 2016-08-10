//
//  TextMessageComposer.swift
//  venndor
//
//  Created by Saul Zetler on 2016-08-05.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import MessageUI

class TextMessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    //Juliens phone number
    var textMessageRecipients = ["514-659-6498"] // for pre-populating the recipients list (optional, depending on your needs)
    
    func setRecipients(number: [String]) {
        self.textMessageRecipients = number
    }
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(message: String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = message
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            controller.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            controller.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            controller.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
       controller.dismissViewControllerAnimated(true, completion: nil)
    }
        
        
    

}
