//
//  Item.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation
import UIKit

struct GlobalItems {
    static var items = [Item]()
    static var currentCategory: String?
    static var currentSearch = [String]()
}

class Item: NSObject {
    var name: String
    var details: String
    var id: String!
    var photos: [UIImage]?
    var photoCount: Int!
    var owner: String
    var ownerName: String
    var category: String
    var condition: Int
    var latitude: Double
    var longitude: Double
    var question1: String
    var question2: String
    var minPrice: Int
//    var previousOffers: [Double]
    
    //photos, name/title, category, question1, question2, condition, description, address, minPrice
    
    //init from the server
    init(json: JSON) {
        name = json["name"] as! String
        details = json["details"] as! String
        id = json["_id"] as! String
        photoCount = json["photoCount"] as! Int
        owner = json["owner"] as! String
        ownerName =  json["ownerName"] as! String
        category = json["category"] as! String
        condition = json["condition"] as! Int
        latitude = json["locationX"] as! Double
        longitude = json["locationY"] as! Double
        question1 = json["question1"] as! String
        question2 = json["question2"] as! String
        minPrice = json["minPrice"] as! Int
//        previousOffers = json["previousOffers"] as! [Double]
    }
    
    //init from the app
    init(name: String, description: String, owner: String, ownerName: String, category: String, condition: Int, latitude: Double, longitude: Double, photos: [UIImage], question1: String, question2: String, minPrice: Int) {
        self.name = name
        self.details = description
        self.owner = owner
        self.ownerName = ownerName
        self.photos = photos
        self.photoCount = photos.count
        self.category = category
        self.condition = condition
        self.latitude = latitude
        self.longitude = longitude
        self.question1 = question1
        self.question2 = question2
        self.minPrice = minPrice
//        self.previousOffers = [Double]()
    }

    /*
    
    func getImagesFromStrings(imageStrings: [String]) {
        var images = [UIImage]()
        for str in imageStrings {
            let data = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let img = UIImage(data: data!)
            images.append(img!)
        }
        self.photos = images
    }
    
    func getStringsFromImages(images: [UIImage]) {
        var imageStrings = [String]()
        for img in images {
            let imgData = UIImageJPEGRepresentation(img, 1.0)
            var imgString: String?
            if let data = imgData {
                imgString = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
            }
            if let str = imgString {
                imageStrings.append(str)
            }
        }
        self.photoStrings = imageStrings
    }
    */
}