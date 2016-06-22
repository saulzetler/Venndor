//
//  ImageManager.swift
//  venndor
//
//  Created by David Tamrazov on 2016-06-21.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct ImageManager {
    
    func saveImagetoServer(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let dataString = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        let imgParam = ["arthas": dataString!]
        RESTEngine.sharedEngine.addItemToServerWithDetails(imgParam,
            success: { response in
                print("\(response)")
                
            }, failure: { error in
                print("\(error)")
        })
    }
    
    func pullImageFromServer(id: String) {
        RESTEngine.sharedEngine.getItemById(id,
            success: { response in
                if let response = response, dataString = response["arthas"] {
                    let data = NSData(base64EncodedString: dataString as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    let image = UIImage(data: data!)
                    print("Image Shiet")
                }

            }, failure: { error in
                print("\(error)")
        })
    }
}