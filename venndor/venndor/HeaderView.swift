//
//  HeaderView.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-14.
//  Copyright © 2016 Venndor. All rights reserved.
//

//import Cocoa
import UIKit
extension UIView {
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
class HeaderView: UIView, UITextFieldDelegate {
    
    var menuButton: UIButton!
    var categoryButton: UIButton!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let menuImage = UIImage(named: "ic_menu_white.png")
    let categoryImage = UIImage(named: "ic_dashboard_white.png")
    let cancelImage = UIImage(named: "ic_clear_white.png")
    let cancelButton = UIButton(type: UIButtonType.Custom) as UIButton
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViewFrame()
        self.setUpViewText()
        self.setUpViewMenu()
        self.setUpViewCategory()
    }
    
    func setUpViewFrame() -> Void {
        //initial view frame

        self.frame = CGRectMake(0, 0, screenSize.width, 64)
        self.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
    }
    
    func setUpViewText() -> Void {
        //setup textfield
        let sampleTextField = UITextField(frame: CGRectMake(screenSize.width*0.25, 24, screenSize.width*0.5, 30))
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
        let imageView = UIImageView();
        let image = UIImage(named: "ic_search_white.png");
        imageView.image = image;
        sampleTextField.leftView = imageView;
        sampleTextField.leftViewMode = UITextFieldViewMode.Always
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.addSubview(imageView)
    }
    
    func setUpViewMenu() -> Void {
        //setup menu button
        menuButton   = UIButton(type: UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(screenSize.width*0, 24, screenSize.width*0.2, 30)
        menuButton.setImage(menuImage, forState: .Normal)
        menuButton.tag = 1
        self.addSubview(menuButton)
    }
    
    func setUpViewCategory() -> Void {
    
        //setup category button
        categoryButton = UIButton(type: UIButtonType.Custom) as UIButton
        categoryButton.frame = CGRectMake(screenSize.width*0.8, 24, screenSize.width*0.2, 30)
        categoryButton.setImage(categoryImage, forState: .Normal)
        categoryButton.tag = 2
        self.addSubview(categoryButton)
        
    }
    
    func setUpViewCancel() -> Void {
        cancelButton.frame = CGRectMake(screenSize.width*0.8, 24, screenSize.width*0.2, 30)
        cancelButton.setImage(cancelImage, forState: .Normal)
        cancelButton.tag = 3
        cancelButton.addTarget(self, action: "buttonPress:", forControlEvents: .TouchUpInside)
        self.addSubview(cancelButton)
    }

    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        let subViews = self.subviews
        for subView in subViews {
            if subView == categoryButton || subView == menuButton {
                subView.removeFromSuperview()
            }
            else {
                UIView.animateWithDuration(0.5, animations: {
                    subView.frame = CGRect(x: self.screenSize.width*0.05, y: 24, width: self.screenSize.width*0.7, height: 30)
                })
                if let textField = subView as? UITextField {
                    textField.attributedPlaceholder =  NSAttributedString(string:"Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                }
                self.setUpViewCancel()
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
        
        UIView.animateWithDuration(0.5, animations: {
            textField.frame = CGRect(x: self.screenSize.width*0.25, y: 24, width: self.screenSize.width*0.5, height: 30);
            self.addSubview(self.menuButton);
            self.addSubview(self.categoryButton);
        })
        cancelButton.removeFromSuperview()
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
        let subViews = self.subviews
        for subView in subViews {
            subView.removeFromSuperview()
        }
        self.setUpViewText()
        self.setUpViewMenu()
        self.setUpViewCategory()
    }

}
