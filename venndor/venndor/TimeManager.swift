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
    
    func getSessionDuration(startupTime: NSDate) -> Double {
        let timeInterval = ((startupTime.timeIntervalSinceNow) / 60 * -1)
        return timeInterval
    }
    
}