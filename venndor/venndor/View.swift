//
//  View.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    func makeImageButton(imageName: String, frame: CGRect, action: Selector, tinted: Bool, circle: Bool, backgroundColor: UInt32, backgroundAlpha: Double) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        if imageName != "" {
            let buttonImage = UIImage(named: imageName)
            button.setImage(buttonImage, forState: .Normal)
            if tinted == true {
                let tintedButton = buttonImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                button.setImage(tintedButton, forState: .Selected)
            }
        }
        if circle == true {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
        if backgroundAlpha != 0 {
            button.backgroundColor = UIColorFromHex(backgroundColor, alpha: backgroundAlpha)
        }
        return button
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func makeTextButton(text: String, frame: CGRect, action: Selector, circle: Bool = false, textColor: UIColor = UIColor.blackColor(), tinted: Bool = true, backgroundColor: UIColor = UIColor.clearColor(), textSize: CGFloat = 12) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        button.setTitle(text, forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: textSize)
        button.setTitleColor(textColor, forState: UIControlState.Normal)
        if tinted == true {
            button.setTitleColor(UIColorFromHex(0x3498db, alpha: 1), forState: UIControlState.Selected)
        }
        if circle == true {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
        button.backgroundColor = backgroundColor
        return button
    }
    
    //generic scroll view functions
    func createBorder(view: UIView, color: UIColor = UIColor.blackColor(), circle: Bool = false) {
        let boarderColor : UIColor = color
        view.layer.borderColor = boarderColor.CGColor
        view.layer.borderWidth = 2.0
        if circle == false {
            view.layer.cornerRadius = 8.0
        }
        view.layer.masksToBounds = true
    }
    
    func createImgView(frame: CGRect, action: Selector, superView: UIView, boarderColor: UIColor = UIColor.blackColor(), boardered: Bool = false) -> UIImageView {
        let imgView = UIImageView(frame: frame)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        imgView.userInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        imgView.layer.masksToBounds = true
        imgView.contentMode = .ScaleAspectFill
        if boardered {
            createBorder(imgView, color: boarderColor)
        }
        superView.addSubview(imgView)
        return imgView
    }
    
    func customLabel(frame: CGRect, text: String, color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.textColor = color
        label.font = UIFont(name: "Avenir", size: fontSize)
        label.textAlignment = .Center
        return label
    }
    
    func customTextView(frame: CGRect, text: String, color: UIColor, fontSize: CGFloat, bold: Bool) -> UITextView {
        let textView = UITextView(frame: frame)
        textView.text = text
        textView.textColor = color
        if bold {
            textView.font = UIFont(name: "Avenir-Heavy", size: fontSize)
        }
        else {
            textView.font = UIFont(name: "Avenir", size: fontSize)
        }
        textView.textAlignment = .Left
        textView.editable = false
        textView.scrollEnabled = false
        return textView
    }
    
    func makeIndicatorButton(frame: CGRect, color: UIColor, target: Selector) -> UIButton {
        let button = UIButton (frame: frame)
        button.layer.cornerRadius = 0.5*button.bounds.size.width
        button.addTarget(self, action: target, forControlEvents: .TouchDown)
        createBorder(button, color: color, circle: true)
        button.backgroundColor = UIColor.clearColor()
        return button
    }

}

class View: UIView {
    
}