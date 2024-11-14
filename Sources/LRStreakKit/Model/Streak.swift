//
//  Streak.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

import Foundation

/// Data for a streak, codable so it can be persisted
struct Streak: Codable {

    /// The length of the streak in days
    var length: Int = 0

    /// When the streak was last updated
    var lastDate: Date?
}
