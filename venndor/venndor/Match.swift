//
//  Match.swift
//  Sample App
//
//  Created by David Tamrazov on 2016-06-20.
//  Copyright © 2016 David Tamrazov. All rights reserved.
//

import Foundation

class Match: NSObject {
    
    var id: String?
    var itemID: String!
    var itemName: String!
    var itemDescription: String!
    var itemPickupLocation: String! 
    var userID: String!
    var sellerID: String!
    var sellerName: String! 
    var matchedPrice: Int!
    var thumbnail: UIImage!
    var bought: Int!
    var dateMatched: NSDate!
    var dateBought: NSDate!
    var matchTimeRemaining: String!
    
    init(itemID: String, itemName: String, itemDescription: String, itemPickupLocation: String, userID: String, sellerID: String, sellerName: String, matchedPrice: Int, thumbnail: UIImage, dateMatched: NSDate!) {
        self.itemID = itemID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemPickupLocation = itemPickupLocation
        self.userID = userID
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.matchedPrice = matchedPrice
        self.thumbnail = thumbnail
        self.bought = 0
        self.dateMatched = dateMatched
    }
    
    init(json: JSON) {
        self.id = json["_id"] as? String
        self.itemID = json["itemID"] as! String
        self.itemName = json["itemName"] as! String
        self.itemDescription = json["itemDescription"] as! String
        self.itemPickupLocation = json["itemPickupLocation"] as! String 
        self.userID = json["userID"] as! String
        self.sellerID = json["sellerID"] as! String
        self.sellerName = json["sellerName"] as! String
        self.matchedPrice = json["matchedPrice"] as! Int
        self.bought = json["bought"] as! Int
        self.dateMatched = TimeManager.formatter.dateFromString(json["dateMatched"]! as! String)
        self.dateBought = json["dateBought"] == nil ? nil : TimeManager.formatter.dateFromString(json["dateBought"]! as! String)
    }
    
}