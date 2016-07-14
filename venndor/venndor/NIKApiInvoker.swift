//
//  NIKApiInvoker.swift
//  SampleAppSwift
//
//  Created by Timur Umayev on 1/4/16.
//  Copyright © 2016 dreamfactory. All rights reserved.
//

import UIKit

final class NIKApiInvoker {

    let queue = NSOperationQueue()
    let cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
    
    /**
     get the shared singleton
    */
    static let sharedInstance = NIKApiInvoker()
    static var __LoadingObjectsCount = 0
    private init() {
    }
    
    private func updateLoadCountWithDelta(countDelta: Int) {
        objc_sync_enter(self)
        NIKApiInvoker.__LoadingObjectsCount += countDelta
        NIKApiInvoker.__LoadingObjectsCount = max(0, NIKApiInvoker.__LoadingObjectsCount)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = NIKApiInvoker.__LoadingObjectsCount > 0
        
        objc_sync_exit(self)
    }
    
    private func startLoad() {
        updateLoadCountWithDelta(1)
    }
    
    private func stopLoad() {
        updateLoadCountWithDelta(-1)
    }
    
    /**
     primary way to access and use the API
     builds and sends an async NSUrl request
     
     - Parameter path: url to service, general form is <base instance url>/api/v2/<service>/<path>
     - Parameter method: http verb
     - Parameter queryParams: varies by call, can be put into path instead of here
     - Parameter body: request body, varies by call
     - Parameter headerParams: user should pass in the app api key and a session token
     - Parameter contentType: json or xml
     - Parameter completionBlock: block to be executed once call is done
    */
    func restPath(path: String, method: String, queryParams: [String: AnyObject]?, body: AnyObject?, headerParams: [String: String]?, contentType: String?, completionBlock: ([String: AnyObject]?, NSError?) -> Void) {
        
        //build the request
        let request = NIKRequestBuilder.restPath(path, method: method, queryParams: queryParams, body: body, headerParams: headerParams, contentType: contentType)
        
        // Handle caching on GET requests

        startLoad() // for network activity indicator
        
        let date = NSDate()
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {(response_data, response, response_error) -> Void in
            self.stopLoad()
            if let response_error = response_error {
                if let response_data = response_data {
                    let results = try? NSJSONSerialization.JSONObjectWithData(response_data, options: [])
                    if let results = results as? [String: AnyObject] {
                        completionBlock(nil, NSError(domain: response_error.domain, code: response_error.code, userInfo: results))
                    } else {
                        completionBlock(nil, response_error)
                    }
                } else {
                    completionBlock(nil, response_error)
                }
                return
            } else {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                if !NSLocationInRange(statusCode, NSMakeRange(200, 99)) {
                    //response_error = NSError(domain: "swagger", code: statusCode, userInfo: try! NSJSONSerialization.JSONObjectWithData(response_data!, options: []) as? [NSObject: AnyObject])
                    completionBlock(nil, response_error)
                    return
                } else {
                    let results = try! NSJSONSerialization.JSONObjectWithData(response_data!, options: []) as! [String: AnyObject]
                    if NSUserDefaults.standardUserDefaults().boolForKey("RVBLogging") {
                        NSLog("fetched results (\(NSDate().timeIntervalSinceDate(date)) seconds): \(results)")
                    }
                    completionBlock(results, nil)
                }
            }
        }
        task.resume()
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {(response, response_data, var response_error) -> Void in
//            self.stopLoad()
//            if let response_error = response_error {
//                if let response_data = response_data {
//                    let results = try? NSJSONSerialization.JSONObjectWithData(response_data, options: [])
//                    if let results = results as? [String: AnyObject] {
//                        completionBlock(nil, NSError(domain: response_error.domain, code: response_error.code, userInfo: results))
//                    } else {
//                        completionBlock(nil, response_error)
//                    }
//                } else {
//                    completionBlock(nil, response_error)
//                }
//                return
//            } else {
//                let statusCode = (response as! NSHTTPURLResponse).statusCode
//                if !NSLocationInRange(statusCode, NSMakeRange(200, 99)) {
//                    response_error = NSError(domain: "swagger", code: statusCode, userInfo: try! NSJSONSerialization.JSONObjectWithData(response_data!, options: []) as? [NSObject: AnyObject])
//                    completionBlock(nil, response_error)
//                    return
//                } else {
//                    let results = try! NSJSONSerialization.JSONObjectWithData(response_data!, options: []) as! [String: AnyObject]
//                    if NSUserDefaults.standardUserDefaults().boolForKey("RVBLogging") {
//                        NSLog("fetched results (\(NSDate().timeIntervalSinceDate(date)) seconds): \(results)")
//                    }
//                    completionBlock(results, nil)
//                }
//            }
//        }
    }
}

final class NIKRequestBuilder {
    
    /**
     Builds NSURLRequests with the format for the DreamFactory Rest API
     
     This will play nice if you want to roll your own set up or use a
     third party library like AFNetworking to send the REST requests
     
     - Parameter path: url to service, general form is <base instance url>/api/v2/<service>/<path>
     - Parameter method: http verb
     - Parameter queryParams: varies by call, can be put into path instead of here
     - Parameter body: request body, varies by call
     - Parameter headerParams: user should pass in the app api key and a session token
     - Parameter contentType: json or xml
     */
    static func restPath(path: String, method: String, queryParams: [String: AnyObject]?, body: AnyObject?, headerParams: [String: String]?, contentType: String?) -> NSURLRequest {
        let request = NSMutableURLRequest()
        var requestUrl = path
        if let queryParams = queryParams {
            // build the query params into the URL
            // ie @"filter" = "id=5" becomes "<url>?filter=id=5
            let parameterString = queryParams.stringFromHttpParameters()
            requestUrl = "\(path)?\(parameterString)"
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("RVBLogging") {
            NSLog("request url: \(requestUrl)")
        }
        
        let URL = NSURL(string: requestUrl)!
        request.URL = URL
        // The cache settings get set by the ApiInvoker
        request.timeoutInterval = 30
        
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.HTTPMethod = method
        
        if let body = body {
            // build the body into JSON
            var data: NSData!
            
            if body is [String: AnyObject] || body is [AnyObject] {
                print("\(body)")
                data = try? NSJSONSerialization.dataWithJSONObject(body, options: [])
                let body2 = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print("\(body2)")
            } else if let body = body as? NIKFile {
                data = body.data
            } else {
                data = body.dataUsingEncoding(NSUTF8StringEncoding)
            }
            let postLength = "\(data.length)"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.HTTPBody = data
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
    
        return request
    
    }
    
}

func createMultipartBody(files: [NIKFile], boundary: String) -> NSData {
    let body = NSMutableData()
    for file in files {
        let filename = file.name
        let data = file.data;
        let mimetype = file.mimeType
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data;filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(data)
        body.appendString("\r\n")
    }
    
    return body
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

extension String {
    
    /** Percent escape value to be added to a URL query value as specified in RFC 3986
    - Returns: Percent escaped string.
    */
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}

extension Dictionary {
    
    /** Build string representation of HTTP parameter dictionary of keys and objects
        This percent escapes in compliance with RFC 3986
    - Returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    */
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
}