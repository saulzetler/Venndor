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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    func setUpView() -> Void {
        //initial view frame
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.frame = CGRectMake(0, 0, screenSize.width, 64)
        self.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        
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
        
        //setup menu button
        let menuImage = UIImage(named: "ic_menu_white.png");
        menuButton   = UIButton(type: UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(screenSize.width*0, 24, screenSize.width*0.2, 30)
        menuButton.setImage(menuImage, forState: .Normal)
        menuButton.tag = 1
        self.addSubview(menuButton)
        
        //setup category button
        let categoryImage = UIImage(named: "ic_dashboard_white.png");
        categoryButton = UIButton(type: UIButtonType.Custom) as UIButton
        categoryButton.frame = CGRectMake(screenSize.width*0.8, 24, screenSize.width*0.2, 30)
        categoryButton.setImage(categoryImage, forState: .Normal)
        categoryButton.tag = 1
        self.addSubview(categoryButton)
        
    }

    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
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
    

}
