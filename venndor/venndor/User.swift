//
//  User.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias JSONArray = [JSON]

class User: NSObject {
    var name: String
    var id: String
    var email: String
    var age: Int?
    var rating: Double
    var nuMatches: Int
    var nuItemsSold: Int
    var nuItemsBought: Int
    
    init(json:JSON) {
        name = json["name"] as! String
        id = json["id"] as! String
        email = json["email"] as! String
        rating = json["rating"] as! Double
        nuMatches = json["nuMatches"] as! Int
        nuItemsBought = json["nuItemsBought"] as! Int
        nuItemsSold = json["nuItemsSold"] as! Int
    }
    
}