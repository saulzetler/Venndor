//
//  SeenPostsManager.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-28.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct SeenPostsManager {
    
    func createSeenPostsById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.createSeenPosts(id,
            success: { response in
                print("\(response)")
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func getSeenPostsById(id: String, completionHandler: ([String:AnyObject]?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getSeenPostsById(id,
            success: { response in
                completionHandler(response, nil)
                
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func updateSeenPostsById(id: String, update: [String:AnyObject], completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.updateSeenPostsById(id, update: update, success: { response in }, failure: { error in })
    }
    
    func deleteSeenPostsById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.removeSeenPostsById(id,
            success: { response in
                print("\(response)")
                completionHandler(nil)
            }, failure: { error in
                print("\(error)")
                completionHandler(nil)
        })

    }
    
}