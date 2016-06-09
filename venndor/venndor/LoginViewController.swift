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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(loginButton)
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("Already logged in")
            fetchProfile()
            self.performSegueWithIdentifier("showNew", sender: self)
        }
        else
        {
            print("not logged in")
        }
    }
    
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {(
            connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            if let email = result["email"] as? String {
                currentUser = email
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
            print("Login complete")
            fetchProfile()
            self.performSegueWithIdentifier("showNew", sender: self)
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
    
}

