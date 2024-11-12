//
//  StreakManager.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 08/11/2024.
//

import Foundation

/// Manager class responsible for updating and fetching streak data
public final class StreakManager: ObservableObject {

    private let persistence: StreakPersistence

    @Published
    var currentStreak: Streak = Streak()

    init(persistence: StreakPersistence = UserDefaults.standard) {
        self.persistence = persistence
        self.currentStreak = loadStreak()
    }

    /// Whether the streak has been completed for the day
    /// - Parameter today: Pass in a date to check against. Defaults to now.
    /// - Returns: True if the outcome of the streak is alreadyCompletedToday
    public func hasCompletedStreak(today: Date = .now) -> Bool {
        let outcome = currentStreak.determineOutcome(for: today)
        return outcome == .alreadyCompletedToday
    }

    /// Gets the length of the current streak
    /// - Parameter date: Pass in a date to check against. Defaults to now.
    /// - Returns: The length of the streak in days
    public func getStreakLength(forDate date: Date = .now) -> Int {
        let outcome = currentStreak.determineOutcome(for: date)
        if outcome == .streakBroken {
            currentStreak.length = 0
            save(streak: currentStreak)
        }
        return currentStreak.length
    }

    /// Call this method to update the streak after the user has done an action
    /// - Parameter date: A date to pass in to check against. Defaults to now.
    ///
    /// This method could be called when the app first launches or when the user
    /// completes an action
    public func updateStreak(onDate date: Date = .now) {
        let outcome = currentStreak.determineOutcome(for: date)
        switch outcome {
        case .alreadyCompletedToday:
            return
        case .streakContinues:
            currentStreak.lastDate = date
            currentStreak.length += 1
        case .streakBroken:
            currentStreak.lastDate = date
            currentStreak.length = 1
        }
        save(streak: currentStreak)
    }

    func loadStreak(decoder: JSONDecoder = .init()) -> Streak {
        guard let data = persistence.getData() else {
            return Streak()
        }
        do {
            let fetched = try decoder.decode(Streak.self, from: data)
            return fetched
        } catch {
            print("Failed to decode streak. Error: \(error.localizedDescription)")
            return Streak()
        }
    }

    func save(streak: Streak, encoder: JSONEncoder = .init()) {
        guard let encoded = try? encoder.encode(streak) else {
            print("Failed to encode current streak")
            return
        }
        do {
            try persistence.save(data: encoded)
        } catch {
            print("Error saving streak: \(error)")
        }
    }
}
