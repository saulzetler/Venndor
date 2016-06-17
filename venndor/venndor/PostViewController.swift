//
//  PostViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-10.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var itemDescription: UITextView!
    var itemName: UITextField!
    var imageView: UIImageView!
    var postButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItemName()
        setupItemDescription()
        sideMenuGestureSetup()
        addHeader()
    }
    
    func setupItemName() {
        itemName = UITextField(frame: CGRectMake(10, 80, self.screenSize.width*0.95, 30))
        itemName.text = "Name"
        itemName.clearsOnBeginEditing = true
        self.view.addSubview(itemName)
        let boarderColor : UIColor = UIColor.blackColor()
        itemName.layer.borderColor = boarderColor.CGColor
        itemName.layer.borderWidth = 2.0
        itemName.layer.cornerRadius = 8.0
        itemName.layer.masksToBounds = true
    }
    
    func setupItemDescription() {
        itemDescription = UITextView(frame: CGRectMake(10, 120, self.screenSize.width*0.95, 100))
        itemDescription.text = "Description"
        itemDescription.delegate = self
        self.view.addSubview(itemDescription)
        let boarderColor : UIColor = UIColor.blackColor()
        itemDescription.layer.borderColor = boarderColor.CGColor
        itemDescription.layer.borderWidth = 2.0
        itemDescription.layer.cornerRadius = 8.0
        itemDescription.layer.masksToBounds = true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        itemDescription.text = ""
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
}