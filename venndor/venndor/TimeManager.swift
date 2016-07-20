//
//  TimeManager.swift
//  venndor
//
//  Created by David Tamrazov on 2016-07-19.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation


struct TimeManager {
    static var timeStamp: NSDate!
    static let globalManager = TimeManager()
    
    func setSessionDuration(startupTime: NSDate, controller: String) {
        let timeInterval = ( (startupTime.timeIntervalSinceNow) * -1)
        LocalUser.user.timePerController[controller]! += timeInterval
    }
    
}