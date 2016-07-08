//
//  HeaderView.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-14.
//  Copyright © 2016 Venndor. All rights reserved.
//

//import Cocoa
import UIKit

class HeaderView: UIView, UITextFieldDelegate {
    
    var menuButton: UIButton!
    var categoryButton: UIButton!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let menuImage = UIImage(named: "ic_menu_white.png")
    let categoryImage = UIImage(named: "ic_dashboard_white.png")
    let cancelImage = UIImage(named: "ic_clear_white.png")
    let cancelButton = UIButton(type: UIButtonType.Custom) as UIButton
    var sampleTextField: UITextField!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewFrame()
        setUpViewText()
        setUpViewMenu()
        setUpViewCategory()
        setUpViewCancel()
    }
    
    func setUpViewFrame() -> Void {
        //initial view frame

        self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height*0.1)
        self.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
    }
    
    func setUpViewText() -> Void {
        //setup textfield
        sampleTextField = UITextField(frame: CGRectMake(screenSize.width*0.25, 24, screenSize.width*0.5, 30))
        sampleTextField.backgroundColor = UIColorFromHex(0x123456, alpha: 0.05)
        sampleTextField.attributedPlaceholder = NSAttributedString(string:"Venndor", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        sampleTextField.font = UIFont.systemFontOfSize(17)
        sampleTextField.textColor = UIColor.whiteColor()
        sampleTextField.borderStyle = UITextBorderStyle.RoundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.No
        sampleTextField.keyboardType = UIKeyboardType.Default
        sampleTextField.returnKeyType = UIReturnKeyType.Done
        sampleTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        sampleTextField.delegate = self
        self.addSubview(sampleTextField)
        
        //setup icon for search
        let imageView = UIImageView()
        let image = UIImage(named: "ic_search_white.png")
        imageView.image = image
        sampleTextField.leftView = imageView
        sampleTextField.leftViewMode = UITextFieldViewMode.Always
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.layer.zPosition = 1
        sampleTextField.addSubview(imageView)
        sampleTextField.bringSubviewToFront(imageView)
    }
    
    func setUpViewMenu() -> Void {
        //setup menu button
        menuButton   = UIButton(type: UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(screenSize.width*0, 24, screenSize.width*0.2, 30)
        menuButton.setImage(menuImage, forState: .Normal)
        self.addSubview(menuButton)
    }
    
    func setUpViewCategory() -> Void {
    
        //setup category button
        categoryButton = UIButton(type: UIButtonType.Custom) as UIButton
        categoryButton.frame = CGRectMake(screenSize.width*0.8, 24, screenSize.width*0.2, 30)
        categoryButton.setImage(categoryImage, forState: .Normal)
        self.addSubview(categoryButton)
        
    }
    
    func setUpViewCancel() -> Void {
        cancelButton.frame = CGRectMake(screenSize.width*0.8, 24, screenSize.width*0.2, 30)
        cancelButton.setImage(cancelImage, forState: .Normal)
        cancelButton.addTarget(self, action: #selector(HeaderView.buttonPress(_:)), forControlEvents: .TouchUpInside)
        cancelButton.hidden = true
        self.addSubview(cancelButton)
    }

    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        let subViews = self.subviews
        for subView in subViews {
            if subView == categoryButton || subView == menuButton {
                subView.hidden = true
            }
            else if subView == cancelButton{
                subView.hidden = false
            }
            else {
                UIView.animateWithDuration(0.5, animations: {
                    subView.frame = CGRect(x: self.screenSize.width*0.05, y: 24, width: self.screenSize.width*0.7, height: 30)
                })
                if let textField = subView as? UITextField {
                    textField.attributedPlaceholder =  NSAttributedString(string:"Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                }

            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
        
        let subViews = self.subviews
        for subView in subViews {
            if subView == categoryButton || subView == menuButton {
                subView.hidden = false
            }
            else if subView == cancelButton {
                subView.hidden = true
            }
            else {
                UIView.animateWithDuration(0.2, animations: {
                    subView.frame = CGRect(x: self.screenSize.width*0.25,y: 24,width: self.screenSize.width*0.5,height: 30)
                })
                if let textField = subView as? UITextField {
                    textField.attributedPlaceholder =  NSAttributedString(string:"Venndor", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    // MARK: Textfield Delegates <---
    func buttonPress(sender: UIButton!) {
        sampleTextField.text = ""
        self.endEditing(true)
        textFieldDidEndEditing(sampleTextField)
    }

}
