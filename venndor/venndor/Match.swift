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
    //var itemName: String!
    var itemID: String!
    var itemName: String!
    var buyerID: String!
    var sellerID: String!
    var sellerName: String! 
    var matchedPrice: Double!
    var thumbnail: UIImage?
    
    init(itemID: String, itemName: String, buyerID: String, sellerID: String, sellerName: String, matchedPrice: Double) {
        //self.itemName = itemName
        self.itemID = itemID
        self.itemName = itemName
        self.buyerID = buyerID
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.matchedPrice = matchedPrice
    }
    
    init(json: JSON) {
        self.id = json["_id"] as? String
        self.itemID = json["itemID"] as! String
        self.itemName = json["itemName"] as! String
        self.buyerID = json["buyerID"] as! String
        self.sellerID = json["sellerID"] as! String
        self.sellerName = json["sellerName"] as! String
        self.matchedPrice = json["matchedPrice"] as! Double
    }
    
}