//
//  EditViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-08-08.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class EditViewController: UIViewController {
    
    var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postView = PostView(frame: self.view.frame)
        
        
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
}