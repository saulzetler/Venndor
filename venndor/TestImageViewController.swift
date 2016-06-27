//
//  TestImageViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-26.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit


class TestImageViewController: UIViewController {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!

    override func viewDidLoad() {
        RESTEngine.sharedEngine.getImageFromServerById("5770d3a06f94c1381d2a36c2", fileName: "image0", success: { response in
            guard let content = response!["content"] as? String,
               let fileData = NSData(base64EncodedString: content, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            else {
               print("Error converting data from server.")
                return
            }
            let img = UIImage(data: fileData)
            self.image1.image = img
            self.performSegueWithIdentifier("finalTest", sender: self)
            }, failure: { error in
                print("Error getting image from server: \(error)")
        })
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "finalTest" {
            let vc = segue.destinationViewController as! FinalTestViewController
            vc.img = self.image1.image
        }
    }
}

