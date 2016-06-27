//
//  FinalTestViewController.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-26.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class FinalTestViewController: UIViewController {
    
    @IBOutlet weak var imageTest: UIImageView!
    
    var img: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.img {
            let imgView = self.imageTest
            self.imageTest.image = image 
        }
    }
}
