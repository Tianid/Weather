//
//  CustomDateFormatter.swift
//  Weather
//
//  Created by Tianid on 29.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

enum TypeOfDateFormats: String {
    case WeekMonthDayYear = "EEEE, MMM d, yyyy"
    case WeekTime = "EEEE HH:mm"
    case MonthDayYear = "MMM d, yyyy"
    case DayOfWeekShort = "E"
    case FullDate = "E, d MMM yyyy HH:mm:ss Z"
    case HoursMinutes = "HH:mm"
}

import Foundation

class CustomDateFormatter {
    static func makeFormattedDateString(date: Date, type: TypeOfDateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
}
