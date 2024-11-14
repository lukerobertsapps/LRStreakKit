//
//  StreakOptions.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

/// Contains options for streaks
class StreakOptions: @unchecked Sendable {
    static let shared: StreakOptions = .init()

    /// The persistence key
    var key: String = "DailyStreak"

    private init() {}
}
