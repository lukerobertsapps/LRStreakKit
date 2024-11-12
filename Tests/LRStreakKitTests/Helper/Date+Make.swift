//
//  Date+Make.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

import Foundation

extension Date {
    static func make(month: Int = 5, day: Int, hour: Int, minute: Int) -> Date {
        DateComponents(calendar: Calendar.current, month: month, day: day, hour: hour, minute: minute).date!
    }
}
