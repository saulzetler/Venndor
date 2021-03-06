//
//  PostView.swift
//  venndor
//
//  Created by Saul Zetler on 2016-08-08.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

/*

class PostView: UIView, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, RatingControlDelegate {
    
    //declare the needed variables for the page to work.
    
    let evc = EditViewController()
    
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
    
    //imgViews
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    var imageView4: UIImageView!
    var imageView5: UIImageView!
    var imageView6: UIImageView!
    var imageViewArray: [UIImageView]!
    var previewImageViewArray: [UIImageView]!
    var filledImagesArray: [Int]!
    var currentImgView: UIImageView!
    
    var previewName: UIButton!
    var previewCategory: UIButton!
    var previewYears: UIButton!
    var previewCondition: UIButton!
    var previewDescription: UIButton!
    var previewLocation: UIButton!
    var previewPrice: UIButton!
    var ratingPreviewContainer: UIView!
    var descriptionContainer: UIView!
    
    
    var postButton: UIButton!
    var condition: Int!
    let categoryPickerData = ["Furniture", "Kitchen", "Household", "Electronics", "Clothing", "Books", "Other"]
    let yearsPickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+"]
    var pageNumArray = [UIButton]()
    var categoryPicker: UIPickerView!
    var yearsPicker: UIPickerView!
    
    var ratingControl: RatingControl!
    var mapView: GMSMapView!
    var currentPlace: GMSPlace!
    var useMyLocation: Bool!
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    var photoChoiceDisplayed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCategoryPickerView()
        setupYearsPickerView()
        setupItemName()
        setupItemDescription()
        setupLabels()
        setupPriceInput()
        setupImageViews()
        setupScrollView()
        setupDivide()
        setupPageControll()
        setupPostButton()
        setupRatingControl()
        setupArrows()
        setupMap()
        setPreviewItemName()
        setCategoryPreview()
        setYearsPreview()
        setDescriptionPreview()
        setInitialCondition()
        setLocationPreview()
        setPricePreview()
        filledImagesArray = []
        previewImageViewArray = []
        self.ratingControl.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
                downArrowFrame.origin.y = downArrowOrigin + CGFloat(page)*screenSize.height
                let downArrow = makeImageButton("Expand Arrow Blue.png", frame: downArrowFrame, action: #selector(EditViewController.nextPage(_:)), target: evc, tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
                containerView.addSubview(downArrow)
            }
            
            if page != 0 {
                upArrowFrame.origin.y = upArrowOrigin + CGFloat(page)*screenSize.height
                let upArrow = makeImageButton("Collapse Arrow Blue.png", frame: upArrowFrame, action: #selector(EditViewController.prevPage(_:)), target: evc, tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
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
            button = makeTextButton(upTitle, frame: upButtonFrame, action: #selector(EditViewController.prevPage(_:)), target: evc, textColor: UIColorFromHex(0x34495e))
            containerView.addSubview(button)
        }
        if page != 7 {
            downButtonFrame.origin.y = downButtonOrigin + CGFloat(page)*screenSize.height
            button = makeTextButton(downTitle, frame: downButtonFrame, action: #selector(EditViewController.nextPage(_:)), target: evc, textColor: UIColorFromHex(0x34495e))
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
        self.addSubview(scrollView)
    }
    
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
        itemDescription.tag = 105
        itemDescription.text = "Additional Info"
        itemDescription.font = UIFont(name: "Avenir", size: 15)
        itemDescription.textColor = UIColorFromHex(0x34495e)
        itemDescription.delegate = self
        containerView.addSubview(itemDescription)
        createBorder(itemDescription, color: UIColorFromHex(0x34495e))
        itemDescription.returnKeyType = .Done
    }
    
    func setupImageViews() {
        
        //each view performs the same action/function in allowing a user to upload an image, thus it is refactored to allow for neater code
        
        let padding = screenSize.width*0.01
        let smallImgWidth = screenSize.width*0.22
        let largeImgWidth = screenSize.width*0.45
        let originX = screenSize.width*0.2
        let originY = screenSize.height*0.3
        
        imageView1 = createImgView(CGRectMake(originX, originY, largeImgWidth, largeImgWidth), action: #selector(EditViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView1.tag = 0
        imageView2 = createImgView(CGRectMake(originX+padding+largeImgWidth, originY, smallImgWidth, smallImgWidth), action: #selector(EditViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView2.tag = 1
        imageView3 = createImgView(CGRectMake(originX+padding+largeImgWidth, originY+smallImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(EditViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView3.tag = 2
        imageView4 = createImgView(CGRectMake(originX+padding+largeImgWidth, originY+largeImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(EditViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView4.tag = 3
        imageView5 = createImgView(CGRectMake(originX+smallImgWidth+padding, originY+largeImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(EditViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
        imageView5.tag = 4
        imageView6 = createImgView(CGRectMake(originX, originY+largeImgWidth+padding, smallImgWidth, smallImgWidth), action: #selector(EditViewController.imageTapped(_:)), superView: containerView, boarderColor: UIColor.whiteColor(), boardered: false)
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
    
    //function to create the final post button which is called when the user completes the process.
    func setupPostButton() {
        let buttonFrame = CGRectMake(0, screenSize.height*7.9, screenSize.width, screenSize.height*0.1)
        postButton = makeTextButton("Post!", frame: buttonFrame, action: #selector(EditViewController.postItem(_:)), target: evc)
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
            pageIndicatorFrame.origin.y = pageIndOrigin + CGFloat(pageNum*25)
            let pageInd = makeIndicatorButton(pageIndicatorFrame, color: UIColorFromHex(0x34495e), target: #selector(EditViewController.indicatorTouched(_:)))
            pageInd.tag = pageNum
            if pageNum == 0 {
                pageInd.backgroundColor = UIColorFromHex(0x34495e)
            }
            self.addSubview(pageInd)
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
        priceField.tag = 30
        priceField.textColor = UIColorFromHex(0x34495e)
        priceField.textAlignment = .Center
        priceField.clearsOnBeginEditing = true
        priceField.font = UIFont(name: "Avenir", size: 50)
        priceField.returnKeyType = .Done
        priceField.keyboardType = .NumberPad
        priceField.delegate = self
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self, action: #selector(EditViewController.doneButtonClicked(_:)))
        
        toolbarDone.items = [flexSpace, barBtnDone] // You can even add cancel button too
        priceField.inputAccessoryView = toolbarDone
        
        let dollarSignFrame = CGRectMake(0, 0, priceField.frame.width*0.2, priceField.frame.height)
        let dollarSign = customLabel(dollarSignFrame, text: "$", color: UIColorFromHex(0x34495e), fontSize: 50)
        priceField.addSubview(dollarSign)
        
        containerView.addSubview(priceField)
    }
    
    func doneButtonClicked(sender: AnyObject) {
        priceField.resignFirstResponder()
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
        //        let locationLabel = customLabel(CGRectMake(screenSize.width*0.3, screenSize.height*5.27, screenSize.width*0.6, screenSize.height*0.1), text: "Location", color: UIColorFromHex(0x34495e), fontSize: 30)
        //        containerView.addSubview(locationLabel)
        
        let locationButton = makeTextButton("Location", frame: CGRectMake(screenSize.width*0.3, screenSize.height*5.27, screenSize.width*0.6, screenSize.height*0.1), action: #selector(EditViewController.searchClicked(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 30)
        containerView.addSubview(locationButton)
        
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
    
    
    //updating preview page
    
    func setPreviewItemName() {
        let previewNameFrame = CGRectMake(screenSize.width*0.2, screenSize.height*7.35, screenSize.width*0.6, screenSize.height*0.05)
        previewName = makeTextButton(itemName.text!, frame: previewNameFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        previewName.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        previewName.tag = 1
        containerView.addSubview(previewName)
    }
    
    func updatePreviewName() {
        previewName.setTitle(itemName.text, forState: .Normal)
    }
    
    func setCategoryPreview() {
        let previewCategoryFrame = CGRectMake(screenSize.width*0.2, screenSize.height*7.4, screenSize.width*0.6, screenSize.height*0.05)
        previewCategory = makeTextButton("Furniture", frame: previewCategoryFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        previewCategory.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        previewCategory.tag = 2
        containerView.addSubview(previewCategory)
    }
    
    func updateCategoryPreview(text: String) {
        previewCategory.setTitle(text, forState: .Normal)
    }
    
    func setYearsPreview() {
        let yearsCategoryFrame = CGRectMake(screenSize.width*0.2, screenSize.height*7.45, screenSize.width*0.6, screenSize.height*0.05)
        previewYears = makeTextButton("0 years old", frame: yearsCategoryFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        previewYears.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        previewYears.tag = 3
        containerView.addSubview(previewYears)
    }
    
    func updateYearsPreview(years: String) {
        previewYears.setTitle("\(years) years old", forState: .Normal)
    }
    
    func setInitialCondition() {
        let initialConditionFrame = CGRect(x: screenSize.width*0.2, y: screenSize.height*7.5, width: screenSize.width*0.6, height: screenSize.height*0.05)
        let label = makeTextButton("Zero stars filled", frame: initialConditionFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        label.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        label.tag = 25
        containerView.addSubview(label)
    }
    
    func setConditionPreview() {
        
        for view in containerView.subviews {
            if view.tag == 25 {
                view.removeFromSuperview()
            }
        }
        if ratingControl.rating == 0 {
            setInitialCondition()
        }
        
        let size = screenSize.width*0.07
        
        ratingPreviewContainer.tag = 20
        containerView.addSubview(ratingPreviewContainer)
        var ratingFrame = CGRectMake(0, 0, size, size)
        for rating in 0...ratingControl.rating {
            let star = makeImageButton("Star_Filled.png", frame: ratingFrame, action: #selector(EditViewController.changePage(_:)), target: evc, tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
            star.tag = 3
            ratingFrame.origin.x = CGFloat(rating) * size
            ratingPreviewContainer.addSubview(star)
        }
    }
    
    func ratingSelected(control: RatingControl, rating: Int) {
        for view in containerView.subviews {
            if view.tag == 20 {
                view.removeFromSuperview()
            }
        }
        setConditionPreview()
        //        print("rating selected")
    }
    
    func setDescriptionPreview() {
        
        ratingPreviewContainer = UIView(frame: CGRectMake(screenSize.width*0.2, screenSize.height*7.5, screenSize.width*0.07*5, screenSize.width*0.07))
        let descriptionPreviewFrame = CGRectMake(screenSize.width*0.2, screenSize.height*7.5+ratingPreviewContainer.frame.height, screenSize.width*0.7, screenSize.height*0.15)
        descriptionContainer = UIView(frame: descriptionPreviewFrame)
        //        descriptionContainer.backgroundColor = U IColor.whiteColor()
        let labelFrame = CGRect(x: 0, y: 0, width: descriptionPreviewFrame.width, height: descriptionPreviewFrame.height)
        
        previewDescription = makeTextButton("Description", frame: labelFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        //        previewDescription.backgroundColor = UIColor.whiteColor()
        previewDescription.tag = 3
        previewDescription.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        previewDescription.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        previewDescription.titleLabel?.lineBreakMode = .ByWordWrapping
        previewDescription.titleLabel?.numberOfLines = 3
        previewDescription.sizeThatFits(descriptionContainer.frame.size)
        descriptionContainer.addSubview(previewDescription)
        containerView.addSubview(descriptionContainer)
    }
    
    func setLocationPreview() {
        let locationPreviewFrame = CGRectMake(screenSize.width*0.2, screenSize.height*7.5+ratingPreviewContainer.frame.height+previewDescription.frame.height, screenSize.width*0.6, screenSize.height*0.05)
        previewLocation = makeTextButton("Using current location", frame: locationPreviewFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        previewLocation.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        previewLocation.tag = 5
        containerView.addSubview(previewLocation)
    }
    
    func updateLocationPreview(useLocation: Bool) {
        if useLocation {
            previewLocation.setTitle("Using current location", forState: .Normal)
        }
        else {
            let placeName: String = currentPlace.name
            previewLocation.setTitle(placeName, forState: .Normal)
        }
    }
    
    func setPricePreview() {
        let pricePreviewFrame = CGRectMake(screenSize.width*0.2, screenSize.height*7.5+ratingPreviewContainer.frame.height+previewDescription.frame.height+previewLocation.frame.height, screenSize.width*0.6, screenSize.height*0.05)
        previewPrice = makeTextButton("No minimum price set", frame: pricePreviewFrame, action: #selector(EditViewController.changePage(_:)), target: evc, textColor: UIColorFromHex(0x34495e), textSize: 18)
        previewPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        previewPrice.tag = 6
        containerView.addSubview(previewPrice)
    }
    
    //pickerview delegates and data sources
    
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
        if pickerView.tag == 1 {
            updateCategoryPreview(categoryPickerData[row])
        }
        else {
            updateYearsPreview(yearsPickerData[row])
        }
    }
    
    
    
    /***********************************************************
     ALL GOOGLE MAPS IMPLEMENTATION IS HERE
     ***********************************************************/
    
    func setupMap() {
        mapView = GMSMapView(frame: CGRectMake(screenSize.width*0.2, screenSize.height*5.37, screenSize.width*0.8, screenSize.height*0.25))
        mapView.backgroundColor = UIColorFromHex(0xecf0f1)
        containerView.addSubview(mapView)
        
        let currentLocationButton = makeImageButton("sell_currentlocation_button.png", frame: CGRectMake(screenSize.width*0.25, screenSize.height*5.65, screenSize.width*0.5, screenSize.height*0.1), action: #selector(EditViewController.curLocationClicked(_:)), target: evc, tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0.0)
        
        containerView.addSubview(currentLocationButton)
        
        let searchImageButton = makeImageButton("Search Filled-100.png", frame: CGRectMake(screenSize.width*0.27, screenSize.height*5.28, screenSize.width*0.13, screenSize.width*0.13), action: #selector(EditViewController.searchClicked(_:)), target: evc, tinted: false, circle: true, backgroundColor: 0x000000, backgroundAlpha: 0.0)
        
        containerView.addSubview(searchImageButton)
        
        //probably gonna need to migrate this to the controller
        
        //to get the users location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        useMyLocation = true
    }
    
    //END OF GOOGLE MAPS IMPLEMENTATION
    
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
    
    
    
}
*/
