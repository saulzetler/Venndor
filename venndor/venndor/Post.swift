//
//  Post.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-26.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class Post: NSObject {
    var id: String!
    var itemID: String!
    var itemName: String!
    var itemDescription: String!
    var userID: String!
    var buyerID: String!   //to be set when item is sold
    var buyerName: String! //to be set when item is sold
    var minPrice: Int!
    var soldPrice: Double! //to be set when item is sold
    var thumbnailString: String!
    var thumbnail: UIImage!
    var itemLongitude: Double!
    var itemLatitude: Double!
    var sold: Int!
    var dateSold: NSDate! //to be set when item is sold
    
    init(itemID: String, itemName: String, itemDescription: String, userID: String, minPrice: Int, thumbnail: UIImage, thumbnailString: String, itemLongitude: Double!, itemLatitude: Double!) {
        self.itemID = itemID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.userID = userID
        self.minPrice = minPrice
        self.thumbnailString = thumbnailString
        self.thumbnail = thumbnail
        self.itemLongitude = itemLongitude
        self.itemLatitude = itemLatitude
        self.sold = 0
    }
    
    init(json: JSON) {
        self.id = json["_id"] as! String
        self.itemID = json["itemID"] as! String
        self.itemName = json["itemName"] as! String
        self.itemDescription = json["itemDescription"] as! String
        self.userID = json["userID"] as! String
        self.buyerID = json["buyerID"] == nil ? nil : json["buyerID"] as! String
        self.buyerName = json["buyerName"] == nil ? nil : json["buyerName"] as! String
        self.minPrice = json["minPrice"] as! Int
        self.soldPrice = json["soldPrice"] == nil ? nil : json["soldPrice"] as! Double
        self.thumbnail = ParserManager.globalManager.getPhotoFromString(json["thumbnailString"] as! String)
        self.itemLongitude = json["itemLongitude"] as! Double
        self.itemLatitude = json["itemLatitude"] as! Double
        self.sold = json["sold"] as! Int
        self.dateSold = json["dateSold"] == nil ? nil : TimeManager.formatter.dateFromString(json["dateSold"]! as! String)
    }
}