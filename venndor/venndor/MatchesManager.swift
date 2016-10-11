//
//  MatchesManager.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-05.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class MatchesManager: NSObject {
    
    static let globalManager = MatchesManager()
    
    func createMatch(match: Match, completionHandler: (Match?, ErrorType?) -> () ) {
        
        let params = ["itemID": match.itemID, "itemName": match.itemName, "itemDescription": match.itemDescription, "itemPickupLocation":match.itemPickupLocation, "userID": match.userID, "sellerID": match.sellerID, "sellerName": match.sellerName, "matchedPrice":match.matchedPrice, "bought": match.bought, "dateMatched": TimeManager.formatter.stringFromDate(match.dateMatched)]
        
        RESTEngine.sharedEngine.createMatchOnServer(params as! [String : AnyObject],
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    match.id = id as? String
                    
                    //post the thumbnail to the server
                    RESTEngine.sharedEngine.addImageById(match.id!, image:  match.thumbnail, imageName: "image0",
                        success: { response in
                        }, failure: { error in
                            print("Error creating match thumbnail: \(error)")
                    })
                    
                    completionHandler(match, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMatchById(id: String, completionHandler: (Match?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getMatchById(id,
            success: { response in
                if let response = response {
                    let match = Match(json: response)
                    self.retrieveMatchThumbnail(match) { img, error in
                        guard error == nil else {
                            print("Error retrieving match thumbnail: \(error)")
                            return
                        }
                        
                        if let img = img {
                            match.thumbnail = img
                        }
                        completionHandler(match, nil)
                    }
                    //completionHandler(match, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveMatchByFilter(filter: String, completionHandler:(Match?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getMatchesFromServer(nil, filter: filter, offset: nil, fields: nil,
            success: { response in
                if let response = response, matchArray = response["resource"] as? NSArray, matchData = matchArray[0] as? JSON {
                    let match = Match(json: matchData)
                    
//                    //instantly pull the thumbnail too
//                    self.retrieveMatchThumbnail(match) { img, error in
//                        guard error == nil else {
//                            print("Error retrieving match thumbnail: \(error)")
//                            return
//                        }
//                        if let img = img {
//                            match.thumbnail = img
//                            
//                        }
//                    }
                    completionHandler(match, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveUserMatches(user: User, completionHandler: ([Match]?, ErrorType?) -> () ){
        let filterString = createFilterString(user.matches)
        
        if filterString == "" {
            completionHandler([Match](), nil)
            return
        }
        
        RESTEngine.sharedEngine.getMatchesFromServer(nil, filter: filterString, offset: nil, fields: nil,
            success: { response in
                if let response = response, matchesData = response["resource"] as? NSArray {
                    var matchesArray = [Match]()
    
                    for data in matchesData {
                        let data = data as! JSON
                        
                        let match = Match(json: data)
                        
                        //check if item exists on server- if not, remove this match locally and on the server 
                        ItemManager.globalManager.retrieveItemById(match.itemID) { item, error in
                            guard error == nil else {
                                print("Error pulling item for matches and things.")
                                return
                            }
                            
                            if item == nil {
                                
                                LocalUser.matches = LocalUser.matches.filter({ $0.id != match.id})
                                MatchesManager.globalManager.deleteMatchById(match.id!) { error in
                                    guard error == nil else {
                                        print("Error deleting match from server: \(error)")
                                        return
                                    }
                                }
                            }
                        }
                        
                        //instantly pull the thumbnail too
                        self.retrieveMatchThumbnail(match) { img, error in
                            guard error == nil else {
                                print("Error retrieving match thumbnail: \(error)")
                                return
                            }
                            if let img = img {
                                match.thumbnail = img
                            }
                        }
                        
                        matchesArray.append(match)
                    }
                    completionHandler(matchesArray, nil)
                }
                
            }, failure: {error in
                completionHandler(nil, error)
        })
        
    }
    
    func updateMatchById(id: String, update: JSON, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.updateMatchById(id, matchDetails: update,
            success: { response in completionHandler(nil)}, failure: { error in completionHandler(error)})
    }
    
    func retrieveMatchThumbnail(match: Match, completionHandler: (UIImage?, ErrorType?) -> () ) {

        RESTEngine.sharedEngine.getImageFromServerById(match.id!, fileName: "image0",
            success: { response in
                if let content = response!["content"] as? NSString {
                    let fileData = NSData(base64EncodedString: content as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    if let data = fileData {
                        let img = UIImage(data: data)
                        completionHandler(img, nil)
                    }
                }
                else {
                    print("Error parsing server data into image for match thumbnail.")
                    completionHandler(nil, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func deleteMatchById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.deleteMatchFromServerById(id,
            success: { _ in completionHandler(nil) },
            failure: { error in completionHandler(error)})
    }
    
    func deleteMultipleMatchesById(ids:[String]?, filter: String?, completionHandler: (ErrorType?) -> ()) {
        var resourceArray = [[String:AnyObject]]()

        if let ids = ids {
            for id in ids {
                let dict = ["_id": id]
                resourceArray.append(dict)
            }
        }
        
        RESTEngine.sharedEngine.deleteMultipleMatchesFromServer(resourceArray, filter: filter,
            success: { _ in completionHandler(nil) }, failure: { error in completionHandler(error)})
    }
    
    func createFilterString(matches: [String:AnyObject]) -> String {
        var filterString = ""
        var index = 0
        for (key, _) in matches {
            filterString = index == 0 ? "(_id = \(key))" : "\(filterString) or (_id = \(key))"
            index += 1
        }
        
       return filterString
    }
}