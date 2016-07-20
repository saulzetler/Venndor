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

    //declare class as part of fb delegate to allow delegate overwriting
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    let loginButton : FBSDKLoginButton = FBSDKLoginButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromHex(0x1abc9c, alpha: 1)
        
        //app loads for the first time reset the category to all
        GlobalItems.currentCategory = nil
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if the user has already logged in through facebook
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            //if they are remove all the junk so it looks nice and get the data from their profile
            let subViews = self.view.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            fetchProfile()
        }
        else
        {
            //if they arent get them to log in!
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
        }
        
    }
    
    //function to pull the user data
    func fetchProfile() {
        //, user_location
        //, location = result["user_location"] as? String
        //parameters for what data the app should pull
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), id, gender, age_range, education"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {(
            connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            if let firstName = result["first_name"] as? String, lastName = result["last_name"] as? String, email = result["email"] as? String, userID = result["id"] as? NSString, gender = result["gender"] as? String {
                //if there is great success store the pulled data
                LocalUser.firstName = firstName
                LocalUser.lastName = lastName
                LocalUser.email = email
                LocalUser.gender = gender
                
                if let ageRange = result["age_range"] {
                    LocalUser.ageRange = "\(ageRange["min"]) - \(ageRange["max"])"
                }
                
                
                
                /* ADD PHOTO HANDLER/STORAGE FOR USER*/
//                let link = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=large")
//                let pictureData = NSData(contentsOfURL: link!)
//                LocalUser.profilePicture = UIImage(data: pictureData!)
                print (userID)
                LocalUser.profilePictureURL = "https://graph.facebook.com/\(userID)/picture?type=large"
                
                
                //transition when great success
                self.performSegueWithIdentifier("showSplash", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to be called when the login button is pressed.
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //check there is no error first
        if error == nil
        {
            //then check that the user isn't currently logged in
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                // remove UI so the transition looks nice when segueing
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
}
