//
//  PostViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-10.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

//class to control the post/sell page in the application requires many delegates
class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ImagePickerDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {
    
    //declare the needed variables for the page to work.
    
    //all the scrollview variables required
    var numberOfPages: CGFloat = 8
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageNum = 0
    
    //all the various post view requirement variables
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var itemDescription: UITextView!
    var itemName: UITextField!
    var priceField: UITextField!
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    var imageView4: UIImageView!
    var imageView5: UIImageView!
    var imageView6: UIImageView!
    var imageViewArray: [UIImageView]!
    var filledImagesArray: [Int]!
    var currentImgView: UIImageView!
    var postButton: UIButton!
    var condition: Int!
    let categoryPickerData = ["Furniture", "Kitchen", "Household", "Electronics", "Clothing", "Books", "Other"]
    let yearsPickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+"]
    var pageNumArray = [UIButton]()
    var categoryPicker: UIPickerView!
    var yearsPicker: UIPickerView!
    var ratingControl: RatingControl!
    var imagePickerController: ImagePickerController!
    var mapView: GMSMapView!
    var currentPlace: GMSPlace!
    var useMyLocation: Bool!
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    var photoChoiceDisplayed = false
    var sessionStart: NSDate!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("PostViewController end: \(NSDate())")
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "PostViewController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionStart = NSDate()
        print("PostViewController start: \(sessionStart)")

        setupCategoryPickerView()
        setupYearsPickerView()
        setupItemName()
        setupItemDescription()
        setupLabels()
        setupPriceInput()
        sideMenuGestureSetup()
        setupImageViews()
        setupScrollView()
        setupDivide()
        setupPageControll()
        setupPostButton()
        setupRatingControl()
        addHeaderOther("Sell")
        setupArrows()
        setupMap()
        hideKeyboardWhenTappedAround()
        self.revealViewController().delegate = self
        filledImagesArray = []
    }
    
    //setup functions
    
    func setupArrows() {
        var downArrowFrame = CGRect(x: screenSize.width*0.4, y: screenSize.height*0.85, width: screenSize.width*0.2, height: screenSize.height*0.1)
        let downArrowOrigin = downArrowFrame.origin.y
        var upArrowFrame = CGRect(x: screenSize.width*0.4, y: screenSize.height*0.15, width: screenSize.width*0.2, height: screenSize.height*0.1)
        let upArrowOrigin = upArrowFrame.origin.y
        
        for page in 0...7 {
            switch page {
            case 0:
                addTitlesToArrows(page, upTitle: "", downTitle: "Title")
            case 1:
                addTitlesToArrows(page, upTitle: "Photos", downTitle: "Category")
            case 2:
                addTitlesToArrows(page, upTitle: "Title", downTitle: "Info")
            case 3:
                addTitlesToArrows(page, upTitle: "Category", downTitle: "Description")
            case 4:
                addTitlesToArrows(page, upTitle: "Info", downTitle: "Location")
            case 5:
                addTitlesToArrows(page, upTitle: "Description", downTitle: "Price")
            case 6:
                addTitlesToArrows(page, upTitle: "Location", downTitle: "Confirm")
            case 7:
                addTitlesToArrows(page, upTitle: "Price", downTitle: "")
            default:
                break
            }
            if page != 7 {
                downArrowFrame.origin.y = downArrowOrigin + CGFloat(page)*self.view.frame.height
                let downArrow = makeImageButton("Expand Arrow Blue.png", frame: downArrowFrame, target: #selector(PostViewController.nextPage(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
                containerView.addSubview(downArrow)
            }
            
            if page != 0 {
                upArrowFrame.origin.y = upArrowOrigin + CGFloat(page)*self.view.frame.height
                let upArrow = makeImageButton("Collapse Arrow Blue.png", frame: upArrowFrame, target: #selector(PostViewController.prevPage(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
                containerView.addSubview(upArrow)
            }
            
        }
    }
    
    func addTitlesToArrows(page: Int, upTitle: String, downTitle: String)  {
        var upButtonFrame = CGRect(x: screenSize.width*0.4, y: screenSize.height*0.1, width: screenSize.width*0.2, height: screenSize.height*0.1)
        let upButtonOrigin = upButtonFrame.origin.y
        var downButtonFrame = CGRect(x: screenSize.width*0.4, y: screenSize.height*0.9, width: screenSize.width*0.2, height: screenSize.height*0.1)
        let downButtonOrigin = downButtonFrame.origin.y
        var button: UIButton!
        if page != 0 {
            upButtonFrame.origin.y = upButtonOrigin + CGFloat(page)*screenSize.height
            button = makeTextButton(upTitle, frame: upButtonFrame, target: #selector(PostViewController.prevPage(_:)))
            containerView.addSubview(button)
        }
        if page != 7 {
            downButtonFrame.origin.y = downButtonOrigin + CGFloat(page)*screenSize.height
            button = makeTextButton(downTitle, frame: downButtonFrame, target: #selector(PostViewController.nextPage(_:)))
            containerView.addSubview(button)
        }
    }
    
    //first function to setup the scroll view for the page.
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        scrollView.backgroundColor = UIColorFromHex(0xecf0f1)
        let scrollViewWidth: CGFloat = scrollView.frame.width
        let scrollViewHeight: CGFloat = scrollView.frame.height
        
        //create the scroll view to have enough space to hold all needed content in this case 8 pages
        scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight * numberOfPages)
        scrollView.decelerationRate = 0.1
        
        //adjust the frame appropriately too
        containerView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight * numberOfPages)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }
    
    //function to set up the rating/condition of the item
    func setupCondition() {
        //the function will set the condition int variable on a scale of 1 to 5
    }
    
    //create the text field required for the user to input the name of the item.
    func setupItemName() {
        itemName = ItemNameTextField(frame: CGRectMake(screenSize.width*0.2, screenSize.height*1.4, screenSize.width*0.7, screenSize.height*0.1))
        itemName.text = "Item Name"
        itemName.textColor = UIColorFromHex(0x34495e)
        itemName.font = UIFont(name: "Avenir", size: 30)
        itemName.delegate = self
        itemName.clearsOnBeginEditing = true
        itemName.textAlignment = .Center
        containerView.addSubview(itemName)
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColorFromHex(0x34495e).CGColor
        border.frame = CGRect(x: 0, y: itemName.frame.size.height - width, width:  itemName.frame.size.width, height: itemName.frame.size.height)
        border.borderWidth = width
        itemName.layer.addSublayer(border)
        itemName.layer.masksToBounds = true
        itemName.returnKeyType = .Done
    }
    
    //create the text field required for the user to input a basic description of the item
    func setupItemDescription() {
        itemDescription = UITextView(frame: CGRectMake(screenSize.width*0.2, screenSize.height*4.3, self.screenSize.width*0.7, screenSize.height*0.25))
        itemDescription.text = "Additional Info"
        itemDescription.font = UIFont(name: "Avenir", size: 15)
        itemDescription.textColor = UIColorFromHex(0x34495e)
        itemDescription.delegate = self
        containerView.addSubview(itemDescription)
        createBorder(itemDescription, color: UIColorFromHex(0x34495e))
        itemDescription.returnKeyType = .Done
    }
    
    //create the input for the user to access their camera roll to upload a maximum of 5 photos
    func setupImageViews() {
        
        //each view performs the same action/function in allowing a user to upload an image, thus it is refactored to allow for neater code
        
        let padding = screenSize.width*0.01
        let smallImgWidth = screenSize.width*0.22
        let largeImgWidth = screenSize.width*0.45
        let originX = screenSize.width*0.2
        let originY = screenSize.height*0.3
        
        imageView1 = createImgView(CGRectMake(originX, originY, largeImgWidth, largeImgWidth), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView1.tag = 0
        imageView2 = createImgView(CGRectMake(originX+padding+largeImgWidth, originY, smallImgWidth, smallImgWidth), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView2.tag = 1
        imageView3 = createImgView(CGRectMake(originX+padding+largeImgWidth, originY+smallImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView3.tag = 2
        imageView4 = createImgView(CGRectMake(originX+padding+largeImgWidth, originY+largeImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView4.tag = 3
        imageView5 = createImgView(CGRectMake(originX+smallImgWidth+padding, originY+largeImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView5.tag = 4
        imageView6 = createImgView(CGRectMake(originX, originY+largeImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView6.tag = 5
        
        
        //store the image views in an array for easier future use
        imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6]
        
        for imgView in imageViewArray {
            imgView.image = UIImage(named: "add_main_photo.png")
        }
        
    }
    
    //function to allow the user to pick from a certain list of categories to assign the item.
    func setupCategoryPickerView() {
        categoryPicker = UIPickerView(frame: CGRectMake(screenSize.width*0.2, screenSize.height*2.38, self.screenSize.width*0.6, screenSize.height*0.4))
        
        //asign the needed points to allow the pickerview to function as intended
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.tag = 1
        containerView.addSubview(categoryPicker)
    }
    
    func setupYearsPickerView() {
        yearsPicker = UIPickerView(frame: CGRectMake(screenSize.width*0.42, screenSize.height*3.3, screenSize.width*0.17, screenSize.height*0.2))
        
        yearsPicker.dataSource = self
        yearsPicker.delegate = self
        yearsPicker.tag = 2
        containerView.addSubview(yearsPicker)
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData: String
        if pickerView.tag == 1 {
            titleData = categoryPickerData[row]
        }
        else {
            titleData = yearsPickerData[row]
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir", size: 15.0)!,NSForegroundColorAttributeName:UIColorFromHex(0x34495e)])
        return myTitle
    }
    
    //setup rating control
    func setupRatingControl() {
        ratingControl = RatingControl(frame: CGRectMake(screenSize.width*0.2, screenSize.height*3.65, screenSize.width*0.6, screenSize.height*0.07))
        containerView.addSubview(ratingControl)
    }
    
    func setupDivide() {
        let seperator = UIView(frame: CGRectMake(screenSize.width*0.2, screenSize.height*3.52, screenSize.width*0.6, 1))
        seperator.backgroundColor = UIColorFromHex(0x34495e)
        containerView.addSubview(seperator)
    }
    
    /***********************************************************
    ALL GOOGLE MAPS IMPLEMENTATION IS HERE
    ***********************************************************/
    
    func setupMap() {
        mapView = GMSMapView(frame: CGRectMake(screenSize.width*0.2, screenSize.height*5.37, screenSize.width*0.8, screenSize.height*0.25))
        mapView.backgroundColor = UIColorFromHex(0xecf0f1)
        containerView.addSubview(mapView)
        
        let currentLocationButton = makeImageButton("sell_currentlocation_button.png", frame: CGRectMake(screenSize.width*0.25, screenSize.height*5.65, screenSize.width*0.5, screenSize.height*0.1), target: #selector(PostViewController.curLocationClicked(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0.0)
        
        containerView.addSubview(currentLocationButton)
        
        let searchImageButton = makeImageButton("Search Filled-100.png", frame: CGRectMake(screenSize.width*0.27, screenSize.height*5.28, screenSize.width*0.13, screenSize.width*0.13), target: #selector(PostViewController.searchClicked(_:)), tinted: false, circle: true, backgroundColor: 0x000000, backgroundAlpha: 0.0)
        
        containerView.addSubview(searchImageButton)
        
        //to get the users location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        useMyLocation = true
    }
    
    func curLocationClicked(sender: UIButton) {
        mapView.clear()
        mapView.animateToLocation(LocalUser.myLocation.coordinate)
//        mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let pin = GMSMarker(position: LocalUser.myLocation.coordinate)
        pin.appearAnimation = kGMSMarkerAnimationPop
        pin.map = mapView
        useMyLocation = true
        
    }
    
    func searchClicked(sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    
    //delegate functions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            LocalUser.myLocation = location
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            
            // 8
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        if status == .AuthorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        currentPlace = place
        useMyLocation = false
        mapView.clear()
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismissViewControllerAnimated(true, completion: nil)
        mapView.animateToLocation(place.coordinate)
//        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let pin = GMSMarker(position: place.coordinate)
        pin.appearAnimation = kGMSMarkerAnimationPop
        pin.map = mapView
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //END OF GOOGLE MAPS IMPLEMENTATION
    
    //function to create the final post button which is called when the user completes the process.
    func setupPostButton() {
        let buttonFrame = CGRectMake(0, screenSize.height*7.85, screenSize.width, screenSize.height*0.15)
        postButton = makeTextButton("Post!", frame: buttonFrame, target: #selector(PostViewController.postItem(_:)))
        postButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        postButton.titleLabel!.font = UIFont(name: "Avenir", size: 35)
        postButton.backgroundColor = UIColorFromHex(0x34495e)
        containerView.addSubview(postButton)
    }
    
    //this function is created to setup the page control image in the bottom left hand corner.
    func setupPageControll() {
        var pageIndicatorFrame = CGRect(x: screenSize.width*0.08, y: screenSize.height*0.35, width: 15, height: 15)
        let pageIndOrigin = pageIndicatorFrame.origin.y
        for pageNum in 0...7 {
            pageIndicatorFrame.origin.y = pageIndOrigin + CGFloat(pageNum*20)
            let pageInd = makeIndicatorButton(pageIndicatorFrame, color: UIColorFromHex(0x34495e))
            pageInd.tag = pageNum
            if pageNum == 0 {
                pageInd.backgroundColor = UIColorFromHex(0x34495e)
            }
            self.view.addSubview(pageInd)
            pageNumArray.append(pageInd)
        }
        

        
        
    }
    
    func setupPriceInput() {
        priceField = UITextField(frame: CGRectMake(self.screenSize.width*0.25, self.screenSize.height*6.4, self.screenSize.width*0.5, screenSize.height*0.1))
        let border = CALayer()
        let width = CGFloat(2.0)
        border.frame = CGRect(x: 0, y: priceField.frame.size.height - width, width:  priceField.frame.size.width, height: priceField.frame.size.height)
        border.borderWidth = width
        border.borderColor = UIColorFromHex(0x34495e).CGColor
        priceField.layer.addSublayer(border)
        priceField.layer.masksToBounds = true
        
        priceField.textColor = UIColorFromHex(0x34495e)
        priceField.textAlignment = .Center
        priceField.clearsOnBeginEditing = true
        priceField.font = UIFont(name: "Avenir", size: 50)
        priceField.returnKeyType = .Done
        priceField.keyboardType = .NumberPad
        
        let dollarSignFrame = CGRectMake(0, 0, priceField.frame.width*0.2, priceField.frame.height)
        let dollarSign = customLabel(dollarSignFrame, text: "$", color: UIColorFromHex(0x34495e), fontSize: 50)
        priceField.addSubview(dollarSign)
        
        containerView.addSubview(priceField)
    }
    
    //function to setup the various labels/titles needed for each page to help direct the user.
    func setupLabels() {
        let photosLabelFrame = CGRectMake(screenSize.width*0.3, screenSize.height*0.15, screenSize.width*0.4, screenSize.height*0.15)
        let photosLabel = customLabel(photosLabelFrame, text: "Add Photos", color: UIColorFromHex(0x34495e), fontSize: 20)
        containerView.addSubview(photosLabel)
        let categoryLabel = customLabel(CGRectMake(screenSize.width*0.15, screenSize.height*2.3, self.screenSize.width*0.7, screenSize.height*0.1), text: "Pick a category", color: UIColorFromHex(0x34495e), fontSize: 25)
        containerView.addSubview(categoryLabel)
        let conditionLabel = customLabel(CGRectMake(screenSize.width*0.2, screenSize.height*3.55, self.screenSize.width*0.6, screenSize.height*0.1), text: "Condition", color: UIColorFromHex(0x34495e), fontSize: 30)
        containerView.addSubview(conditionLabel)
        let itemIs = customLabel(CGRectMake(screenSize.width*0.2, screenSize.height*3.357, self.screenSize.width*0.2, screenSize.height*0.08), text: "Item is", color: UIColorFromHex(0x34495e), fontSize: 20)
        containerView.addSubview(itemIs)
        let yearsOld = customLabel(CGRectMake(screenSize.width*0.6, screenSize.height*3.357, self.screenSize.width*0.3, screenSize.height*0.08), text: "years old", color: UIColorFromHex(0x34495e), fontSize: 20)
        containerView.addSubview(yearsOld)
        let locationLabel = customLabel(CGRectMake(screenSize.width*0.3, screenSize.height*5.27, screenSize.width*0.6, screenSize.height*0.1), text: "Location", color: UIColorFromHex(0x34495e), fontSize: 30)
        containerView.addSubview(locationLabel)
        
        let priceLabelFrame = CGRectMake(screenSize.width*0.15, screenSize.height*6.3, self.screenSize.width*0.7, screenSize.height*0.1)
        let priceLabel = customLabel(priceLabelFrame, text: "I want to sell this for", color: UIColorFromHex(0x34495e), fontSize: 25)
        priceLabel.numberOfLines = 0
        containerView.addSubview(priceLabel)
        let orMoreFrame = CGRectMake(screenSize.width*0.2, screenSize.height*6.5, self.screenSize.width*0.6, screenSize.height*0.1)
        let orMore = customLabel(orMoreFrame, text: "or more!", color: UIColorFromHex(0x34495e), fontSize: 25)
        
        containerView.addSubview(orMore)
        let confirmLabel = UILabel(frame: CGRectMake(10, screenSize.height*7.2, self.screenSize.width*0.95, 30))
        confirmLabel.text = "Confirm Post"
//        containerView.addSubview(confirmLabel)
    }
    
    //delegate functions that control parts of the view controller
    
    func didSelectRating(control: RatingControl, rating: Int) {
        print(rating)
    }
    
    //2 funcitons are called when a user scrolls through a scroll view, either drag or accelerate as such both must be overwritten to auto adjust the page to the correct one when either is called
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        adjustPage()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        adjustPage()
    }
    
    //this is the function used to automatically adjust the page to the correct one when the user scrolls through the view
    func adjustPage() {
        
        view.endEditing(true)
        // Test the offset and calculate the current page after scrolling ends
        let pageHeight:CGFloat = CGRectGetHeight(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/2)/pageHeight)+1
        
        // Change the indicator
        pageNum = Int(currentPage)
        
        //go through the possibilties of what the current page could be
        for y in 0...7 {
            //at the correct current page correctly offset the view to fit the correct frame
            if y == Int(currentPage) {
                let yOffset = CGPointMake(0, pageHeight*CGFloat(y));
                self.scrollView.setContentOffset(yOffset, animated: true)
                updateIndicators()
            }
        }
    }
    
    func updateIndicators() {
        for pageInd in pageNumArray {
            if pageInd.tag <= pageNum {
                pageInd.backgroundColor = UIColorFromHex(0x34495e)
            }
            else {
                pageInd.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    //text field editing delegates
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if textField.text == "Item Name" {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "Item Name"
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
        if textView.text == "Additional Info" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        if textView.text == "" {
            textView.text = "Additional Info"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    //end of text field delegates
    
    //IMAGE SELECTION METHODS
    
    //delegate image picker functions
    
    func wrapperDidPress(images: [UIImage]){
        print("cool")
    }
    
    func doneButtonDidPress(images: [UIImage]){
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        var i = 0
        var startIndex = currentImgView.tag
        let images = imageAssets
        for imageView in imageViewArray {
            if imageView.tag == startIndex {
                if i < images.count {
                    imageView.image = images[i]
                    if !filledImagesArray.contains(imageView.tag) {
                        filledImagesArray.append(imageView.tag)
                    }
                    i += 1
                    startIndex += 1
                }
            }
        }
    }
    func cancelButtonDidPress(){
        
    }
    
    var imageAssets: [UIImage] {
        return ImagePicker.resolveAssets(imagePickerController.stack.assets)
    }
    
    //function to control when an image view is tapped and access the camera roll
    func imageTapped(sender: UIGestureRecognizer) {
        currentImgView = sender.view as! UIImageView
        imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5 - currentImgView.tag
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    
    
    //END OF IMAGE SELECTION METHODS
    
    //controller to change the current page shown on the view controller when button pressed
    
    /* TO BE FIXED */
    
    func changePage(sender: AnyObject) -> () {
        let y = CGFloat(pageNum) * scrollView.frame.size.height
        scrollView.setContentOffset(CGPointMake(0, y), animated: true)
        
    }
    
    func nextPage(sender: UIButton) {
        pageNum += 1
        let y = CGFloat(pageNum) * scrollView.frame.size.height
        scrollView.setContentOffset(CGPointMake(0, y), animated: true)
        updateIndicators()
    }
    
    func prevPage(sender: UIButton) {
        pageNum -= 1
        let y = CGFloat(pageNum) * scrollView.frame.size.height
        scrollView.setContentOffset(CGPointMake(0, y), animated: true)
        updateIndicators()
    }
    
    //function to controll when the user is finished and decides to post
    func postItem(sender: UIButton) {
        
        LocalUser.user.mostRecentAction = "Posted an Item"
        //add the iamges from the image view to an array to be passed to the backend function to post an item to server
        if let name = itemName.text, details = itemDescription.text {
            var images = [UIImage]()
            for imgView in imageViewArray {
                if filledImagesArray.contains(imgView.tag) {
                    if let img = imgView.image {
                        images.append(img)
                    }
                }
            }
            
            //get the category of the item from the picker controller
            let row = categoryPicker.selectedRowInComponent(0)
            let category = categoryPickerData[row]
            let ownerName = "\(LocalUser.user.firstName) \(LocalUser.user.lastName)"
            
            /******************************************************************/
            /******************************************************************/
            /*NEEDS TO BE SET FROM THE DATA GATHERED BY POSTVIEWCONTROLLER*/
          
            let condition = ratingControl.rating
            if useMyLocation == true {
                coordinate = LocalUser.myLocation.coordinate
            }
            else {
                coordinate = currentPlace.coordinate
            }
            let latitude = Double(coordinate.latitude)
            let longitude = Double(coordinate.longitude)
            let minPrice = Int(priceField.text!)
            
            let question1 = ""
            let question2 = ""
            
            var conversion = LocationConverter()
            let geoHash = conversion.coordToGeo(latitude, longitudeInput: longitude)
            print ("THIS IS THE CURRENT GEOHASH YOU GETTING DAWG: " + geoHash)
            
            //create an item object to past to the manager to create the item
            let item = Item(name: name, description: details, owner: LocalUser.user.id, ownerName: ownerName, category: category, condition: condition, latitude: latitude, longitude: longitude, geoHash: geoHash, photos: images, question1: question1, question2: question2, minPrice: minPrice!)
            
            //create the item object on the server
            ItemManager.globalManager.createItem(item) { error in
                guard error == nil else {
                    print("GOOD FUCKING JOB BUDDY YOU BROKE EVERYTHING i fucking hate u")
                    return
                }
                
                //create the post object on the server
                let post = Post(itemID: item.id!, itemName: item.name, itemDescription: item.details, userID: item.owner, minPrice: item.minPrice, itemLongitude: item.longitude, itemLatitude: item.latitude)
                
                PostManager.globalManager.createPost(post) { post, error in
                    LocalUser.user.posts[post!.id] = item.id
                    LocalUser.user.nuPosts! += 1
                    LocalUser.posts.append(post!)

                    let update : [String:AnyObject] = ["posts": LocalUser.user.posts, "nuPosts": LocalUser.user.nuPosts]
                    UserManager.globalManager.updateUserById(LocalUser.user.id, update: update) { error in
                        guard error == nil else {
                            print("Error updating the LocalUser's posts from post screen: \(error)")
                            return
                        }
                        
                        print("Succesfully updated LocalUser's ads from post screen.")
                        self.performSegueWithIdentifier("backToBrowse", sender: self)
                    }
                
                }
            }
        }
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return categoryPickerData.count
        }
        else {
            return yearsPickerData.count
        }
        
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return categoryPickerData[row]
        }
        else {
            return yearsPickerData[row]
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        myLabel.text = pickerData[row]
    }
    
    
    //deactivation methods
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            containerView.userInteractionEnabled = true
            reactivate()
        } else {
            containerView.userInteractionEnabled = false
            deactivate()
        }
    }
}