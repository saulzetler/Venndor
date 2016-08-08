//
//  MatchController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-07-06.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct jonasBoettcherController {
    func calculateMatchedPrice(offered: Double, posted: Double, item: Item) -> [Double] {
        var matchedPrice: Double!
        let averagePrice: Double!
        var takeBuyer: Double!
        var takeSeller: Double!
        var takeStripe: Double!
        let weight: Double!
        let averagePreviousOffers: Double!
        let stripePercent = 0.029
        let stripeFlat = 0.3
        let valueOfPrices: [Double]!
        let TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE3 = [11.00,12.00,9.00,14.00,8.00,10.00,20.00,11.00,9.00,8.00]
        averagePrice = (offered+posted)/2
        if offered > posted + stripePercent*averagePrice + stripeFlat {
            var temp = 0.00
            for x in 0..<TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE3.count {
                temp = temp + TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE3[x]
            }
            if temp > 0 {
                averagePreviousOffers = temp/Double(TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE3.count)
            }
            else {
                averagePreviousOffers = averagePrice
            }
            if averagePreviousOffers - offered > 10 {
                weight = 0.05
            }
            else {
                weight = 0.10
            }
            matchedPrice = averagePreviousOffers * weight + averagePrice * (1.00 - weight)
            takeBuyer = 0.00
            takeSeller = 0.00
            takeStripe = 0.00
            
            if matchedPrice > posted {
                valueOfPrices = [matchedPrice,takeBuyer,takeSeller,takeStripe]
                return valueOfPrices
            }
            else {
                matchedPrice = 0.00
                valueOfPrices = [matchedPrice,takeBuyer,takeSeller,takeStripe]
                return valueOfPrices
            }
        }
        else {
            matchedPrice = 0.00
            takeBuyer = 0.00
            takeSeller = 0.00
            takeStripe = 0.00
            valueOfPrices = [matchedPrice,takeBuyer,takeSeller,takeStripe]
            return valueOfPrices
        }
    }
    
}

