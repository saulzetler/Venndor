//
//  OfferViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class OfferViewController: UIViewController, WheelSliderDelegate {
 
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var backgroundImage: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupWheelSlider()
        self.view.backgroundColor = backgroundImage
    }
    
    func setupBackground(background: UIImage) {
        backgroundImage = UIColor(patternImage: background).colorWithAlphaComponent(0.7)
    }
    
    func setupBackButton() {
        let buttonSize = CGRect(x: screenSize.width * 0.1, y: screenSize.height * 0.05, width: screenSize.width * 0.13, height: screenSize.width * 0.13)
        let backButton = makeImageButton("Back_Arrow.png", frame: buttonSize, target: "goBack:", tinted: false, circle: false, backgroundColor: 0x2c3e50, backgroundAlpha: 0)
        self.view.addSubview(backButton)
    }
    
    func goBack(sender: UIButton) {
        self.performSegueWithIdentifier("offerToBrowse", sender: self)
    }
    
    func setupWheelSlider() {
        let wheelFrame = CGRectMake(screenSize.width*0.2, screenSize.height*0.6, screenSize.width*0.6, screenSize.width*0.6)
        let wheelslider = WheelSlider(frame: wheelFrame)
        wheelslider.delegate = self
        wheelslider.callback = {(value:Double) in
        }
        self.view.addSubview(wheelslider)
    }
    
    func updateSliderValue(value: Double, sender: WheelSlider) {
    }
}