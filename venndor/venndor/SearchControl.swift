//
//  SearchControl.swift
//  venndor
//
//  Created by Tynan Davis on 2016-07-18.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct SearchControl {
    func SearchFor(searchString: String){
        
        
        let characterset = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if searchString.rangeOfCharacterFromSet(characterset.invertedSet) != nil {
            print("string contains special characters")
        }
        let formatString = searchString.lowercaseString
        let searchTerms = formatString.characters.split{$0 == " "}.map(String.init)
        let uselessWords = ["the","aboard","about","above","across","after","against","along","a","amid","at","among","anti","around","as","before","behind","below","beneath","beside","besides","between","beyond","but","by","concerning","considering","despite","down","during","except","excepting","excluding","following","for","from","in","inside","into","like","minus","near","of","off","on","onto","opposite","outside","over","past","per","plus","regarding","round","save","since","than","through","to","toward","towards","under","underneath","unlike","until","up","upon","versus","via","with","within","without"]
        var keyTerms = [String]()
        var isUseless = false
        for x in 0..<searchTerms.count {
            isUseless = false
            for y in 0..<uselessWords.count {
                if searchTerms[x] == uselessWords[y] {
                    isUseless = true
                }
            }
            if isUseless == false {
                keyTerms.append(searchTerms[x])
            }
        }
        print (keyTerms)
        GlobalItems.currentSearch = keyTerms
        
    }
}