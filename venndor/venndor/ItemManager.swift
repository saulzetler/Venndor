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

        let params = ["name": item.name, "details": item.details, "photoCount": item.photoCount, "owner": item.owner, "category": item.category,  "condition": item.condition, "locationX": item.locationX, "locationY": item.locationY, "question1": item.question1, "question2": item.question2, "minPrice": item.minPrice] as JSON
    
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
    
    func retrieveItem(offset: Int?, filter: String?, fields: [String]?, completionHandler: (Item?, ErrorType?) -> () ) {
        retrieveMultipleItems(1, offset: offset, filter: filter, fields: fields) { items, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let items = items {
                
                //check if theres an item for us to return 
                if items.count == 0 {
                    completionHandler(nil, nil)
                }
                else {
                    completionHandler(items[0], nil)
                }
            }
        }
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
                
                if let content = response!["content"] as? NSString {
                    let fileData = NSData(base64EncodedString: content as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    if let data = fileData {
                        let img = UIImage(data: data)
                        print("YYYYAARRGGGGHHHH!!!!")
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
    
}





