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
        var imageStrings = [String]()
        if let photos = item.photos {
            imageStrings = item.getStringsFromImages(photos)
        }
        
        let params = ["name": item.name, "details": item.details, "owner": item.owner, "photoStrings": imageStrings]
        RESTEngine.sharedEngine.addItemToServerWithDetails(params as! JSON,
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    item.id = id as! String
                }
                
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func retrieveItem(id: String, completionHandler: (Item?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemById(id,
            success: { response in
                if let response = response {
                    let imageStrings = response["photos"] as! [String]
                    let item = Item(json: response)
                    item.photos = item.getImagesFromStrings(imageStrings)
                    completionHandler(item, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMultipleItems(count: Int, filter: String?, completionHandler: ([Item]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getItemsFromServer(count, filter: filter,
            success: { response in
                if let response = response, result = response["resource"] {
                    var itemsArray = [Item]()
                    let arr = result as! NSArray
                    for data in arr {
                        let data = data as! JSON
                        let item = Item(json: data)
                        itemsArray.append(item)
                    }
                    completionHandler(itemsArray, nil)
                }
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }

}




