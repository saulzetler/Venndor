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
class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, STRatingControlDelegate, ImagePickerDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {
    
    //declare the needed variables for the page to work.
    
    //all the scrollview variables required
    var numberOfPages: CGFloat = 8
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl!
    var pageNum: Int!
    
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
    var imageViewArray: [UIImageView]!
    var currentImgView: UIImageView!
    var postButton: UIButton!
    var condition: Int!
    let pickerData = ["Furniture", "Kitchen", "Household", "Electronics", "Clothing", "Books", "Other"]
    var categoryPicker: UIPickerView!
    var ratingControl: STRatingControl!
    var imagePickerController: ImagePickerController!
    var mapView: GMSMapView!
    var currentPlace: GMSPlace!
    var myLocation: CLLocation!
    var useMyLocation: Bool!
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    var photoChoiceDisplayed = false
    var sessionStart: NSDate!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "PostViewController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionStart = NSDate()
        TimeManager.timeStamp = NSDate()
        setupPickerView()
        setupItemName()
        setupItemDescription()
        setupLabels()
        setupPriceInput()
        sideMenuGestureSetup()
        setupImageViews()
        setupScrollView()
        setupPageControll()
        setupPostButton()
        setupRatingControl()
        addHeaderOther("Sell an Item")
        setupDownArrow()
        setupMap()
        hideKeyboardWhenTappedAround()
    }
    
    //setup functions
    
    func setupDownArrow() {
        let downArrowFrame = CGRect(x: screenSize.width*0.45, y: screenSize.height*0.95, width: screenSize.width*0.1, height: screenSize.height*0.05)
        let downArrow = makeImageButton("Expand Arrow-100.png", frame: downArrowFrame, target: #selector(PostViewController.nextPage(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        self.view.addSubview(downArrow)
        self.view.bringSubviewToFront(downArrow)
    }
    
    //first function to setup the scroll view for the page.
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        scrollView.backgroundColor = UIColorFromHex(0x1abc9c)
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
        itemName = ItemNameTextField(frame: CGRectMake(10, screenSize.height*1.35, screenSize.width*0.95, screenSize.height*0.1))
        itemName.text = "Name"
        itemName.textColor = UIColor.whiteColor()
        itemName.font = itemName.font?.fontWithSize(30)
        itemName.delegate = self
        itemName.clearsOnBeginEditing = true
        containerView.addSubview(itemName)
        createBorder(itemName, color: UIColor.whiteColor())
        itemName.returnKeyType = .Done
    }
    
    //create the text field required for the user to input a basic description of the item
    func setupItemDescription() {
        itemDescription = UITextView(frame: CGRectMake(10, screenSize.height*4.18, self.screenSize.width*0.95, screenSize.height*0.3))
        itemDescription.text = "Additional Info"
        itemDescription.font = itemDescription.font?.fontWithSize(15)
        itemDescription.delegate = self
        containerView.addSubview(itemDescription)
        createBorder(itemDescription)
        itemDescription.returnKeyType = .Done
    }
    
    //create the input for the user to access their camera roll to upload a maximum of 5 photos
    func setupImageViews() {
        
        //each view performs the same action/function in allowing a user to upload an image, thus it is refactored to allow for neater code
        
        imageView1 = createImgView(CGRectMake(screenSize.width*0.15, screenSize.height*0.13, screenSize.width*0.7, screenSize.width*0.7), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor())
        imageView1.tag = 0
        imageView2 = createImgView(CGRectMake(screenSize.width*0.15, screenSize.height*0.55, screenSize.width*0.3, screenSize.width*0.3), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor())
        imageView2.tag = 1
        imageView3 = createImgView(CGRectMake(screenSize.width*0.55, screenSize.height*0.55, screenSize.width*0.3, screenSize.width*0.3), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor())
        imageView3.tag = 2
        imageView4 = createImgView(CGRectMake(screenSize.width*0.15, screenSize.height*0.75, screenSize.width*0.3, screenSize.width*0.3), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor())
        imageView4.tag = 3
        imageView5 = createImgView(CGRectMake(screenSize.width*0.55, screenSize.height*0.75, screenSize.width*0.3, screenSize.width*0.3), action: #selector(PostViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor())
        imageView5.tag = 4
        
        //store the image views in an array for easier future use
        imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5]
        
    }
    
    //function to allow the user to pick from a certain list of categories to assign the item.
    func setupPickerView() {
        categoryPicker = UIPickerView(frame: CGRectMake(10, screenSize.height*2.2, self.screenSize.width*0.95, screenSize.height*0.4))
        
        //asign the needed points to allow the pickerview to function as intended
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        containerView.addSubview(categoryPicker)
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    //setup rating control
    func setupRatingControl() {
        ratingControl = STRatingControl(frame: CGRectMake(screenSize.width*0.11, screenSize.height*3.2, screenSize.width, screenSize.height*0.08))
        ratingControl.delegate = self
        ratingControl.layoutSubviews()
        containerView.addSubview(ratingControl)
    }
    
    /***********************************************************
    ALL GOOGLE MAPS IMPLEMENTATION IS HERE
    ***********************************************************/
    
    func setupMap() {
        mapView = GMSMapView(frame: CGRectMake(0, screenSize.height*5.2, screenSize.width, screenSize.height*0.5))
        mapView.backgroundColor = UIColorFromHex(0xecf0f1)
        containerView.addSubview(mapView)
        
        let currentLocationButton = makeImageButton("use_current_location.png", frame: CGRectMake(screenSize.width*0.15, screenSize.height*5.75, self.screenSize.width*0.7, self.screenSize.height*0.1), target: #selector(PostViewController.curLocationClicked(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0.0)
        
        containerView.addSubview(currentLocationButton)
        
        let searchImageButton = makeImageButton("Search Filled-100.png", frame: CGRectMake(screenSize.width*0.85, screenSize.height*5.12, self.screenSize.width*0.1, self.screenSize.width*0.1), target: #selector(PostViewController.searchClicked(_:)), tinted: false, circle: true, backgroundColor: 0x000000, backgroundAlpha: 0.0)
        
        containerView.addSubview(searchImageButton)
        
        //to get the users location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        useMyLocation = true
    }
    
    func curLocationClicked(sender: UIButton) {
        print("curLoc")
        mapView.clear()
        mapView.animateToLocation(myLocation.coordinate)
//        mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let pin = GMSMarker(position: myLocation.coordinate)
        pin.appearAnimation = kGMSMarkerAnimationPop
        pin.map = mapView
        useMyLocation = true
        
    }
    
    func searchClicked(sender: UIButton) {
        print("seach clicked")
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    
    //delegate functions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            myLocation = location
            
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
        let buttonFrame = CGRectMake(screenSize.width*0.3, screenSize.height*7.3, screenSize.width*0.4, screenSize.height*0.4)
        postButton = makeTextButton("Post!", frame: buttonFrame, target: #selector(PostViewController.postItem(_:)))
        postButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        postButton.titleLabel!.font = postButton.titleLabel!.font.fontWithSize(40)
        containerView.addSubview(postButton)
    }
    
    //this function is created to setup the page control image in the bottom left hand corner.
    func setupPageControll() {
        pageControl = UIPageControl(frame: CGRectMake(screenSize.width*0.005, screenSize.height*0.87, screenSize.width*0.17, screenSize.height*0.03))
        //rotate the page control image to allow for a more intuitive visual
        pageControl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        pageControl.addTarget(self, action: #selector(PostViewController.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
        pageControl.numberOfPages = Int(scrollView.contentSize.height/screenSize.height)
        pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColorFromHex(0x3498db, alpha: 1)
        self.view.addSubview(pageControl)
    }
    
    func setupPriceInput() {
        priceField = UITextField(frame: CGRectMake(self.screenSize.width*0.2, self.screenSize.height*6.3, self.screenSize.width*0.6, screenSize.height*0.1))
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: priceField.frame.size.height - width, width:  priceField.frame.size.width, height: priceField.frame.size.height)
        
        border.borderWidth = width
        border.borderColor = UIColor.whiteColor().CGColor
        priceField.layer.addSublayer(border)
        priceField.layer.masksToBounds = true
        
        priceField.textColor = UIColor.whiteColor()
        priceField.textAlignment = .Center
        priceField.clearsOnBeginEditing = true
        priceField.font = priceField.font?.fontWithSize(50)
        priceField.returnKeyType = .Done
        priceField.keyboardType = .NumberPad
        
        let dollarSign = UILabel(frame: CGRectMake(0, 0, priceField.frame.width*0.2, priceField.frame.height))
        dollarSign.text = "$"
        dollarSign.textColor = UIColor.whiteColor()
        dollarSign.font = dollarSign.font.fontWithSize(50)
        priceField.addSubview(dollarSign)
        
        containerView.addSubview(priceField)
    }
    
    //function to setup the various labels/titles needed for each page to help direct the user.
    func setupLabels() {
        let photosLabel = UILabel(frame: CGRectMake(10, screenSize.height*0.2, self.screenSize.width*0.95, 30))
        photosLabel.text = "Photos"
//        containerView.addSubview(photosLabel)
        let nameLabel = UILabel(frame: CGRectMake(10, screenSize.height*1.1, screenSize.width*0.95, screenSize.height*0.2))
        nameLabel.text = "What is the name of your item?"
        nameLabel.numberOfLines = 0
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        nameLabel.font = nameLabel.font.fontWithSize(30)
        containerView.addSubview(nameLabel)
        let categoriesLabel = UILabel(frame: CGRectMake(10, screenSize.height*2.2, self.screenSize.width*0.95, 30))
        categoriesLabel.text = "What category does your item fit into"
        categoriesLabel.textColor = UIColor.whiteColor()
        categoriesLabel.textAlignment = .Center
        containerView.addSubview(categoriesLabel)
        let dataLabel = UILabel(frame: CGRectMake(10, screenSize.height*3.12, self.screenSize.width*0.95, 30))
        dataLabel.text = "Give some info on your item"
        dataLabel.textColor = UIColor.whiteColor()
        dataLabel.textAlignment = .Center
        dataLabel.font = dataLabel.font.fontWithSize(20)
        containerView.addSubview(dataLabel)
        let descriptionLabel = UILabel(frame: CGRectMake(10, screenSize.height*4.12, self.screenSize.width*0.95, 30))
        descriptionLabel.text = "Give a description of your item"
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.font = descriptionLabel.font.fontWithSize(20)
        containerView.addSubview(descriptionLabel)
        let addressLabel = UILabel(frame: CGRectMake(10, screenSize.height*5.1, self.screenSize.width*0.95, screenSize.height*0.1))
        addressLabel.textColor = UIColor.whiteColor()
        addressLabel.font = addressLabel.font.fontWithSize(20)
        addressLabel.text = "Where are you located?"
        containerView.addSubview(addressLabel)
        let priceLabel = UILabel(frame: CGRectMake(10, screenSize.height*6.08, self.screenSize.width*0.95, screenSize.height*0.3))
        priceLabel.text = "I want to sell this for"
        priceLabel.font = priceLabel.font.fontWithSize(30)
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.textAlignment = .Center
        priceLabel.numberOfLines = 0
        containerView.addSubview(priceLabel)
        let orMore = UILabel(frame: CGRectMake(10, screenSize.height*6.33, self.screenSize.width*0.95, screenSize.height*0.3))
        orMore.font = orMore.font.fontWithSize(30)
        orMore.textColor = UIColor.whiteColor()
        orMore.textAlignment = .Center
        orMore.text = "or more!"
        containerView.addSubview(orMore)
        let confirmLabel = UILabel(frame: CGRectMake(10, screenSize.height*7.2, self.screenSize.width*0.95, 30))
        confirmLabel.text = "Confirm Post"
//        containerView.addSubview(confirmLabel)
    }
    
    //delegate functions that control parts of the view controller
    
    func didSelectRating(control: STRatingControl, rating: Int) {
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
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/4)/pageHeight)+1
        
        // Change the indicator
        pageNum = Int(currentPage)
        self.pageControl.currentPage = pageNum
        
        //go through the possibilties of what the current page could be
        for y in 0...7 {
            //at the correct current page correctly offset the view to fit the correct frame
            if y == Int(currentPage) {
                let yOffset = CGPointMake(0, pageHeight*CGFloat(y));
                self.scrollView.setContentOffset(yOffset, animated: true)
            }
        }
    }
    
    //text field editing delegates
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
//            print("image tag: \(imageView.tag) Start Index: \(startIndex) i: \(i)")
            if imageView.tag == startIndex {
                if i < images.count {
                    imageView.image = images[i]
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
        let y = CGFloat(pageControl.currentPage) * scrollView.frame.size.height
        scrollView.setContentOffset(CGPointMake(0, y), animated: true)
    }
    
    func nextPage(sender: UIButton) {
        pageControl.currentPage += 1
        let y = CGFloat(pageControl.currentPage) * scrollView.frame.size.height
        scrollView.setContentOffset(CGPointMake(0, y), animated: true)
    }
    
    //function to controll when the user is finished and decides to post
    func postItem(sender: UIButton) {
        
        LocalUser.user.mostRecentAction = "Posted an Item"
        //add the iamges from the image view to an array to be passed to the backend function to post an item to server
        if let name = itemName.text, details = itemDescription.text {
            var images = [UIImage]()
            for imgView in imageViewArray {
                if let img = imgView.image {
                    images.append(img)
                }
            }
            
            //get the category of the item from the picker controller
            let row = categoryPicker.selectedRowInComponent(0)
            let category = pickerData[row]
            let ownerName = "\(LocalUser.user.firstName) \(LocalUser.user.lastName)"
            
            /******************************************************************/
            /******************************************************************/
            /*NEEDS TO BE SET FROM THE DATA GATHERED BY POSTVIEWCONTROLLER*/
          
            let condition = ratingControl.rating
            if useMyLocation == true {
                coordinate = myLocation.coordinate
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
            /******************************************************************/
            /******************************************************************/
            
            //create an item object to past to the manager to create the item
            let item = Item(name: name, description: details, owner: LocalUser.user.id, ownerName: ownerName, category: category, condition: condition, latitude: latitude, longitude: longitude, photos: images, question1: question1, question2: question2, minPrice: minPrice!)
            
            //declare the item manager and then call the appropriate function to create an item
            let manager = ItemManager()
            let uManager = UserManager()
            manager.createItem(item) { error in
                guard error == nil else {
                    print("GOOD FUCKING JOB BUDDY YOU BROKE EVERYTHING i fucking hate u")
                    return
                }
                print("YAAAAA BOYZ")
                
                LocalUser.user.ads[item.id!] = "Posted"
                LocalUser.user.nuPosts! += 1
                let update : [String:AnyObject] = ["ads": LocalUser.user.ads, "nuPosts": LocalUser.user.nuPosts]
                uManager.updateUserById(LocalUser.user.id, update: update) { error in
                    guard error == nil else {
                        print("Error updating the LocalUser's ads from post screen: \(error)")
                        return
                    }
                    
                    print("Succesfully updated LocalUser's ads from post screen.")
                    self.performSegueWithIdentifier("backToBrowse", sender: self)
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