//
//  LoginPageViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-07-20.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
class LoginPageViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var isLoggedIn: Bool!
    let loginButton : FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let background = UIImage(named: "match background.png")
        let backgroundView = UIImageView(frame: CGRect(x: -20, y: -20, width: screenSize.width*1.2, height: screenSize.height*1.1))
        backgroundView.image = background
        
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        let slogan = UILabel(frame: CGRect(x: screenSize.width*0.31, y: screenSize.height*0.4, width: screenSize.width*0.5, height: screenSize.width*0.2))
        slogan.text = "Buy and Sell."
        let slogan2 = UILabel(frame: CGRect(x: screenSize.width*0.17, y: screenSize.height*0.4+screenSize.width*0.1, width: screenSize.width*0.7, height: screenSize.width*0.2))
        slogan2.text = "Save time and hassle."
        slogan.textColor = UIColor.whiteColor()
        slogan2.textColor = UIColor.whiteColor()
        slogan.font = UIFont(name: "Avenir", size: 26)
        slogan2.font = UIFont(name: "Avenir", size: 24)
        slogan.adjustsFontSizeToFitWidth = true
        slogan2.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(slogan)
        self.view.addSubview(slogan2)
        
        let title = UIImageView(frame: CGRect(x: screenSize.width*0.13, y: screenSize.height*0.3, width: screenSize.width*0.74, height: screenSize.width*0.2))
        title.image = UIImage(named: "title.png")
        
        self.view.addSubview(title)
        
        //app loads for the first time reset the category to all
        GlobalItems.currentCategory = nil
        isLoggedIn = false
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            //if they are remove all the junk so it looks nice and get the data from their profile
            let subViews = self.view.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            isLoggedIn = true
            fetchProfile()
        }
        else
        {
            //if they arent get them to log in!
            loginButton.frame = CGRect(x: screenSize.width*0.2, y: screenSize.height*0.75, width: screenSize.width*0.6, height: screenSize.width*0.1)
            self.view.addSubview(loginButton)
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
        }
    }
    
    

    //function to pull the user data
    func fetchProfile() {
        //, user_location
        //, location = result["user_location"] as? String
        //parameters for what data the app should pull
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), id, gender, age_range"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {(
            connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            if let firstName = result["first_name"] as? String, lastName = result["last_name"] as? String, email = result["email"] as? String, userID = result["id"] as? NSString, gender = result["gender"] as? String, ageRange = result["age_range"] {
                //if there is great success store the pulled data
                LocalUser.firstName = firstName
                LocalUser.lastName = lastName
                LocalUser.email = email
                LocalUser.gender = gender
                LocalUser.ageRange = "\(ageRange["min"])-\(ageRange["max"])"
                LocalUser.profilePictureURL = "https://graph.facebook.com/\(userID)/picture?type=large"
                
                //transition when great success
                if self.isLoggedIn == true {
                    self.performSegueWithIdentifier("toSplash", sender: self)
                } else {
                    self.performSegueWithIdentifier("toNumber", sender: self)
                }
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
