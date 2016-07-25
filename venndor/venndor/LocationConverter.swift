//
//  LocationConverter.swift
//  venndor
//
//  Created by Tynan Davis on 2016-07-18.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct LocationConverter {
    var latitude: Double!
    var longitude: Double!
    
    mutating func coordToGeo(latitudeInput: Double, longitudeInput: Double) -> String{
        latitude = latitudeInput
        longitude = longitudeInput
        var geoHash = ""
        var quadrentSize = 180.00
        for _ in 0..<9 {
            quadrentSize = quadrentSize/3
            geoHash = setQuadrent(quadrentSize, geoHash: geoHash)
        }
        return geoHash
        
    }
    mutating func setQuadrent(quadrentSize: Double, geoHash: String) -> String {
        var temp = ""
        if latitude > quadrentSize/2 {
            
            if longitude > quadrentSize {
                latitude = latitude - quadrentSize
                longitude = longitude - quadrentSize*2
                temp = geoHash + "2"
                
            } else if longitude < -quadrentSize {
                
                latitude = latitude - quadrentSize
                longitude = longitude + quadrentSize*2
                
                temp = geoHash + "0"
            } else {
                latitude = latitude - quadrentSize
                temp = geoHash + "1"
            }
        } else if latitude < -quadrentSize/2 {
            
            if longitude > quadrentSize {
                latitude = latitude + quadrentSize
                longitude = longitude - quadrentSize*2
                temp = geoHash + "8"
            } else if longitude < -quadrentSize {
                latitude = latitude + quadrentSize
                longitude = longitude + quadrentSize*2
                temp = geoHash + "6"
            } else {
                latitude = latitude + quadrentSize
                temp = geoHash + "7"
            }
        } else {
            
            if longitude > quadrentSize {
                longitude = longitude - quadrentSize*2
                temp = geoHash + "5"
            } else if longitude < -quadrentSize {
                longitude = longitude + quadrentSize*2
                temp = geoHash + "3"
            } else {
                temp = geoHash + "4"
            }
        }
        return temp
    }
}