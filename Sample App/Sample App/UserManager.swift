//
//  UserManager.swift
//  Testing- Backend
//
//  Created by David Tamrazov on 2016-06-17.
//  Copyright © 2016 David Tamrazov. All rights reserved.
//

import Foundation

enum UpdateType {
    case Ads()
    case Rating()
    case Matches()
}

struct UserManager {

    func createUser(first: String, last: String, email: String, completionHandler: (User?, ErrorType?) -> ()) {
        RESTEngine.sharedEngine.registerUser(email, firstName: first, lastName: last, age: 12,
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    let params: JSON =
                    ["first_name": "\(first)",
                        "last_name": "\(last)",
                        "id": id as! String,
                        "email": email,
                        "rating": 0.0,
                        "nuMatches": 0,
                        "nuItemsSold": 0,
                        "nuItemsBought": 0,
                        "ads": [String](),
                        "soldItems": [String](),
                        "matches": [Match]()]
                    
                    let user = User(json: params)
                    completionHandler(user, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    
    func retrieveUserById(id: String, completionHandler: (User?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getUserById(id,
            success: { response in
                if let response = response {
                    let user = User(json: response)
                    completionHandler(user, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
                
        })
    }
    
    func retrieveUserByEmail(email: String, completionHandler: (User?, ErrorType?) ->() ) {
        RESTEngine.sharedEngine.getUserByEmail(email,
            success: { response in
                if let response = response, result = response["resource"], userData = result[0] {
                    let user = User(json: userData as! JSON)
                    completionHandler(user, nil)
                }
            
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func updateUser(user: User, type: UpdateType?, completionHandler: (String?, ErrorType?) -> () ) {
        
        var userInfo: JSON!
        
        if let type = type {
            switch type {
            case .Ads :
                userInfo = ["ads": user.ads]
            case .Rating :
                userInfo = ["rating": user.rating]
                
            case .Matches :
                userInfo = ["matches": user.matches]
            }
        }
            
        else {
            userInfo = ["first_name": user.firstName,
            "id": user.id,
            "email": user.email,
            "rating": user.rating,
            "nuMatches": user.nuMatches,
            "nuItemsSold": user.nuItemsSold,
            "nuItemsBought": user.nuItemsBought,
            "ads": user.ads,
            "soldItems": user.soldItems,
            "matches": user.matches]
        }
        
        RESTEngine.sharedEngine.updateUserById(user.id, info: userInfo,
            success: { response in
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
}



























