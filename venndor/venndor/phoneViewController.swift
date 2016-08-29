//
//  LoginPageViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-07-20.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
class phoneViewController: UIViewController, UITextFieldDelegate {
    
    var phoneField: UITextField!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let background = UIImage(named: "match background.png")
        let backgroundView = UIImageView(frame: CGRect(x: -20, y: -20, width: screenSize.width*1.2, height: screenSize.height*1.1))
        backgroundView.image = background
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        setupPhoneField()
        
        let confirmButton = makeTextButton("Confirm", frame: CGRect(x: screenSize.width*0.17, y: screenSize.height*0.6+screenSize.width*0.1, width: screenSize.width*0.7, height: screenSize.width*0.2), target: #selector(phoneViewController.confirmNumber(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: false, backgroundColor: UIColorFromHex(0x2c3e50), textSize: 20)
        self.view.addSubview(confirmButton)
        
        let title = UIImageView(frame: CGRect(x: screenSize.width*0.13, y: screenSize.height*0.3, width: screenSize.width*0.74, height: screenSize.width*0.2))
        title.image = UIImage(named: "title.png")
        
        self.view.addSubview(title)
        
        //app loads for the first time reset the category to all
        

    }
    
    func setupPhoneField() {
        phoneField = UITextField(frame: CGRectMake(self.screenSize.width*0.1, self.screenSize.height*0.4, self.screenSize.width*0.8, screenSize.height*0.1))
        let border = CALayer()
        let width = CGFloat(2.0)
        border.frame = CGRect(x: 0, y: phoneField.frame.size.height - width, width:  phoneField.frame.size.width, height: phoneField.frame.size.height)
        border.borderWidth = width
        border.borderColor = UIColorFromHex(0xFFFFFF).CGColor
        phoneField.layer.addSublayer(border)
        phoneField.layer.masksToBounds = true
        phoneField.tag = 30
        phoneField.textColor = UIColorFromHex(0xFFFFFF)
        phoneField.textAlignment = .Center
        phoneField.clearsOnBeginEditing = true
        phoneField.font = UIFont(name: "Avenir", size: 50)
        phoneField.returnKeyType = .Done
        phoneField.keyboardType = .NumberPad
        phoneField.delegate = self
        phoneField.adjustsFontSizeToFitWidth = true
        phoneField.text = "Phone Number"
        phoneField.textColor = UIColorFromHex(0xFFFFFF)
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self, action: #selector(phoneViewController.doneButtonClicked(_:)))
        
        toolbarDone.items = [flexSpace, barBtnDone] // You can even add cancel button too
        phoneField.inputAccessoryView = toolbarDone
        
        self.view.addSubview(phoneField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //text field editing delegates
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if textField.text == "Item Name" {
            return true
        } else {
            return false
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print("begin")
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "Phone Number" {
            textField.text = nil
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "Phone Number"
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    func doneButtonClicked(sender: AnyObject) {
        phoneField.resignFirstResponder()
    }
    
    //end of text field delegates
    
    func confirmNumber(sender: AnyObject) {
        let userNumber = phoneField.text
        if userNumber == "" || userNumber?.characters.count != 10 {
            let popup = PopoverViewController()
            popup.showInView(self.view, message: "Please enter a valid phone number!")
            return
        } else {
            LocalUser.phoneNumber = userNumber
            self.performSegueWithIdentifier("toSplash", sender: self)
        }
    }
    
}
