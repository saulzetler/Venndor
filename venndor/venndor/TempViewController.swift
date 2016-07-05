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

/********************************************

USELESS CLASS CREATED TO TEST SIMPLE FUNCTIONS
PLEASE IGNORE

*********************************************/

class TempViewController: UIViewController, FBSDKLoginButtonDelegate {
    let loginButton2 : FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(loginButton2)
        loginButton2.center = self.view.center
        loginButton2.readPermissions = ["public_profile", "email"]
        loginButton2.delegate = self
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
                print(email)
            }
            if let firstName = result["first_name"] as? String {
                print(firstName)
            }
            if let lastName = result["last_name"] as? String {
                print(lastName)
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
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    //FACEBOOK LOGIN DELEGATES
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
        self.performSegueWithIdentifier("goToStart", sender: self)
    }
    
}

