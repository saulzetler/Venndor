//
//  PostManager.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-26.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation


class PostManager: NSObject {
   static let globalManager = PostManager()
    
    func createPost(post: Post, completionHandler: (Post?, ErrorType?) -> () ) {
        
        //parameters to be posted
        let params = ["itemID": post.itemID, "itemName": post.itemName, "itemDescription": post.itemDescription, "userID": post.userID, "minPrice": post.minPrice, "itemLongitude": post.itemLongitude, "itemLatitude": post.itemLatitude, "sold": post.sold]
        
        //post the data to the server
        RESTEngine.sharedEngine.createPostOnServer(params as! [String : AnyObject],
            success: { response in
                if let response = response, result = response["resource"], id = result[0]["_id"] {
                    post.id = id as! String
                    
                    //post the thumbnail to the server
                    RESTEngine.sharedEngine.addImageById(post.id!, image: post.thumbnail, imageName: "image0",
                        success: { response in
                        }, failure: { error in
                            print("Error posting Post thumbnail to server: \(error)")
                    })
                    
                    completionHandler(post, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrievePostById(id: String, completionHandler: (Post?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getPostById(id,
            success: { response in
                if let response = response {
                    let post = Post(json: response)
                    self.retrievePostThumbnail(post) { img, error in
                        guard error == nil else {
                            print("Error retrieivng post thumbnail: \(post)")
                            return
                        }
                        
                        if let img = img {
                            post.thumbnail = img
                            
                        }
                        
                        completionHandler(post, nil)
                    }
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrievePostByFilter(filter: String, completionHandler:(Post?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getPostsFromServer(nil, filter: filter, offset: nil, fields: nil,
            success: { response in
                if let response = response, postArray = response["resource"] as? NSArray, postData = postArray[0] as? JSON {
                    let post = Post(json: postData)
                                                            
                    //instantly pull the thumbnail too
                    self.retrievePostThumbnail(post) { img, error in
                        guard error == nil else {
                            print("Error retrieving match thumbnail: \(error)")
                            return
                        }
                        if let img = img {
                            post.thumbnail = img
                                                                    
                        }
                    }
                completionHandler(post, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func retrieveUserPosts(user: User, completionHandler: ([Post]?, ErrorType?) -> () ) {
        let filterString = createFilterString(user.posts)
        if filterString == "" {
            completionHandler([Post](), nil)
            return
        }
        RESTEngine.sharedEngine.getPostsFromServer(nil, filter: filterString, offset: nil, fields: nil,
            success: { response in
                if let response = response, postsData = response["resource"] as? NSArray {
                    var postsArray = [Post]()
                    for data in postsData {
                        let data = data as! JSON
                        let post = Post(json: data)
                        
                        self.retrievePostThumbnail(post) { img, error in
                            guard error == nil else {
                                print("Error retrieivng post thumbnail: \(error)")
                                return
                            }
                            
                            if let img = img {
                                post.thumbnail = img
                            }
                        }
                        postsArray.append(post)
                    }
                    
                    completionHandler(postsArray, nil)
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
        
    }
    
    func retrievePostThumbnail(post: Post, completionHandler: (UIImage?, ErrorType?) -> () ) {
        RESTEngine.sharedEngine.getImageFromServerById(post.id, fileName: "image0",
            success: { response in
                if let content = response!["content"] as? NSString {
                    let fileData = NSData(base64EncodedString: content as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    if let data = fileData {
                        let img = UIImage(data:data)
                        completionHandler(img, nil)
                    }
                    else {
                        print("Error parsing server data into image for post thumbnail")
                        completionHandler(nil, nil)
                    }
                }
            }, failure: { error in
                completionHandler(nil, error)
        })
    }
    
    func updatePostById(id: String, update: JSON, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.updatePostById(id, postDetails: update,
            success: { response in
                completionHandler(nil)
            }, failure: { error in
                completionHandler(error)
        })
    }
    
    func deletePostById(id: String, completionHandler: (ErrorType?) -> () ) {
        RESTEngine.sharedEngine.deletePostFromServerById(id, success: { _ in completionHandler(nil)}, failure: { error in completionHandler(error)})
    }
    
    func deleteMultiplePostsById(ids:[[String:AnyObject]], completionHandler: (ErrorType?) -> ()) {
        RESTEngine.sharedEngine.deleteMultiplePostsFromServer(ids,
            success: { _ in completionHandler(nil) }, failure: { error in completionHandler(error)})
    }
    
    func createFilterString(posts: [String:AnyObject]) -> String {
        var filterString = ""
        var index = 0
        for (key, _) in posts {
            filterString = index == 0 ? "(_id = \(key))" : "\(filterString) or (_id = \(key))"
            index += 1
        }
        return filterString
    }
}
