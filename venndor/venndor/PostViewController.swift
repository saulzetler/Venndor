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
    
    
    
    @IBOutlet weak var itemDescription: UITextView!
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var firstImageView: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.delegate = self
        itemName.clearsOnBeginEditing = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    func
    
    func textViewDidBeginEditing(textView: UITextView) {
        itemDescription.text = ""
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
        
        firstImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
}