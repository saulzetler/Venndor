//
//  SeenPostsManager.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct SeenPostsManager {
    
    static let globalManager = SeenPostsManager()
    
    func createSeenPostsById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.createSeenPosts(id,
            success: { response in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func getSeenPostsById(id: String, completionHandler: ([String:AnyObject]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getSeenPostsById(id,
            success: { response in
                let seenPosts = self.datesFromStrings(response!)
                completionHandler(seenPosts, nil)
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func updateSeenPostsById(id: String, completionHandler: (ErrorType?) -> () ) {
        let update = stringsFromDates(LocalUser.seenPosts)
        RESTEngine.sharedEngine.updateSeenPostsById(id, update: update, success: { response in }, failure: { error in })
    }
    
    func patchSeenPostsById(id: String, completionHandler: (ErrorType?) -> () ) {
        let patch = stringsFromDates(LocalUser.seenPosts)
        RESTEngine.sharedEngine.patchSeenPostsById(LocalUser.user.id, patch: patch,
            success: { _ in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func deleteSeenPostsById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.removeSeenPostsById(id,
            success: { response in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })

    }
    
    func stringsFromDates(dates: [String:AnyObject]) -> [String:AnyObject] {
        var dateStringDict = [String:AnyObject]()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        for (key, value) in dates {
            if key == "_id" {
                dateStringDict[key] = value
                continue
            }
            
            dateStringDict[key] = formatter.stringFromDate(value as! NSDate)
        }
        
        return dateStringDict
    }
    
    func datesFromStrings(strings: [String:AnyObject]) -> [String:AnyObject] {
        var dateDict = [String:AnyObject]()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        for (key, value) in strings {
            if key == "_id" {
                dateDict[key] = value
                continue
            }
            
            dateDict[key] = formatter.dateFromString(value as! String)
        }
        
        return dateDict
    }
    
}