//
//  View+SetupStreak.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

import SwiftUI

@available(iOS 15.0, *)
public extension View {

    /// Creates and injects the streak manager into the environment
    /// - Parameter persistence: The type of persistence to use, defaults to UserDefaults
    /// - Parameter key: The key to store persistence data under
    func setupStreak(
        persistence: StreakPersistenceType = .userDefaults,
        key: String = "DailyStreak"
    ) -> some View {
        StreakOptions.shared.key = key
        return self
            .environmentObject(StreakManager(persistence: persistence.makePersistence()))
    }
}
