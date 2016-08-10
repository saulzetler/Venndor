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
    var userID: String!
    var sellerID: String!
    var sellerName: String! 
    var matchedPrice: Int!
    var thumbnail: UIImage!
    var itemLongitude: Double!
    var itemLatitude: Double!
    var bought: Int!
    var dateMatched: NSDate!
    var dateBought: NSDate!
    var matchTimeRemaining: String!
    
    init(itemID: String, itemName: String, itemDescription: String, userID: String, sellerID: String, sellerName: String, matchedPrice: Int, thumbnail: UIImage, itemLongitude: Double, itemLatitude: Double, dateMatched: NSDate!) {
        self.itemID = itemID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.userID = userID
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.matchedPrice = matchedPrice
        self.thumbnail = thumbnail
        self.itemLongitude = itemLongitude
        self.itemLatitude = itemLatitude
        self.bought = 0
        self.dateMatched = dateMatched
    }
    
    init(json: JSON) {
        self.id = json["_id"] as? String
        self.itemID = json["itemID"] as! String
        self.itemName = json["itemName"] as! String
        self.itemDescription = json["itemDescription"] as! String
        self.userID = json["userID"] as! String
        self.sellerID = json["sellerID"] as! String
        self.sellerName = json["sellerName"] as! String
        self.matchedPrice = json["matchedPrice"] as! Int
        self.itemLongitude = json["itemLongitude"] as! Double
        self.itemLatitude = json["itemLatitude"] as! Double
        self.bought = json["bought"] as! Int
        self.dateMatched = TimeManager.formatter.dateFromString(json["dateMatched"]! as! String)
        self.dateBought = json["dateBought"] == nil ? nil : TimeManager.formatter.dateFromString(json["dateBought"]! as! String)
    }
    
}