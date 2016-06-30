//
//  ViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-07.
//  Copyright © 2016 Venndor. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    let loginButton : FBSDKLoginButton = FBSDKLoginButton()
//    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    @IBAction func loginButton2(sender: UIButton){
        loginButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromHex(0x3498db, alpha: 1)
        GlobalItems.currentCategory = nil
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            let subViews = self.view.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            fetchProfile()
        }
        else
        {
//            self.view.addSubview(loginButton)
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
        }
        
    }
    
    func fetchProfile() {
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {(
            connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            if let firstName = result["first_name"] as? String, lastName = result["last_name"] as? String, email = result["email"] as? String {
                LocalUser.firstName = firstName
                LocalUser.lastName = lastName
                LocalUser.email = email
                self.performSegueWithIdentifier("showSplash", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil
        {
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                let subViews = self.view.subviews
                for subView in subViews {
                    subView.removeFromSuperview()
                }
                
                print("Login complete")
                fetchProfile()
                
            }
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    //FACEBOOK LOGIN DELEGATES
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "showSplash") {
//            let svc = segue.destinationViewController as! SplashViewController;
//            
//            svc.categorySelected = nil
//        }
//    }
    
}
