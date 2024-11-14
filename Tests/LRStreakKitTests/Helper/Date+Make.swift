//
//  Date+Make.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

import Foundation

extension Date {
    static func make(month: Int = 5, day: Int, hour: Int, minute: Int) -> Date {
        DateComponents(calendar: Calendar.current, month: month, day: day, hour: hour, minute: minute).date!
    }
}
