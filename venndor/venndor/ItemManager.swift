//
//  ItemManager.swift
//  Testing- Backend
//
//  Created by David Tamrazov on 2016-06-18.
//  Copyright © 2016 David Tamrazov. All rights reserved.
//

import Foundation

struct ItemManager {
    
    static let globalManager = ItemManager()
    
    func createItem(item: Item, completionHandler: (ErrorType?) -> () ) {

        let params = ["name": item.name, "details": item.details, "photoCount": item.photoCount, "owner": item.owner, "ownerName": item.ownerName, "category": item.category,  "condition": item.condition, "latitude": item.latitude, "longitude": item.longitude, "question1": item.question1, "question2": item.question2, "minPrice": item.minPrice, "nuSwipesLeft": item.nuSwipesLeft, "nuSwipesRight": item.nuSwipesRight, "nuMatches": item.nuMatches, "offersMade": item.offersMade, "avgOffer": item.avgOffer, "geoHash": item.geoHash] as JSON
    
        RESTEngine.sharedEngine.addItemToServerWithDetails(params,
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    item.id = id as! String
                    RESTEngine.sharedEngine.altAddItemImagesById(item.id, images: item.photos!, success: { success in }, failure: { error in })
                }
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func retrieveItemById(id: String, completionHandler: (Item?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemById(id,
            success: { response in
                if let response = response {
                    let item = Item(json: response)
                    completionHandler(item, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMultipleItems(count: Int, offset: Int?, filter: String?, fields: [String]?, completionHandler: ([Item]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemsFromServer(count, offset: offset, filter: filter, fields: fields,
            success: { response in
                
                if let response = response, result = response["resource"] {
                    var itemsArray = [Item]()
                    let arr = result as! NSArray
                    for data in arr {
                        let data = data as! JSON
                        let item = Item(json: data)
                        
                        self.retrieveItemImageById(item.id, imageIndex: 0) { img, error in
                            guard error == nil else {
                                print("Error pulling item image: \(error)")
                                return
                            }
                            
                            if let img = img {
                                item.photos = [img]
                            }
                        }
                        itemsArray.append(item)
                    }
                    completionHandler(itemsArray, nil)
                }
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveItemIds(count: Int, offset: Int, filter: String?, completionHandler: ([String]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemsFromServer(count, offset: offset, filter: filter, fields: ["_id"],
            success: { response in
                if let ids = response!["resource"] as? Array<Dictionary<String, String>> {
                    var arr = [String]()
                    for data in ids {
                        arr.append(data["_id"]!)
                    }
                    
                    completionHandler(arr, nil)
                }
            }, failure: { error in
                    completionHandler(nil, error)
        })
    }
    
    func retrieveItemImageById(id: String, imageIndex: Int, completionHandler: (UIImage?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getImageFromServerById(id, fileName: "image\(imageIndex)",
            success: { response in
               
                if let response = response, content = response["content"] as? NSString {
                    let fileData = NSData(base64EncodedString: content as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    if let data = fileData {
                        let img = UIImage(data: data)
                        completionHandler(img, nil)
                    }
                        
                    else {
                        print("Error parsing server data into image.")
                        completionHandler(nil, nil)
                    }
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func updateItemById(id: String, update: [String:AnyObject], completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.updateItemById(id, itemDetails: update,
            success: { response in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func updateItemMetrics(items: [Item], completionHandler:(ErrorType?) -> () ) {
        var resourceArray = [[String:AnyObject]]()
        for item in items {
            let updateDict = ["_id": item.id, "nuSwipesLeft": item.nuSwipesLeft!, "nuSwipesRight": item.nuSwipesRight!]
            resourceArray.append(updateDict as! [String : AnyObject])
        }
        
        RESTEngine.sharedEngine.updateItems(resourceArray, success: { _ in }, failure: { error in completionHandler(error) })
    }
    
    func constructFeedFilter() -> String? {
        var ids: String!
        var index = 0
        let seenPosts = LocalUser.seenPosts
        //filter out seenPosts
        for (key, _ ) in seenPosts {
            
            if key == "_id" {
                continue
            }
            else {
                ids = index > 0 ? "\(ids) and (_id != \(key))" : "(_id != \(key))"
            }
            index += 1
        }
        
        //filter out user matches
        for match in LocalUser.matches {
            
            ids = ids == nil ? "(_id != \(match.itemID))" : "\(ids) and (_id != \(match.itemID))"
            
        }
        
        //filter out user's ads
        for (_, value) in LocalUser.user.posts {
            ids = ids == nil ? "(_id != \(value))" : "\(ids) and (_id != \(value))"
        }
        
        //filter by category
        if GlobalItems.currentCategory != nil {
            ids = ids == nil ? GlobalItems.currentCategory : "\(ids) and (category = \(GlobalItems.currentCategory!))"
        }
        
        return ids
    }
    
}





