//
//  StreakOptions.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

/// Contains options for streaks
class StreakOptions: @unchecked Sendable {
    static let shared: StreakOptions = .init()

    /// The persistence key
    var key: String = "DailyStreak"

    private init() {}
}
