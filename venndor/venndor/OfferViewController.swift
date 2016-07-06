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
    var backgroundImage: UIImage!
    var item: Item! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupWheelSlider()
        setupBackground()
        setupPrompt()
    }
    //to setup the page background to be the items image TO BE DONE
    func setupBackground() {
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        imageViewBackground.image = backgroundImage
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        imageViewBackground.alpha = 0.7
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageViewBackground.bounds
        blurEffectView.alpha = 0.7
        imageViewBackground.addSubview(blurEffectView)
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }
    //to create the back button
    func setupBackButton() {
        let buttonSize = CGRect(x: screenSize.width * 0.1, y: screenSize.height * 0.05, width: screenSize.width * 0.13, height: screenSize.width * 0.13)
        let backButton = makeImageButton("Back_Arrow.png", frame: buttonSize, target: "goBack:", tinted: false, circle: true, backgroundColor: 0x000000, backgroundAlpha: 0.3)
        self.view.addSubview(backButton)
    }
    
    //function to set up text and image
    func setupPrompt() {
        let promptView = UIView(frame: CGRect(x: 0, y: screenSize.height*0.2, width: screenSize.width, height: screenSize.height*0.2))
        promptView.backgroundColor = UIColor.whiteColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.height*0.2, height: screenSize.height*0.2))
        imageView.image = backgroundImage
        let promptText = UILabel(frame: CGRect(x: screenSize.width*0.47, y: 0, width: screenSize.width*0.4, height: screenSize.height*0.2))
        promptText.textAlignment = .Center
        promptText.text = "How much would you pay?"
        promptText.numberOfLines = 2
        promptView.addSubview(promptText)
        promptView.addSubview(imageView)
        self.view.addSubview(promptView)
    }
    
    func offer(sender: UIButton) {
        print("offered")
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
        let offerButton = makeImageButton("", frame: CGRect(x: wheelslider.frame.width*0.1, y: wheelslider.frame.height*0.1, width: wheelslider.frame.width*0.73, height: wheelslider.frame.height*0.73), target: "offer:", tinted: false, circle: true, backgroundColor: 0x1abc9c, backgroundAlpha: 0)
        wheelslider.addSubview(offerButton)
        let goImageView = UIImageView(frame: CGRect(x: wheelslider.frame.width*0.35, y: wheelslider.frame.height*0.5, width: wheelslider.frame.width*0.3, height: wheelslider.frame.height*0.3))
        goImageView.image = UIImage(named: "go.png")
        wheelslider.addSubview(goImageView)
        self.view.addSubview(wheelslider)
    }
    
    
    //function to update hte midle number shown in the wheel TO BE DONE
    func updateSliderValue(value: Double, sender: WheelSlider) {
    }
}