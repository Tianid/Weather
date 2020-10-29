//
//  Data+Extension.swift
//  Weather
//
//  Created by Tianid on 29.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation

extension Date {
    static var today: (start: Date, end: Date) { return (start: Date().startOfDay, end: Date().endOfDay) }
    
    
    private var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    private var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    static func dateAfter(numberOfDays days: Int) -> (start: Date, end: Date) {
        
        var startComponents = DateComponents()
        startComponents.day = days
        startComponents.second = 0
        let startOfDay = Calendar.current.date(byAdding: startComponents, to: today.start)!
        
        var endComponents = startComponents
        endComponents.day = days + 1
        endComponents.second = -1
        let endOfDay = Calendar.current.date(byAdding: endComponents, to: today.start)!
        
        return (start: startOfDay, end: endOfDay)
    }
    
}
