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
        let params = ["itemID": match.itemID, "itemName": match.itemName, "itemDescription": match.itemDescription, "userID": match.sellerID, "sellerID": match.sellerID, "sellerName": match.sellerName, "matchedPrice":match.matchedPrice, "itemLongitude": match.itemLongitude, "itemLatitude": match.itemLatitude, "bought": match.bought, "dateMatched": TimeManager.formatter.stringFromDate(match.dateMatched)]
        
        RESTEngine.sharedEngine.createMatchOnServer(params as! [String : AnyObject],
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    match.id = id as? String
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
                    completionHandler(match, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
        
    }
    
    func retrieveUserMatches(user: User, completionHandler: ([Match]?, ErrorType?) -> () ){
        let filterString = createFilterString(user.matches)
        RESTEngine.sharedEngine.getMatchesFromServer(nil, filter: filterString, offset: nil, fields: nil,
            success: { response in
                if let response = response, matchesData = response["resource"] as? NSArray {
                    var matchesArray = [Match]()
    
                    for data in matchesData {
                        let data = data as! JSON
                        let match = Match(json: data)
                        matchesArray.append(match)
                    }
                    
                    completionHandler(matchesArray, nil)
                }
            }, failure: {error in
                completionHandler(nil, error)
        })
        
    }
    
    func retrieveMatchThumbnail(match: Match, completionHandler: (UIImage?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getImageFromServerById(match.itemID, fileName: "image0",
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