//
//  RatingControl.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewFrame()
    }
    
    func setUpViewFrame() -> Void {
        //initial view frame
        
        self.frame = CGRectMake(0, screenSize.height*3.6, screenSize.width, screenSize.height*0.3)
        self.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        
    }
    
    func setUpButton() -> Void {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.backgroundColor = UIColor.redColor()
        addSubview(button)
    }
}
