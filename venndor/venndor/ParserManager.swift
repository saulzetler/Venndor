//
//  Parser.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-22.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct ParserManager {
    
    static let globalManager = ParserManager()
    
    func getStringArray(response: AnyObject) -> [String] {
        if let arr = response as? NSArray {
            return arr as! [String]
        }
        else {
            let dict = response as? NSDictionary
            var stringArray = [String]()
            for (_, str) in dict! {
                stringArray.append(str as! String)
            }
            return stringArray
        }
    }
    
    func getDoubleArray(response: AnyObject) -> [Double] {
        if let arr = response as? NSArray {
            return arr as! [Double]
        }
        else {
            let dict = response as? NSDictionary
            var doubleArray = [Double]()
            for (_, doub) in dict! {
                doubleArray.append(doub as! Double)
            }
            return doubleArray
        }
    }
    
    func getDict(response: AnyObject) -> [String:AnyObject] {
        if let _ = response as? NSArray {
            return [String:AnyObject]()
        }
        else {
            return response as! [String:AnyObject]
        }
    }
    
    func getDoubleDict(response: AnyObject) -> [String:Double] {
        if let _ = response as? NSArray {
            return [String:Double]()
        }
        else {
            return response as! [String:Double]
        }
    }
    
    func getStringFromPhoto(photo: UIImage) -> String {
        let data = UIImageJPEGRepresentation(photo, 0.5)
        let string = data!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return string
        
    }
    
    func getPhotoFromString(str: String) -> UIImage {
        let dataDecoded:NSData = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        let img = UIImage(data: dataDecoded)
        return img!
    }

}