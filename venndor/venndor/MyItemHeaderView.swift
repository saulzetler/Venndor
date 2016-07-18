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
    init(frame: CGRect, page: String) {
        super.init(frame: frame)
        setUpViewFrame()
        setUpViewMenu()
        setUpName(page)
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
    func setUpName(page: String) -> Void {
        let title = UILabel(frame: CGRectMake(screenSize.width*0.36, 26, screenSize.width*0.6, 30))
        title.text = page
        title.textColor = UIColor.whiteColor()
        title.font = UIFont(name: title.font.fontName, size: 20)
        self.addSubview(title)
    }
}
