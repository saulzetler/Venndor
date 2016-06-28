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
    func makeImageButton(imageName: String, frame: CGRect, target: Selector, tinted: Bool, circle: Bool, backgroundColor: UInt32, backgroundAlpha: Double) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: target, forControlEvents: UIControlEvents.TouchUpInside)
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
    
}

class View: UIView {
    
}