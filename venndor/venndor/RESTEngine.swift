//
//  RESTEngine.swift
//  SampleAppSwift
//
//  Created by Timur Umayev on 1/8/16.
//  Copyright © 2016 dreamfactory. All rights reserved.
//

import UIKit

let kAppVersion = "1.0.1"

// change kApiKey and kBaseInstanceUrl to match your app and instance

// API key for your app goes here, see apps tab in admin console
private let kApiKey = "58bbaee4c53d3643eb0c01211ed537b8ba3bae6d9269503ae1c55916e75f47f2"
private let kBaseInstanceUrl = "http://bitnami-dreamfactory-000b.cloudapp.net/api/v2"
private let kDbServiceName = "venndor/_table"

typealias JSON = [String: AnyObject]
typealias JSONArray = [JSON]

typealias SuccessClosure = (JSON?) -> Void
typealias ErrorClosure = (NSError) -> Void

extension NSError {
    
    var errorMessage: String {
        if let errorMessage = self.userInfo["error"]?["message"] as? String {
            return errorMessage
        }
        return "Unknown error occurred"
    }
}

/**
 Routing to different type of API resources
 */
enum Routing {
    case User(resourseName: String)
    case Service(tableName: String)
    case ResourceFolder(folderPath: String)
    case ResourceFile(folderPath: String, fileName: String)
    
    var path: String {
        switch self {
            //rest path for request, form is <base instance url>/api/v2/user/resourceName
        case let .User(resourceName):
            return "\(kBaseInstanceUrl)/user/\(resourceName)"
            
            //rest path for request, form is <base instance url>/api/v2/<serviceName>/<tableName>
        case let .Service(tableName):
            return "\(kBaseInstanceUrl)/\(kDbServiceName)/\(tableName)"
            
            // rest path for request, form is <base instance url>/api/v2/files/container/<folder path>/
        case let .ResourceFolder(folderPath):
            return "\(kBaseInstanceUrl)/files/\(folderPath)/"
            
            //rest path for request, form is <base instance url>/api/v2/files/container/<folder path>/filename
        case let .ResourceFile(folderPath, fileName):
            return "\(kBaseInstanceUrl)/files/\(folderPath)/\(fileName)"
        }
    }
}

final class RESTEngine {
    static let sharedEngine = RESTEngine()
    
    let headerParams: [String: String] = {
        let dict = ["X-DreamFactory-Api-Key": kApiKey]
        return dict
    }()
    
    /*
    var sessionHeaderParams: [String: String] {
        var dict = headerParams
        dict["X-DreamFactory-Session-Token"] = sessionToken
        return dict
    }
    */
    
    private let api = NIKApiInvoker.sharedInstance
    
    private init() {
    }
    
    private func callApiWithPath(restApiPath: String, method: String, queryParams: [String: AnyObject]?, body: AnyObject?, headerParams: [String: String]?, success: SuccessClosure?, failure: ErrorClosure?) {
        api.restPath(restApiPath, method: method, queryParams: queryParams, body: body, headerParams: headerParams, contentType: "application/json", completionBlock: { (response, error) -> Void in
            if let error = error where failure != nil {
                failure!(error)
            } else if let success = success {
                success(response)
            }
        })
    }
    
    
    
    
    //MARK: - Post Methods
    
    func createPostOnServer(params: [String:AnyObject], success: SuccessClosure, failure: ErrorClosure) {
        let requestBody: [String:AnyObject] = ["resource": params]
        callApiWithPath(Routing.Service(tableName: "posts").path, method: "POST", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getPostById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "posts").path)/\(id)"
        
        callApiWithPath(path, method: "GET", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getPostsFromServer(count: String?, filter: String?, offset: Int?, fields: [String]?, success: SuccessClosure, failure: ErrorClosure) {
        var queryParams = [String:AnyObject]()
        
        if let count = count {
            queryParams["count"] = count
        }
        
        if let filter = filter {
            queryParams["filter"] = filter
        }
        
        if let offset = offset {
            queryParams["offset"] = offset
        }
        
        if let fields = fields {
            queryParams["fields"] = fields
        }
        
        callApiWithPath(Routing.Service(tableName: "posts").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func updatePostById(id: String, postDetails: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        // set the id of the contact we are looking at
        let requestBody: [String: AnyObject] = postDetails
        let path = "\(Routing.Service(tableName: "posts").path)/\(id)"
        
        callApiWithPath(path, method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }

    func deletePostFromServerById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        //first remove the post image folder, then the post object
        removeImageFolderById(id,
            success: { _ in
                let path = "\(Routing.Service(tableName: "posts").path)/\(id)"
                
                self.callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: self.headerParams, success: success, failure: failure)
                
            }, failure: { _ in })
    }

    func deleteMultiplePostsFromServer(body: [[String:AnyObject]]?, success: SuccessClosure, failure: ErrorClosure) {
        var requestBody: [String: AnyObject]?

        
        if let body = body {
            requestBody = ["resource":body]
        } else {
            requestBody = nil
        }
    
        callApiWithPath(Routing.Service(tableName: "posts").path, method: "DELETE", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    
    
    //MARK: - Matches Methods
    
    func createMatchOnServer(params: [String:AnyObject], success: SuccessClosure, failure: ErrorClosure) {
        let requestBody: [String:AnyObject] = ["resource": params]
        
        callApiWithPath(Routing.Service(tableName: "matches").path, method: "POST", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getMatchById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "matches").path)/\(id)"
        
        callApiWithPath(path, method: "GET", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getMatchesFromServer(count: Int?, filter: String?, offset: Int?, fields: [String]?, success: SuccessClosure, failure: ErrorClosure) {
        var queryParams = [String:AnyObject]()
        
        if let count = count {
            queryParams["count"] = count
        }
        
        if let filter = filter {
            queryParams["filter"] = filter
        }
        
        if let offset = offset {
            queryParams["offset"] = offset
        }
        
        if let fields = fields {
            queryParams["fields"] = fields
        }
        
        callApiWithPath(Routing.Service(tableName: "matches").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func updateMatchById(id: String, matchDetails: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        // set the id of the contact we are looking at
        let requestBody: [String: AnyObject] = matchDetails
        let path = "\(Routing.Service(tableName: "matches").path)/\(id)"
        
        callApiWithPath(path, method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func deleteMatchFromServerById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        //remove the image folder first, then the match object
        removeImageFolderById(id,
            success: { _ in
                let path = "\(Routing.Service(tableName: "matches").path)/\(id)"
                
                self.callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: self.headerParams, success: success, failure: failure)

            }, failure: { _ in })
    }
    
    func deleteMultipleMatchesFromServer(body: [[String:AnyObject]]?, filter: String?, success: SuccessClosure, failure: ErrorClosure) {
        var requestBody: [String: AnyObject]?
        var queryParams: [String: AnyObject]?
        if let body = body {
            requestBody = ["resource":body]
        } else {
            requestBody = nil
        }
        
        if let filter = filter {
            queryParams = ["filter":filter]
        } else {
            queryParams = nil
        }
        
        callApiWithPath(Routing.Service(tableName: "matches").path, method: "DELETE", queryParams: queryParams, body: requestBody, headerParams: headerParams, success: success, failure: failure)
        
    }
    
    
    //MARK: - Seen Posts methods
    
    func createSeenPosts(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let params = ["_id": id]
        
        let requestBody: [String: AnyObject] = ["resource": params]
        callApiWithPath(Routing.Service(tableName:"seenPosts").path, method: "POST", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getSeenPostsById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "seenPosts").path)/\(id)"
        
        callApiWithPath(path, method: "GET", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func updateSeenPostsById(id: String, update: [String:AnyObject], success: SuccessClosure, failure: ErrorClosure) {
        let params = update
        let path = "\(Routing.Service(tableName: "seenPosts").path)/\(id)"
        
        callApiWithPath(path, method: "PATCH", queryParams: nil, body: params, headerParams: headerParams, success: success, failure: failure)
    }
    
    func patchSeenPostsById(id: String, patch: [String:AnyObject], success: SuccessClosure, failure: ErrorClosure) {
        let requestBody = ["resource": patch]
        
        callApiWithPath(Routing.Service(tableName: "seenPosts").path, method: "PUT", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func removeSeenPostsById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "seenPosts").path)/\(id)"
        callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    
    
    
    
    
    
    //MARK: - User methods
    
    func registerUser(params: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        let requestBody: [String: AnyObject] = ["resource": params]
        
        callApiWithPath(Routing.Service(tableName: "users").path, method: "POST", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Get a single user from the server
     */
    
    func getUserByEmail(email: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // create filter to get info only for this contact
        let queryParams = ["filter": "email=\(email)"]
        callApiWithPath(Routing.Service(tableName: "users").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getUserById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "users").path)/\(id)"
        callApiWithPath(path, method: "GET", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
    Get multiple users from server
    */
    
    func getUsersByIds(ids: String, success: SuccessClosure, failure: ErrorClosure) {
        let queryParams = ["filter":ids]
        callApiWithPath(Routing.Service(tableName: "users").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }

    /**
     Remove user from server
     */
    func removeUserById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        // remove user by user ID
        removeImageFolderById(id, success: { _ in
            
            let path = "\(Routing.Service(tableName: "users").path)/\(id)"
            self.callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: self.headerParams, success: success, failure: failure)
            
            }, failure: failure)
    }
    
    /**
     Update an existing user with the server
     */
    func updateUserById(id: String, info: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        let requestBody: [String: AnyObject] = info
        let path = "\(Routing.Service(tableName: "users").path)/\(id)"
        
        callApiWithPath(path, method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func updateUsers(update: [JSON], success: SuccessClosure, failure: ErrorClosure) {
        let requestBody = ["resource":update]
        callApiWithPath(Routing.Service(tableName: "users").path, method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }

    
    
    
 
    
    //MARK: - Item methods
    
    /**
     Add an item to the server
    */
    
    func addItemToServerWithDetails(itemDetails: JSON, success: SuccessClosure, failure: ErrorClosure) {
        // need to create contact first, then can add contactInfo and group relationships
        
        let requestBody: [String: AnyObject] = ["resource": itemDetails]
        
        callApiWithPath(Routing.Service(tableName: "items").path, method: "POST", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Remove item from the server
    */
    
    func deleteItemFromServerById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        //first remove the folder and all images associated with it, then wipe the item
        removeImageFolderById(id, success: { _ in
            let path = "\(Routing.Service(tableName: "items").path)/\(id)"
            
            self.callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: self.headerParams, success: success, failure: failure)
            
            }, failure: { error in
                print("Error deleting image folder from server: \(error)")
        })

        
    }
    
    /**
     Get Item by its ID
     */
    
    func getItemById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "items").path)/\(id)"
        
        callApiWithPath(path, method: "GET", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Get a whole mess of items
     */
    
    func getItemsFromServer(count: Int, offset: Int?, filter: String?, fields:[String]?, success: SuccessClosure, failure: ErrorClosure) {
        
        var queryParameters: [String: AnyObject] = ["limit": "\(count)"]
        
        if let offset = offset {
            queryParameters["offset"] = "\(offset)"
        }
        
        if let filter = filter {
            queryParameters["filter"] = filter
        }
        
        if let fields = fields {
            queryParameters["fields"] = fields
        }
        callApiWithPath(Routing.Service(tableName: "items").path, method: "GET", queryParams: queryParameters, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    /**
     Update items and users with the server
     */
    func updateItemById(id: String, itemDetails: JSON, success: SuccessClosure, failure: ErrorClosure) {
        
        // set the id of the contact we are looking at
        let requestBody: [String: AnyObject] = itemDetails
        let path = "\(Routing.Service(tableName: "items").path)/\(id)"
        
        callApiWithPath(path, method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    
    /**
     Update multiple items at once
    */
    
    func updateItems(update: [[String:AnyObject]], success: SuccessClosure, failure: ErrorClosure) {
        let requestBody: [String:AnyObject] = ["resource": update]
        callApiWithPath(Routing.Service(tableName: "items").path, method: "PATCH", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    func deleteMultipleItemsFromServer(body: [[String:AnyObject]]?, success: SuccessClosure, failure: ErrorClosure) {
        var requestBody: [String: AnyObject]?
        
        
        if let body = body {
            requestBody = ["resource":body]
        } else {
            requestBody = nil
        }
        
        callApiWithPath(Routing.Service(tableName: "items").path, method: "DELETE", queryParams: nil, body: requestBody, headerParams: headerParams, success: success, failure: failure)
    }
    
    
    
    //MARK: - Image methods
    
    /**
    Create item image on server
    */
    func addImageById(id: String, image: UIImage, imageName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // first we need to create folder, then image
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "POST", queryParams: nil, body: nil, headerParams: headerParams, success: { _ in
            
            self.putImageToFolderWithPath(id, image: image, fileName: imageName, success: success, failure: failure)
            }, failure: failure)
    }
    
    
    func addItemImagesById(id: String, images: [UIImage], success: SuccessClosure, failure: ErrorClosure) {
        //first create the folder
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "POST", queryParams: nil, body: nil, headerParams: headerParams, success: { _ in
            
            var i = 0
            for image in images {
                self.putImageToFolderWithPath("\(id)", image: image, fileName: "image\(i)", success: success, failure: failure)
                i += 1
            }
            
            }, failure: failure)
    }
    
    //function that actually posts the image to the appropriate folder
    func putImageToFolderWithPath(folderPath: String, image: UIImage, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let file = NIKFile(name: fileName, mimeType: "image/jpeg", data: imageData!)
        
        callApiWithPath(Routing.ResourceFile(folderPath: folderPath, fileName: fileName).path, method: "POST", queryParams: nil, body: file, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getImageFromServerById(id: String, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // request a download from the file
        let queryParams: [String: AnyObject] = ["include_properties": "1",
            "content": "1",
            "download": "1"]
        
        callApiWithPath(Routing.ResourceFile(folderPath: "/\(id)", fileName: fileName).path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func removeImageFromServerById(id: String, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        callApiWithPath(Routing.ResourceFile(folderPath: "\(id)", fileName: fileName).path, method: "DELETE", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func removeImageFolderById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // delete all files and folders in the target folder
        let queryParams: [String: AnyObject] = ["force": "1"]
        
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "DELETE", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
}
