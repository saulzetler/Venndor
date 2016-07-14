//
//  HeaderView.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-14.
//  Copyright © 2016 Venndor. All rights reserved.
//

//import Cocoa
import UIKit

class MyItemHeaderView: UIView, UITextFieldDelegate {
    
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
        setUpViewMenu()
        setUpViewCategory()
    }
    
    func setUpViewFrame() -> Void {
        //initial view frame
        
        self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height*0.1)
        self.backgroundColor = UIColorFromHex(0x1abc9c, alpha: 1)
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
}
