//
//  Parser.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-22.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct ParserManager {
    
    func getArray(response: AnyObject) -> [String] {
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
}