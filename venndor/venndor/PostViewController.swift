//
//  PostViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-10.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl! = UIPageControl()
    var pageNum: Int!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var itemDescription: UITextView!
    var itemName: UITextField!
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    var imageView4: UIImageView!
    var imageView5: UIImageView!
    var imageViewArray: [UIImageView]!
    var currentImgView: UIImageView!
    var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupItemName()
        setupItemDescription()
        sideMenuGestureSetup()
        setupImageViews()
        setupScrollView()
        setupPostButton()
        addHeader()
    }
    
    //setup functions
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let scrollViewWidth: CGFloat = scrollView.frame.width
        let scrollViewHeight: CGFloat = scrollView.frame.height
        scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*3)
        scrollView.decelerationRate = 0.1
        pageControl.currentPage = 0
        containerView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight*3)
        

        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }
    
    func setupItemName() {
        itemName = ItemNameTextField(frame: CGRectMake(10, screenSize.height + 80, screenSize.width*0.95, 30))
        itemName.text = "Name"
        itemName.delegate = self
        itemName.clearsOnBeginEditing = true
        containerView.addSubview(itemName)
        createBoarder(itemName)
        itemName.returnKeyType = .Done

    }
    
    func setupItemDescription() {
        itemDescription = UITextView(frame: CGRectMake(10, screenSize.height*2 + 120, self.screenSize.width*0.95, 100))
        itemDescription.text = "Description"
        itemDescription.delegate = self
        containerView.addSubview(itemDescription)
        createBoarder(itemDescription)
        itemDescription.returnKeyType = .Done
    }

    
    func setupImageViews() {
        

        imageView1 = createImgView(CGRectMake(screenSize.width*0.15, screenSize.height*0.13, screenSize.width*0.7, screenSize.width*0.7), action: "imageTapped:", superView: containerView)
        imageView2 = createImgView(CGRectMake(screenSize.width*0.15, screenSize.height*0.55, screenSize.width*0.3, screenSize.width*0.3), action: "imageTapped:", superView: containerView)
        imageView3 = createImgView(CGRectMake(screenSize.width*0.55, screenSize.height*0.55, screenSize.width*0.3, screenSize.width*0.3), action: "imageTapped:", superView: containerView)
        imageView4 = createImgView(CGRectMake(screenSize.width*0.15, screenSize.height*0.75, screenSize.width*0.3, screenSize.width*0.3), action: "imageTapped:", superView: containerView)
        imageView5 = createImgView(CGRectMake(screenSize.width*0.55, screenSize.height*0.75, screenSize.width*0.3, screenSize.width*0.3), action: "imageTapped:", superView: containerView)

        imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5]
    
    }

    
    func setupPostButton() {
        let buttonFrame = CGRectMake(screenSize.width*0.4, screenSize.height*2.7, screenSize.width*0.2, screenSize.height*0.1)
        postButton = makeTextButton("Post!", frame: buttonFrame, target: "postItem:")
        containerView.addSubview(postButton)
    }
    
    //delegate functions
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        adjustPage()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        adjustPage()
    }
    
    func adjustPage() {
        // Test the offset and calculate the current page after scrolling ends
        let pageHeight:CGFloat = CGRectGetHeight(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/3)/pageHeight)+1
        // Change the indicator
        pageNum = Int(currentPage)
        self.pageControl.currentPage = pageNum
        
        switch pageNum {
        case 0:
            print("page 0")
        case 1:
            print("page 1")
        case 2:
            print("page 2")
        default:
            break
        }
        
        for y in 0...6 {
            if y == Int(currentPage) {
                let yOffset = CGPointMake(0, pageHeight*CGFloat(y));
                self.scrollView.setContentOffset(yOffset, animated: true)
            }
        }
    }
    
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
    
    func imageTapped(sender: AnyObject) {
        currentImgView = sender.view as! UIImageView
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        currentImgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //button targets
    
    func postItem(sender: UIButton) {
        print("Post button hit!")
        if let name = itemName.text, details = itemDescription.text {
            var images = [UIImage]()
            for imgView in imageViewArray {
                if let img = imgView.image {
                    images.append(img)
                }
            }
            
            let item = Item(name: name, description: details, owner: LocalUser.user.id, photos: images)
            let manager = ItemManager()
            manager.createItem(item) { error in
                guard error == nil else {
                    print("GOOD FUCKING JOB BUDDY YOU BROKE EVERYTHING i fucking hate u")
                    return
                }
                print("YAAAAA BOYZ")
            }
        }
    }
}