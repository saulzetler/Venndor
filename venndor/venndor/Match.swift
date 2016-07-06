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
    var buyerID: String!
    var sellerID: String!
    var offeredPrice: Double!
    
    init(itemID: String, buyerID: String, sellerID: String, offeredPrice: Double) {
        self.itemID = itemID
        self.buyerID = buyerID
        self.sellerID = sellerID
        self.offeredPrice = offeredPrice
    }
    
    init(json: JSON) {
        self.id = json["_id"] as? String
        self.itemID = json["itemID"] as! String
        self.buyerID = json["buyerID"] as! String
        self.sellerID = json["sellerID"] as! String
        self.offeredPrice = json["offeredPrice"] as! Double
    }
    
}