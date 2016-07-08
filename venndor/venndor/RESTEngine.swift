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
    //MARK: - Matches Methods
    
    func createMatchOnServer(match: Match, success: SuccessClosure, failure: ErrorClosure) {
        let params = ["itemID": match.itemID, "buyerID": match.buyerID, "sellerID": match.sellerID, "offeredPrice":match.offeredPrice]
        
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
    
    func deleteMatchFromServerById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        let path = "\(Routing.Service(tableName: "matches").path)/\(id)"
        
        callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
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
    
    func registerUser(email: String, firstName: String, lastName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        let params: [String: AnyObject] =
        ["email": email,
            "first_name": firstName,
            "last_name": lastName,
            "rating": 0.0,
            "nuMatches": 0,
            "nuItemsSold": 0,
            "nuItemsBought": 0,
            "soldItems": [String](),
            "ads": [String](),
            "matches": [String](),
            "boughtItems": [String](),
            "moneySaved": 0]
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
    
    func removeItemFromServerById(id: String, success: SuccessClosure, failure: ErrorClosure) {

        let path = "\(Routing.Service(tableName: "items").path)/\(id)"
        
        callApiWithPath(path, method: "DELETE", queryParams: nil, body: nil, headerParams: headerParams, success: success, failure: failure)
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
  
    
    
    
    
    
    
    
    //MARK: - Image methods
    
    /**
    Create item image on server
    */
    func addItemImageById(id: String, image: UIImage, imageName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // first we need to create folder, then image
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "POST", queryParams: nil, body: nil, headerParams: headerParams, success: { _ in
            
            self.putImageToFolderWithPath(id, image: image, fileName: imageName, success: success, failure: failure)
            }, failure: failure)
    }
    
    /*
    func addItemImagesById(id: String, images: [UIImage], success: SuccessClosure, failure: ErrorClosure) {
        
        //first create the folder
        
        self.putImagesToFolderWithPath(id, images: images, success: success , failure: failure)
    }
    */
    
    //alternative, dumb way of doing it. Make a separate API call for every image to upload
    func altAddItemImagesById(id: String, images: [UIImage], success: SuccessClosure, failure: ErrorClosure) {
        //first create the folder
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "POST", queryParams: nil, body: nil, headerParams: headerParams, success: { _ in
            
            var i = 0
            for image in images {
                self.putImageToFolderWithPath("\(id)", image: image, fileName: "image\(i)", success: success, failure: failure)
                i += 1
            }
            
            }, failure: failure)
    }
    
    
    /*
    
    //try posting every image at once
    func putImagesToFolderWithPath(folderPath: String, images: [UIImage], success: SuccessClosure, failure: ErrorClosure) {
        var i = 0
        var files = [NIKFile]()
        for image in images {
            let imageData = UIImageJPEGRepresentation(image, 0.1)
            let file = NIKFile(name: "image\(i)", mimeType: "application/octet-stream", data: imageData!)
            files.append(file)
            i++
        }
        
        callApiWithPath(Routing.ResourceFolder(folderPath: folderPath).path, method: "POST", queryParams: nil, body: files, headerParams: headerParams, success: { success in }, failure: { error in print("Error posting to folder/files to server: \(error)") })
    }
    */
    
    
    func putImageToFolderWithPath(folderPath: String, image: UIImage, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let file = NIKFile(name: fileName, mimeType: "image/jpeg", data: imageData!)
        
        callApiWithPath(Routing.ResourceFile(folderPath: folderPath, fileName: fileName).path, method: "POST", queryParams: nil, body: file, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getImageListFromServerById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // only want to get files, not any sub folders
        let queryParams: [String: AnyObject] = ["include_folders": "0",
            "include_files": "1"]
        
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    func getImageFromServerById(id: String, fileName: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // request a download from the file
        let queryParams: [String: AnyObject] = ["include_properties": "1",
            "content": "1",
            "download": "1"]
        
        callApiWithPath(Routing.ResourceFile(folderPath: "/\(id)", fileName: fileName).path, method: "GET", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
    
    private func removeImageFolderById(id: String, success: SuccessClosure, failure: ErrorClosure) {
        
        // delete all files and folders in the target folder
        let queryParams: [String: AnyObject] = ["force": "1"]
        
        callApiWithPath(Routing.ResourceFolder(folderPath: "\(id)").path, method: "DELETE", queryParams: queryParams, body: nil, headerParams: headerParams, success: success, failure: failure)
    }
}
