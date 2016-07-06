//
//  MatchController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-07-06.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct MatchController {
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
        let delta = offered - posted
        let buyerWeight: Double!
        let sellerWeight: Double!
        let TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE1: [Double]
        TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE1 = []
        let TEMPARRAYOFPREVIOUSOFFERSTOSIMULATE2 = [10.00,12.00,14.00,15.00]
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
            if delta > 10.00 {
                buyerWeight = 0.12
                sellerWeight = 0.3
            }
            else {
                buyerWeight = 0.2
                sellerWeight = 0.1
            }
            matchedPrice = averagePreviousOffers * weight + averagePrice * (1.00 - weight)
            takeBuyer = buyerWeight * (offered - matchedPrice)
            takeSeller = sellerWeight * (matchedPrice - posted)
            takeStripe = (matchedPrice + takeBuyer) * stripePercent + stripeFlat
            
            if matchedPrice - takeStripe - takeSeller > posted {
                valueOfPrices = [matchedPrice,takeBuyer,takeSeller,takeStripe]
                return valueOfPrices
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

