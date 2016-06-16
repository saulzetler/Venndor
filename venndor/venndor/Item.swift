//
//  Item.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

class Item: NSObject {
    var title: String
    var details: String
    var id: String
    
    init(json: JSON) {
        title = json["title"] as! String
        details = json["details"] as! String
        id = json["_id"] as! String
    }
}