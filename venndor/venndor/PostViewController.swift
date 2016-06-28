//
//  PostViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-10.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var numberOfPages: CGFloat = 7
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl!
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
    
    let pickerData = ["Furniture", "Kitchen", "Household", "Electronics", "Clothing", "Books", "Other"]
    var categoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupItemName()
        setupItemDescription()
        setupLabels()
        sideMenuGestureSetup()
        setupImageViews()
        setupScrollView()
        setupPageControll()
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
        scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight * numberOfPages)
        scrollView.decelerationRate = 0.1
        containerView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight * numberOfPages)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }
    
    func setupItemName() {
        itemName = ItemNameTextField(frame: CGRectMake(10, screenSize.height*1.5, screenSize.width*0.95, 30))
        itemName.text = "Name"
        itemName.delegate = self
        itemName.clearsOnBeginEditing = true
        containerView.addSubview(itemName)
        createBoarder(itemName)
        itemName.returnKeyType = .Done
        
    }
    
    func setupItemDescription() {
        itemDescription = UITextView(frame: CGRectMake(10, screenSize.height*4.5, self.screenSize.width*0.95, 100))
        itemDescription.text = "Additional Info"
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
    
    func setupPickerView() {
        categoryPicker = UIPickerView(frame: CGRectMake(10, screenSize.height*2.4, self.screenSize.width*0.95, screenSize.height*0.4))
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        containerView.addSubview(categoryPicker)
    }
    
    func setupPostButton() {
        let buttonFrame = CGRectMake(screenSize.width*0.4, screenSize.height*6.5, screenSize.width*0.2, screenSize.height*0.1)
        postButton = makeTextButton("Post!", frame: buttonFrame, target: "postItem:")
        containerView.addSubview(postButton)
    }
    
    func setupPageControll() {
        pageControl = UIPageControl(frame: CGRectMake(screenSize.width*0.005, screenSize.height*0.87, screenSize.width*0.17, screenSize.height*0.03))
        pageControl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        pageControl.numberOfPages = Int(scrollView.contentSize.height/screenSize.height)
        pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColorFromHex(0x3498db, alpha: 1)
        self.view.addSubview(pageControl)
    }
    
    func setupLabels() {
        let nameLabel = UILabel(frame: CGRectMake(10, screenSize.height*1.2, screenSize.width*0.95, 30))
        nameLabel.text = "What is the name of your item?"
        containerView.addSubview(nameLabel)
        let categoriesLabel = UILabel(frame: CGRectMake(10, screenSize.height*2.2, self.screenSize.width*0.95, 30))
        categoriesLabel.text = "What category does your item fit into"
        containerView.addSubview(categoriesLabel)
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
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/4)/pageHeight)+1
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
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        currentImgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //button targets
    
    func changePage(sender: AnyObject) -> () {
        let y = CGFloat(pageControl.currentPage) * scrollView.frame.size.height
        scrollView.setContentOffset(CGPointMake(0, y), animated: true)
    }
    
    func postItem(sender: UIButton) {
        print("Post button hit!")
        if let name = itemName.text, details = itemDescription.text {
            var images = [UIImage]()
            for imgView in imageViewArray {
                if let img = imgView.image {
                    images.append(img)
                }
            }
            
            let row = categoryPicker.selectedRowInComponent(0)
            let category = pickerData[row]
            
            //NEEDS TO BE SET FROM THE DATA GATHERED BY POSTVIEWCONTROLLER
            let condition = 0
            let locationX = 0.0
            let locationY = 0.0
            let minPrice = 0.0
            let question1 = ""
            let question2 = ""
            
            let item = Item(name: name, description: details, owner: LocalUser.user.id, category: category, condition: condition, locationX: locationX, locationY: locationY, photos: images, question1: question1, question2: question2, minPrice: minPrice)
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
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        myLabel.text = pickerData[row]
    }
}