//
//  RatingControl.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

protocol RatingControlDelegate {
    func ratingSelected(control: RatingControl, rating: Int)
}

class RatingControl: UIView {
    
    var delegate : RatingControlDelegate?
    
    var buttonArray: [UIButton]!
    var rating: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonArray = []
        setUpViewFrame(frame)
        rating = 0
    }
    
    func setUpViewFrame(frame: CGRect) -> Void {
        //initial view frame
        var buttonFrame: CGRect!
        
        for rating in 0...4 {
            buttonFrame = CGRect(x: CGFloat(rating)*frame.width*0.2, y: 0, width: frame.width*0.19, height: frame.height)
            let button = makeImageButton("Star.png", frame: buttonFrame, target: #selector(RatingControl.handleTap(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
            let filledStarImage = UIImage(named: "Star_Filled.png")
            button.setImage(filledStarImage, forState: .Selected)
            button.tag = rating + 1
            buttonArray.append(button)
            self.addSubview(button)
        }
        
    }
    
    func handleTap(sender: UIButton) {
        if (rating == 1 && sender.tag == 1) {
            rating = 0
        }
        else {
            rating = sender.tag
        }
        
        delegate?.ratingSelected(self, rating: self.rating)
        
//        print(rating)
        
        for button in buttonArray {
            if button.tag <= rating {
                button.selected = true
            }
            else {
                button.selected = false
            }
        }
    }
    
}
