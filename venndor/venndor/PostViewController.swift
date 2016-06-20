//
//  PostViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-10.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var itemDescription: UITextView!
    var itemName: UITextField!
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItemName()
        setupItemDescription()
        sideMenuGestureSetup()
        addHeader()
        setupImageViews()
    }
    
    func setupItemName() {
        itemName = UITextField(frame: CGRectMake(10, 80, self.screenSize.width*0.95, 30))
        itemName.text = "Name"
        itemName.delegate = self
        itemName.clearsOnBeginEditing = true
        self.view.addSubview(itemName)
        createBoarder(itemName)
        itemName.returnKeyType = .Done

    }
    
    func setupItemDescription() {
        itemDescription = UITextView(frame: CGRectMake(10, 120, self.screenSize.width*0.95, 100))
        itemDescription.text = "Description"
        itemDescription.delegate = self
        self.view.addSubview(itemDescription)
        createBoarder(itemDescription)
        itemDescription.returnKeyType = .Done
    }
    
    func setupImageViews() {
        imageView1 = UIImageView(frame: CGRectMake(10, 230, self.screenSize.width*0.3, self.screenSize.width*0.3))
        imageView2 = UIImageView(frame: CGRectMake(145, 230, self.screenSize.width*0.3, self.screenSize.width*0.3))
        imageView3 = UIImageView(frame: CGRectMake(280, 230, self.screenSize.width*0.3, self.screenSize.width*0.3))
        self.view.addSubview(imageView1)
        self.view.addSubview(imageView2)
        self.view.addSubview(imageView3)
        createBoarder(imageView1)
        createBoarder(imageView2)
        createBoarder(imageView3)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("image1Tapped:"))
        imageView1.userInteractionEnabled = true
        imageView2.userInteractionEnabled = true
        imageView3.userInteractionEnabled = true
        imageView1.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func createBoarder(view: UIView) {
        let boarderColor : UIColor = UIColor.blackColor()
        view.layer.borderColor = boarderColor.CGColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        itemDescription.text = ""
//    }
    
//    func textViewDidEndEditing(textView: UITextView) {
//        print("end editing")
//        
//    }
    
//    func textViewShouldEndEditing(textView: UITextView) -> Bool {
//        print("Should end Editing")
//        textView.endEditing(true)
//        return true
//    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if textField.text == "Name" {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "Name"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Description" {
        textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        if textView.text == "" {
            textView.text = "Description"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func image1Tapped(sender: UIImageView) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView1.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
}