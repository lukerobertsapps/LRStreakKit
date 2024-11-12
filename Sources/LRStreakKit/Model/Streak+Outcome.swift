//
//  Streak+Outcome.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

import Foundation

extension Streak {

    /// Determines an outcome for a given date and whether a given date is valid to continue the streak
    /// - Parameter date: The date to test again
    /// - Returns: An outcome such as nextDay, sameDay or invalid
    func determineOutcome(for date: Date) -> Outcome {
        guard let lastDate else { return .streakContinues }
        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: lastDate) {
            return .alreadyCompletedToday
        }
        if let dayAfterLast = calendar.date(byAdding: .day, value: 1, to: lastDate) {
            if calendar.isDate(date, inSameDayAs: dayAfterLast) {
                return .streakContinues
            }
        }
        return .streakBroken
    }

    /// Represents different outcomes for a streak
    enum Outcome {

        /// The streak was already completed for the day
        case alreadyCompletedToday

        /// The streak should continue
        case streakContinues

        /// The streak has been broken
        case streakBroken
    }
}
