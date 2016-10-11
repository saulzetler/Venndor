//
//  SettingsViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var containerView: UIView!
    let screenSize = UIScreen.mainScreen().bounds
    var tableViewItems = ["Contact Us", "Delete Account", "Log Out"]
    var tableView: UITableView!
    
    var phoneNumber: UITextField!
    
    var tableCellHieght = UIScreen.mainScreen().bounds.height*0.07
    var numberOfCells = 3
    
    var sessionStart: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView = UIView(frame: CGRect(x: 0, y: screenSize.height*0.1, width: screenSize.width, height: screenSize.height*0.9))
        containerView.backgroundColor = UIColorFromHex(0xecf0f1)
        self.view.addSubview(containerView)
        
        LocalUser.CurrentPage = "Settings"
        LocalUser.user.mostRecentAction = "Went to Settings"
        sessionStart = NSDate()
        
        
        setupPhoneNumInput()
//        hideKeyboardWhenTappedAround()
        setupPhonePrompt()
        setUpTableView()
        
        //add the generic views of each page ie. header and side menu
//        addHeaderOther("Settings")
        addHeaderItems("Settings")
        sideMenuGestureSetup()
        revealViewController().rightViewController = nil
        self.revealViewController().delegate = self
        self.view.bringSubviewToFront(containerView)
        
    }
    
    func setupPhonePrompt() {
        let labelFrame = CGRect(x: screenSize.width*0.2, y: screenSize.height*0.06, width: screenSize.width*0.8, height: screenSize.height*0.06)
        let label = customLabel(labelFrame, text: "Edit", color: UIColorFromHex(0x34495e), fontSize: 15)
        label.textAlignment = .Left
        containerView.addSubview(label)
    }
    
    
    
    func setupPhoneNumInput() {
        phoneNumber = ItemNameTextField(frame: CGRectMake(screenSize.width*0.2, screenSize.height*0.12, screenSize.width*0.6, screenSize.height*0.06))
        phoneNumber.text = LocalUser.user.phoneNumber
        phoneNumber.textColor = UIColorFromHex(0x34495e)
        phoneNumber.font = UIFont(name: "Avenir", size: 32)
        phoneNumber.delegate = self
        phoneNumber.clearsOnBeginEditing = false
        phoneNumber.textAlignment = .Center
        containerView.addSubview(phoneNumber)
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColorFromHex(0x34495e).CGColor
        border.frame = CGRect(x: 0, y: phoneNumber.frame.size.height - width, width:  phoneNumber.frame.size.width, height: phoneNumber.frame.size.height)
        border.borderWidth = width
        phoneNumber.layer.addSublayer(border)
        phoneNumber.layer.masksToBounds = true
        phoneNumber.keyboardType = .NumberPad
        phoneNumber.returnKeyType = .Done
        
        phoneNumber.adjustsFontSizeToFitWidth = true
        
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self, action: #selector(SettingsViewController.doneButtonClicked(_:)))
        
        toolbarDone.items = [flexSpace, barBtnDone] // You can even add cancel button too
        phoneNumber.inputAccessoryView = toolbarDone
    }
    
    func doneButtonClicked(sender: AnyObject) {
        phoneNumber.resignFirstResponder()
        let update = ["phoneNumber" : phoneNumber.text!] as JSON
        
        UserManager.globalManager.updateUserById(LocalUser.user.id, update: update) { error in
            guard error == nil else {
                print("Error updating the local users phone number")
                return
            }
            print("Local users phone number updated successfully")
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 10
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: screenSize.height*0.24, width: screenSize.width, height: tableCellHieght*CGFloat(numberOfCells)), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.alwaysBounceVertical = false
        containerView.addSubview(tableView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return tableCellHieght
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .DisclosureIndicator
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel!.text = tableViewItems[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Avenir", size: 16)
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            toAbout()
        case 1:
            deleteAccount()
        case 2:
            logOut()
        default:
            break
        }
    }
    
    
    //logout button for when the user wants to log out
    func logOut() {
        //logs the user out of facebook along with out app
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    
    func deleteAccount() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegueWithIdentifier("toDelete", sender: self)
        
    }
    
    func toAbout() {
        let avc = AboutViewController()
        self.presentViewController(avc, animated: true, completion: nil)
    }
    
    
    func revealController(revealController: SWRevealViewController, didMoveToPosition position: FrontViewPosition){
        if((position == FrontViewPosition.Left)) {
            containerView.userInteractionEnabled = true
            reactivate()
        } else {
            containerView.userInteractionEnabled = false
            deactivate()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TimeManager.globalManager.setSessionDuration(sessionStart, controller: "SettingsViewController")
    }
    
    
}