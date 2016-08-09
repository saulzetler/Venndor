//
//  EditViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-08-08.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

/*

class EditViewController: UIViewController, GMSAutocompleteViewControllerDelegate, ImagePickerDelegate {
    
    var postView: PostView!
    
    var imagePickerController: ImagePickerController!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var itemToBeEdited: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postView = PostView(frame: self.view.frame)
        self.view = postView
        
        hideKeyboardWhenTappedAround()
//        self.revealViewController().delegate = self
        
    }
    
    func indicatorTouched(sender: UIButton) {
        let pageHeight:CGFloat = CGRectGetHeight(postView.scrollView.frame)
        postView.pageNum = sender.tag
        let yOffset = CGPointMake(0, pageHeight*CGFloat(postView.pageNum));
        postView.scrollView.setContentOffset(yOffset, animated: true)
        postView.updateIndicators()
    }
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        postView.currentPlace = place
        postView.useMyLocation = false
        postView.mapView.clear()
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismissViewControllerAnimated(true, completion: nil)
        postView.mapView.animateToLocation(place.coordinate)
        //        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let pin = GMSMarker(position: place.coordinate)
        pin.appearAnimation = kGMSMarkerAnimationPop
        pin.map = postView.mapView
        postView.updateLocationPreview(false)
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
    
    //custom button funcs
    
    func searchClicked(sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    
    func curLocationClicked(sender: UIButton) {
        postView.mapView.clear()
        postView.mapView.animateToLocation(LocalUser.myLocation.coordinate)
        //        mapView.camera = GMSCameraPosition(target: myLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let pin = GMSMarker(position: LocalUser.myLocation.coordinate)
        pin.appearAnimation = kGMSMarkerAnimationPop
        pin.map = postView.mapView
        postView.useMyLocation = true
        postView.updateLocationPreview(true)
    }
    
    
    
    //delegate image picker functions
    
    func wrapperDidPress(images: [UIImage]){
        print("cool")
    }
    
    func updateImagePreviews() {
        for imageView in postView.previewImageViewArray {
            imageView.removeFromSuperview()
        }
        let imageWidth = screenSize.width*0.15
        var imageFrame = CGRectMake(screenSize.width*0.025, screenSize.height*7.25, imageWidth, imageWidth)
        imageFrame.origin.x += imageWidth*CGFloat(6-postView.filledImagesArray.count)/2
        for imageView in postView.imageViewArray {
            if postView.filledImagesArray.contains(imageView.tag) {
                let smallImageView = UIImageView(frame: imageFrame)
                smallImageView.image = imageView.image
                smallImageView.contentMode = .ScaleAspectFill
                createBorder(smallImageView, color: UIColorFromHex(0x34495e))
                postView.previewImageViewArray.append(smallImageView)
                imageFrame.origin.x += (imageWidth + screenSize.width*0.01)
                postView.containerView.addSubview(smallImageView)
            }
        }
    }
    
    func doneButtonDidPress(images: [UIImage]){
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        var i = 0
        var startIndex = postView.currentImgView.tag
        let images = imageAssets
        for imageView in postView.imageViewArray {
            if imageView.tag == startIndex {
                if i < images.count {
                    imageView.image = images[i]
                    if !postView.filledImagesArray.contains(imageView.tag) {
                        postView.filledImagesArray.append(imageView.tag)
                    }
                    i += 1
                    startIndex += 1
                }
            }
        }
        updateImagePreviews()
    }
    func cancelButtonDidPress(){
    }
    
    var imageAssets: [UIImage] {
        return ImagePicker.resolveAssets(imagePickerController.stack.assets)
    }
    
    //function to control when an image view is tapped and access the camera roll
    func imageTapped(sender: UIGestureRecognizer) {
        postView.currentImgView = sender.view as! UIImageView
        imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 6 - postView.currentImgView.tag
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    //page changing functions
    func changePage(sender: AnyObject) -> () {
        if sender.tag == 25 {
            postView.pageNum = 3
        }else {
            postView.pageNum = sender.tag
        }
        let y = CGFloat(postView.pageNum) * postView.scrollView.frame.size.height
        postView.scrollView.setContentOffset(CGPointMake(0, y), animated: true)
        postView.updateIndicators()
        
    }
    
    func goToPage(page: Int) {
        postView.pageNum = page
        let y = CGFloat(postView.pageNum) * postView.scrollView.frame.size.height
        postView.scrollView.setContentOffset(CGPointMake(0, y), animated: true)
        postView.updateIndicators()
    }
    
    func nextPage(sender: UIButton) {
        postView.pageNum += 1
        let y = CGFloat(postView.pageNum) * postView.scrollView.frame.size.height
        postView.scrollView.setContentOffset(CGPointMake(0, y), animated: true)
        postView.updateIndicators()
    }
    
    func prevPage(sender: UIButton) {
        postView.pageNum -= 1
        let y = CGFloat(postView.pageNum) * postView.scrollView.frame.size.height
        postView.scrollView.setContentOffset(CGPointMake(0, y), animated: true)
    }
    
    func doneButtonClicked(sender: AnyObject) {
        postView.priceField.resignFirstResponder()
    }
    
    //posting an item
    
    //function to controll when the user is finished and decides to post
    func postItem(sender: UIButton) {
        
        if postView.filledImagesArray.count == 0 {
            let popup = PopoverViewController()
            popup.showInView(self.view, message: "Please select at least one image")
            goToPage(0)
            return
        }
        
        if postView.itemName.text == "Item Name" {
            let popup = PopoverViewController()
            popup.showInView(self.view, message: "Please enter a name for your item")
            goToPage(1)
            return
        }
        
        if Int(postView.priceField.text!) == nil {
            let popup = PopoverViewController()
            popup.showInView(self.view, message: "Please enter a minimum price for your item")
            goToPage(6)
            return
        }
        
        
        
        LocalUser.user.mostRecentAction = "Posted an Item"
        //add the iamges from the image view to an array to be passed to the backend function to post an item to server
        if let name = postView.itemName.text, details = postView.itemDescription.text {
            var images = [UIImage]()
            for imgView in postView.imageViewArray {
                if postView.filledImagesArray.contains(imgView.tag) {
                    if let img = imgView.image {
                        images.append(img)
                    }
                }
            }
            
            //get the category of the item from the picker controller
            let row = postView.categoryPicker.selectedRowInComponent(0)
            let category = postView.categoryPickerData[row]
            let age = postView.yearsPickerData[postView.yearsPicker.selectedRowInComponent(0)]
            let ownerName = "\(LocalUser.user.firstName) \(LocalUser.user.lastName)"
            
            let condition = postView.ratingControl.rating
            if postView.useMyLocation == true {
                postView.coordinate = LocalUser.myLocation.coordinate
            }
            else {
                postView.coordinate = postView.currentPlace.coordinate
            }
            let latitude = Double(postView.coordinate.latitude)
            let longitude = Double(postView.coordinate.longitude)
            let minPrice = Int(postView.priceField.text!)
            
            var conversion = LocationConverter()
            let geoHash = conversion.coordToGeo(latitude, longitudeInput: longitude)
            print ("THIS IS THE CURRENT GEOHASH YOU GETTING DAWG: " + geoHash)
            
            //create an item object to past to the manager to create the item
            let item = Item(name: name, description: details, owner: LocalUser.user.id, ownerName: ownerName, category: category, condition: condition, latitude: latitude, longitude: longitude, geoHash: geoHash, photos: images, itemAge: age, minPrice: minPrice!)
            
            //create the item object on the server
            ItemManager.globalManager.createItem(item) { error in
                guard error == nil else {
                    print("GOOD FUCKING JOB BUDDY YOU BROKE EVERYTHING. I fucking hate u")
                    return
                }
                
                //create the post object on the server
                let post = Post(itemID: item.id!, itemName: item.name, itemDescription: item.details, userID: item.owner, minPrice: item.minPrice, thumbnail: self.postView.imageView1.image!, itemLongitude: item.longitude, itemLatitude: item.latitude)
                
                PostManager.globalManager.createPost(post) { post, error in
                    LocalUser.user.posts[post!.id] = item.id
                    LocalUser.user.nuPosts! += 1
                    LocalUser.posts.append(post!)
                    
                    let update : [String:AnyObject] = ["posts": LocalUser.user.posts, "nuPosts": LocalUser.user.nuPosts]
                    UserManager.globalManager.updateUserById(LocalUser.user.id, update: update) { error in
                        guard error == nil else {
                            print("Error updating the User's posts from post screen: \(error)")
                            return
                        }
                        
                        print("Succesfully updated User's ads from post screen.")
                        self.performSegueWithIdentifier("backToBrowse", sender: self)
                    }
                    
                }
            }
        }
    }
}
 
*/