//
//  ViewController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-07.
//  Copyright © 2016 Venndor. All rights reserved.
//

extension UIViewController: SWRevealViewControllerDelegate {
    
    func customLabel(frame: CGRect, text: String, color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.textColor = color
        label.font = UIFont(name: "Avenir", size: fontSize)
        label.textAlignment = .Center
        return label
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
    
    func makeTextButton(text: String, frame: CGRect, target: Selector, circle: Bool = false, textColor: UIColor = UIColor.blackColor(), tinted: Bool = true, backgroundColor: UIColor = UIColor.clearColor(), textSize: CGFloat = 12) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: target, forControlEvents: .TouchUpInside)
        button.setTitle(text, forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: textSize)
        button.setTitleColor(textColor, forState: UIControlState.Normal)
        if tinted == true {
            button.setTitleColor(UIColorFromHex(0x3498db, alpha: 1), forState: UIControlState.Selected)
        }
        if circle == true {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
        button.backgroundColor = backgroundColor
        return button
    }
    
    func makeIndicatorButton(frame: CGRect, color: UIColor, target: Selector) -> UIButton {
        let button = UIButton (frame: frame)
        button.layer.cornerRadius = 0.5*button.bounds.size.width
        button.addTarget(self, action: target, forControlEvents: .TouchDown)
        createBorder(button, color: color, circle: true)
        button.backgroundColor = UIColor.clearColor()
        return button
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func addHeader() {
        let headerView: HeaderView = HeaderView(frame: self.view.frame)
        headerView.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.categoryButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
    }
    func addHeaderOther(page: String) {
        let headerView: OtherHeaderView = OtherHeaderView(frame: self.view.frame, page: page)
        headerView.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
    }
    func addHeaderItems(page: String) {
        let headerView: MyItemHeaderView = MyItemHeaderView(frame: self.view.frame, page: page)
        headerView.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(headerView)
        self.view.bringSubviewToFront(headerView)
    }
    
    func sideMenuGestureSetup() {
        if revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //animate a new view over top
    func bringUpNewView(view: UIView) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        UIView.animateWithDuration(1.0, delay: 0, options: .TransitionCrossDissolve, animations: {
            self.view.addSubview(view)
            self.view.bringSubviewToFront(view)
            view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            }, completion: nil)
    }
    
    //generic scroll view functions
    func createBorder(view: UIView, color: UIColor = UIColor.blackColor(), circle: Bool = false) {
        let boarderColor : UIColor = color
        view.layer.borderColor = boarderColor.CGColor
        view.layer.borderWidth = 2.0
        if circle == false {
          view.layer.cornerRadius = 8.0
        }
        view.layer.masksToBounds = true
    }
    
    func createImgView(frame: CGRect, action: Selector, superView: UIView, boarderColor: UIColor = UIColor.blackColor(), boardered: Bool = false) -> UIImageView {
        let imgView = UIImageView(frame: frame)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        imgView.userInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        imgView.layer.masksToBounds = true
        imgView.contentMode = .ScaleAspectFill
        if boardered {
            createBorder(imgView, color: boarderColor)
        }
        superView.addSubview(imgView)
        return imgView
    }
    
    //function to set up text and image
    func setupPrompt(text: String, item: Item, screenSize: CGRect, frame: CGRect) {
        let promptView = UIView(frame: frame)
        promptView.backgroundColor = UIColor.whiteColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        imageView.image = item.photos![0]
        let promptText = UILabel(frame: CGRect(x: frame.width*0.47, y: frame.height*0.3, width: frame.width*0.4, height: frame.height*0.4))
        promptText.textAlignment = .Center
        promptText.text = text
        promptText.numberOfLines = 2
        promptView.addSubview(promptText)
        promptView.addSubview(imageView)
        self.view.addSubview(promptView)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //deactivate when side menu is open
    
    //me trying to do it
    
    func deactivate() {
        removeViewIfPresent(100)
        let deactivateView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height*0.1, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height*0.9))
        deactivateView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        deactivateView.tag = 100
//        let tap = UITapGestureRecognizer(target: deactivateView, action: #selector(UIViewController.activate))
//        deactivateView.addGestureRecognizer(tap)
        self.view.addSubview(deactivateView)
    }
    
    func reactivate() {
        removeViewIfPresent(100)
    }
    
    func removeViewIfPresent(tag: Int) {
        for view in self.view.subviews {
            if (view.tag == tag) {
                view.removeFromSuperview()
            }
        }
    }
    
//    //calculate your distance away from the item
//    func calculateDistance(item: Item, myLocation: CLLocation) -> String {
//        
//        var distText: String!
//        
//        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
//        let itemLatitude = CLLocationDegrees(item.latitude)
//        let itemLongitude = CLLocationDegrees(item.longitude)
//        let myLatitude = myLocation.coordinate.latitude
//        let myLongitude = myLocation.coordinate.longitude
//        
//        let origins = "origins=\(myLatitude),\(myLongitude)&"
//        let destinations = "destinations=\(itemLatitude),\(itemLongitude)&"
//        let key = "KEY=AIzaSyBGJFI_sQFJZUpVu4cHd7bD5zlV5lra-FU"
//        let url = baseURL+origins+destinations+key
//        
//        let requestURL: NSURL = NSURL(string: url)!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(urlRequest) {
//            (data, response, error) -> Void in
//            
//            let httpResponse = response as! NSHTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            if (statusCode == 200) {
//                
//                do {
//                    
//                    
//                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//                    if let rows = json["rows"] as? [[String:AnyObject]] {
//                        let first = rows[0]
//                        let elements = first["elements"] as! Array<AnyObject>
//                        let firstElement = elements[0]
//                        if let distDict = firstElement["distance"] as? [String:AnyObject] {
//                            distText = String(distDict["text"]!)
//                        }
//                        else {
//                            distText = "none"
//                        }
//                    }
//                } catch {
//                    print("Error with Json: \(error)")
//                }
//                
//            }
//        }
//        task.resume()
//        return distText
//    }
//    
//    func calculateDistanceFromItem(item: Item, myLocation: CLLocation) -> String {
//        
//        var distText: String!
//        
//        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
//        let itemLatitude = CLLocationDegrees(item.latitude)
//        let itemLongitude = CLLocationDegrees(item.longitude)
//        let myLatitude = myLocation.coordinate.latitude
//        let myLongitude = myLocation.coordinate.longitude
//        
//        let origins = "origins=\(myLatitude),\(myLongitude)&"
//        let destinations = "destinations=\(itemLatitude),\(itemLongitude)&"
//        let key = "KEY=AIzaSyBGJFI_sQFJZUpVu4cHd7bD5zlV5lra-FU"
//        let url = baseURL+origins+destinations+key
//        
//        let requestURL: NSURL = NSURL(string: url)!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(urlRequest) {
//            (data, response, error) -> Void in
//            
//            let httpResponse = response as! NSHTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            if (statusCode == 200) {
//
//                do {
//                    
//                    
//                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//                    if let rows = json["rows"] as? [[String:AnyObject]] {
//                        let first = rows[0]
//                        let elements = first["elements"] as! Array<AnyObject>
//                        let firstElement = elements[0]
//                        if let distDict = firstElement["distance"] as? [String:AnyObject] {
//                            distText = String(distDict["text"]!)
//                        }
//                        else {
//                            distText = "none"
//                        }
//                    }
//                } catch {
//                    print("Error with Json: \(error)")
//                }
//                
//            }
//        }
//        task.resume()
//        return distText
//    }
//    
//    func calculateDistanceFromLocation(latitude: Double, longitude: Double, myLocation: CLLocation) -> String {
//        
//        var distText: String!
//        
//        let baseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"
//        let itemLatitude = CLLocationDegrees(latitude)
//        let itemLongitude = CLLocationDegrees(longitude)
//        let myLatitude = myLocation.coordinate.latitude
//        let myLongitude = myLocation.coordinate.longitude
//        
//        let origins = "origins=\(myLatitude),\(myLongitude)&"
//        let destinations = "destinations=\(itemLatitude),\(itemLongitude)&"
//        let key = "KEY=AIzaSyBGJFI_sQFJZUpVu4cHd7bD5zlV5lra-FU"
//        let url = baseURL+origins+destinations+key
//        
//        let requestURL: NSURL = NSURL(string: url)!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(urlRequest) {
//            (data, response, error) -> Void in
//            
//            let httpResponse = response as! NSHTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            if (statusCode == 200) {
//                
//                do {
//                    
//                    
//                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//                    if let rows = json["rows"] as? [[String:AnyObject]] {
//                        let first = rows[0]
//                        let elements = first["elements"] as! Array<AnyObject>
//                        let firstElement = elements[0]
//                        if let distDict = firstElement["distance"] as? [String:AnyObject] {
//                            distText = String(distDict["text"]!)
//                        }
//                        else {
//                            distText = "none"
//                        }
//                    }
//                } catch {
//                    print("Error with Json: \(error)")
//                }
//                
//            }
//        }
//        task.resume()
//        return distText
//    }
//    
}
class ViewController: UIViewController {
    
}

