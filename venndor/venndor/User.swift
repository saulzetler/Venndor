//
//  User.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct LocalUser {
    static var user: User!
    static var firstName: String!
    static var lastName: String!
    static var email: String!
    static var seenPosts: [String:AnyObject]!
    static var matches: [Match]!
}

class User: NSObject {
    var firstName: String!
    var lastName: String!
    var id: String!
    var email: String!
    var rating: Double!
    var nuMatches: Int!
    var nuItemsSold: Int!
    var nuItemsBought: Int!
    var soldItems : [String:AnyObject]!
    var boughtItems: [String:AnyObject]!
    var ads: [String:AnyObject]!
    //key: matchID, value: item in the match
    var matches: [String:AnyObject]!
    var moneySaved: Double!
    let parseManager = ParserManager()
    
    init(json:JSON) {
        firstName = json["first_name"] as! String
        lastName = json["last_name"] as! String
        id = json["_id"] as! String
        email = json["email"] as! String
        rating = json["rating"] as! Double
        nuMatches = json["nuMatches"] as! Int
        nuItemsBought = json["nuItemsBought"] as! Int
        nuItemsSold = json["nuItemsSold"] as! Int
        soldItems = parseManager.getDict(json["soldItems"]!)
        ads = parseManager.getDict(json["ads"]!)
        matches = parseManager.getDict(json["matches"]!) 
        boughtItems = parseManager.getDict(json["boughtItems"]!)
        moneySaved = Double(json["moneySaved"] as! Int)
    }
    
}