//
//  OfferView.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class OfferView: UIView {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewFrame()
        setupBackButton()
    }
    
    func setupViewFrame() {
        self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        self.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.7)
    }
    
    func setupBackButton() {
        let buttonSize = CGRect(x: screenSize.width * 0.1, y: screenSize.height * 0.05, width: screenSize.width * 0.13, height: screenSize.width * 0.13)
        let backButton = makeImageButton("Back_Arrow.png", frame: buttonSize, target: #selector(OfferView.goBack(_:)), tinted: false, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        self.addSubview(backButton)
    }
    
    func goBack(sender: UIButton) {
        self.removeFromSuperview()
    }
    
}