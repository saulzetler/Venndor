//
//  AboutViewController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-08-04.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var backButton: UIButton!
    var header: UIView!
    
    var feedback: UITextView!
    
    var sessionStart: NSDate!
    
    var tableViewItems = ["Privacy policy"]
    var tableView: UITableView!
    
    var defaultText = "Enter your feedback..."
    
    override func viewDidLoad() {//VIEWDIDLoad? more like.....viewdid CHODE!!!!! haha nice!!! nci
        super.viewDidLoad()
        LocalUser.user.mostRecentAction = "Entered About Page."
        
        self.view.backgroundColor = UIColorFromHex(0xecf0f1)
        sessionStart = NSDate()
        
        setupHeaderFrame()
        setupBackButton()
        setUpTableView()
        setupGrayBar()
        setupTextView()
        setupButton()
    }
    
    func setupButton() {
        let buttonFrame = CGRect(x: screenSize.width*0.15, y: screenSize.height*0.6, width: screenSize.width*0.7, height: screenSize.height*0.1)
        let button = makeTextButton("SUBMIT FEEDBACK", frame: buttonFrame, target: #selector(AboutViewController.submit(_:)), circle: false, textColor: UIColor.whiteColor(), tinted: false, backgroundColor: UIColorFromHex(0x1abc9c), textSize: 16)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        self.view.addSubview(button)
    }
    
    func setupGrayBar() {
        let barFrame = CGRect(x: 0, y: screenSize.height*0.25, width: screenSize.width, height: screenSize.height*0.07)
        let grayBar = customLabel(barFrame, text: "Tell us what you think of Venndor!", color: UIColor.whiteColor(), fontSize: 14)
        grayBar.backgroundColor = UIColorFromHex(0x7f8c8d)
        self.view.addSubview(grayBar)
    }
    
    func setupTextView() {
        feedback = UITextView(frame: CGRectMake(0, screenSize.height*0.32, self.screenSize.width, screenSize.height*0.25))
        feedback.text = defaultText
        feedback.font = UIFont(name: "Avenir", size: 15)
        feedback.textColor = UIColorFromHex(0x95a5a6)
        feedback.delegate = self
        self.view.addSubview(feedback)
        feedback.returnKeyType = .Done
    }
    
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: screenSize.height*0.15, width: screenSize.width, height: screenSize.height*0.075), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    }
    
    //table view delegate and sources
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        cell.textLabel!.text = tableViewItems[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Avenir", size: 14)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            //do stuff
        }
        
        //        print("You selected cell #\(indexPath.row)!")
    }
    
    func setupHeaderFrame() {
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.height*0.1)
        self.header = UIView(frame: frame)
        self.header.backgroundColor = UIColorFromHex(0x1abc9c, alpha: 1)
        self.view.addSubview(header)
    }
    
    func setupBackButton() {
        
        let backImage = UIImage(named: "Back-50.png")
        
        backButton = UIButton(type: UIButtonType.Custom) as UIButton
        backButton.frame = CGRectMake(17, 27, screenSize.width*0.15, 25)
        backButton.setImage(backImage, forState: .Normal)
        backButton.imageView?.contentMode = UIViewContentMode.Center
        backButton.addTarget(self, action: #selector(AboutViewController.dismissController(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.header.addSubview(backButton)
        self.header.bringSubviewToFront(backButton)
    }
    
    //text view delegate funcs
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor = UIColor.blackColor()
        if textView.text == defaultText {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.textColor = UIColorFromHex(0x95a5a6)
        textView.resignFirstResponder()
        if textView.text == "" {
            textView.text = defaultText
        }
    }
    
    func submit(sender: UIButton) {
        print("submit pressed")
    }
    
    
    func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}