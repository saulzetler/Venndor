//
//  OfferViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class OfferViewController: UIViewController, WheelSliderDelegate {

    //screen size for future reference
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var backgroundImage: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupWheelSlider()
        self.view.backgroundColor = backgroundImage
    }
    //to setup the page background to be the items image TO BE DONE
    func setupBackground(background: UIImage) {
        backgroundImage = UIColor(patternImage: background).colorWithAlphaComponent(0.7)
    }
    //to create the back button
    func setupBackButton() {
        let buttonSize = CGRect(x: screenSize.width * 0.1, y: screenSize.height * 0.05, width: screenSize.width * 0.13, height: screenSize.width * 0.13)
        let backButton = makeImageButton("Back_Arrow.png", frame: buttonSize, target: "goBack:", tinted: false, circle: false, backgroundColor: 0x2c3e50, backgroundAlpha: 0)
        self.view.addSubview(backButton)
    }
    //segue to return to browsing
    func goBack(sender: UIButton) {
        self.performSegueWithIdentifier("offerToBrowse", sender: self)
    }
    
    //function to set up the wheel slider and control.
    func setupWheelSlider() {
        let wheelFrame = CGRectMake(screenSize.width*0.2, screenSize.height*0.6, screenSize.width*0.6, screenSize.width*0.6)
        let wheelslider = WheelSlider(frame: wheelFrame)
        wheelslider.delegate = self
        wheelslider.callback = {(value:Double) in
        }
        self.view.addSubview(wheelslider)
    }
    //function to update hte midle number shown in the wheel TO BE DONE
    func updateSliderValue(value: Double, sender: WheelSlider) {
    }
}