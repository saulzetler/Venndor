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
    static var phoneNumber: String!
    static var gender: String! 
    static var education: String!
    static var ageRange: String!
    static var seenPosts: [String:AnyObject]!
    static var matches: [Match]!
    static var posts: [Post]! 
    static var profilePictureURL: String!
    static var myLocation: CLLocation!
    static var pushID: String!
}

class User: NSObject {
    var id: String!
    var email: String!
    var phoneNumber: String!
    var firstName: String!
    var lastName: String!
    var gender: String!
    var ageRange: String!
    var profilePictureURL: String!
    var pushID: String!
    
    var university: String!  //NI
    var howTheyFoundVenndor: String!  //NI
    
    var rating: Double!
    var nuMatches: Int!
    
    var nuItemsSold: Int!    //NI
    var nuItemsBought: Int!  //NI
    
    var nuSwipesLeft: Int!
    var nuSwipesRight: Int!
    var nuSwipesTotal: Int!
    var nuPosts: Int!
    var nuVisits: Int!
    var moneySaved: Double!  //NI
    var mostRecentAction: String!
    
    //key: Date, Value: Time Spent
    var timeOnAppPerSession: [String:Double]!
    
    //key: Controller name, Value: Time Spent
    var timePerController: [String:Double]!
    
    //key: PostObject ID, Value: buyerID
    var soldItems : [String:AnyObject]!    //NI
    
    //key: Match Object ID, value: sellerID 
    var boughtItems: [String:AnyObject]!   
    
    //key: Post Object ID, value: Item Object ID
    var posts: [String:AnyObject]!
    
    //key: Match Object ID, value: Item object ID
    var matches: [String:AnyObject]!
    
    
    init(json:JSON) {
        id = json["_id"] as! String
        email = json["email"] as! String
        phoneNumber = json["phoneNumber"] as! String
        firstName = json["first_name"] as! String
        lastName = json["last_name"] as! String
        gender = json["gender"] as! String
        ageRange = json["ageRange"] as! String
        profilePictureURL = json["profilePictureURL"] as! String
        pushID = json["pushID"] as! String 
        university = json["university"] as! String
        howTheyFoundVenndor = json["howTheyFoundVenndor"] as! String
        rating = json["rating"] as! Double
        nuMatches = json["nuMatches"] as! Int
        nuItemsBought = json["nuItemsBought"] as! Int
        nuItemsSold = json["nuItemsSold"] as! Int
        nuSwipesLeft = json["nuSwipesLeft"] as! Int
        nuSwipesRight = json["nuSwipesRight"] as! Int
        nuSwipesTotal = json["nuSwipesTotal"] as! Int
        nuPosts = json["nuPosts"] as! Int
        nuVisits = json["nuVisits"] as! Int
        moneySaved = json["moneySaved"] as! Double
        mostRecentAction = json["mostRecentAction"] as! String
        timeOnAppPerSession = ParserManager.globalManager.getDoubleDict(json["timeOnAppPerSession"]!)
        timePerController = ParserManager.globalManager.getDoubleDict(json["timePerController"]!)
        soldItems = ParserManager.globalManager.getDict(json["soldItems"]!)
        boughtItems = ParserManager.globalManager.getDict(json["boughtItems"]!)
        posts = ParserManager.globalManager.getDict(json["posts"]!)
        matches = ParserManager.globalManager.getDict(json["matches"]!)
    }
}