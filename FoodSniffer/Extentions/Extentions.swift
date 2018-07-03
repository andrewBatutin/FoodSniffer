//
//  Extentions.swift
//  FoodSniffer
//
//  Created by andrew batutin on 7/3/18.
//  Copyright © 2018 HomeOfRisingSun. All rights reserved.
//

import Foundation

extension Date{
    
    func midnight() -> Date{
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
}


extension DateInterval{
    
    private static func timeInterval(from time:String.SubSequence) -> TimeInterval?{
        guard let hour = time.split(separator: ":").first, let iHour = Int(hour)  else { return nil }
        guard let minute = time.split(separator: ":").last, let iMinute = Int(minute)  else { return nil }
        let timeInterval = TimeInterval(iHour * 3600 + iMinute * 60)
        return timeInterval
    }
    
    init?(from string:String){
        guard let dates = DateInterval.dates(from: string) else { return nil }
        self.init(start: dates.0, end: dates.1)
    }
    
    private static func dates(from textInterval:String) -> (Date,Date)?{
        
        guard let startTime = textInterval.split(separator: "-").first else { return nil }
        guard let endTime = textInterval.split(separator: "-").last else { return nil }
        
        guard let startTimeInterval = timeInterval(from: startTime) else { return nil }
        guard var endTimeInterval = timeInterval(from: endTime) else { return nil }
        
        
        if endTimeInterval < startTimeInterval{
            endTimeInterval += 24 * 3600
        }
        
        let refDate = Date().midnight()
        let startDate = Date(timeInterval: startTimeInterval, since: refDate)
        let endDate = Date(timeInterval: endTimeInterval, since: refDate)
        
        return (startDate, endDate)
    }
    
}
