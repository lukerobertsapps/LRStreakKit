//
//  Streak.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 08/11/2024.
//

import Foundation

/// Data for a streak, codable so it can be persisted
struct Streak: Codable {

    /// The length of the streak in days
    var length: Int = 0

    /// When the streak was last updated
    var lastDate: Date?
}
