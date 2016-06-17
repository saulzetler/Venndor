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
    
    let itemDescription: UITextView!
    let itemName: UITextField!
    let imageView: UIImageView!
    let postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        itemDescription.delegate = self
        itemName.clearsOnBeginEditing = true
        
        let headerView: HeaderView = HeaderView(frame: self.view.frame)
        headerView.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.categoryButton.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        itemDescription.text = ""
    }
    
    
    
    @IBAction func cancelPost(sender: UIButton) {
        self.performSegueWithIdentifier("backToBrowse", sender: self)
    }
    
    @IBAction func postToServer(sender: UIButton) {
        self.performSegueWithIdentifier("backToBrowse", sender: self)
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        
    }
    
    
    /*
    
    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
       
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }

    */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
}