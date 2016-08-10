//
//  BoughtController.swift
//  venndor
//
//  Created by Tynan Davis on 2016-08-02.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation

struct BoughtController {
    func sendSellerNotification() {
        OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": ["3009e210-3166-11e5-bc1b-db44eb02b120"]])
    }
    func updateSeller(item: Item) {
        //function should update the sellers item, move the item from posted to sold
        
    }
    func updateBuyer(item: Item) {
        //function should update the buyer, move the item from matched to bought
        
    }
    func updateMarket(item: Item) {
        //function should update the market for all users and remove the item from the potential pool of items.
    }
}