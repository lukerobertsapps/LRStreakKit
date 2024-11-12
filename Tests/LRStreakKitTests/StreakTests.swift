//
//  StreakTests.swift
//  LRStreakKitTests
//
//  Created by Luke Roberts on 08/11/2024.
//

import Foundation
import Testing
@testable import LRStreakKit

struct StreakTests {

    @Test func newStreakStartsAtZero() {
        let sut = Streak()
        #expect(sut.length == 0)
    }

    @Test func newStreakDoesNotHaveLastDate() {
        let sut = Streak()
        #expect(sut.lastDate == nil)
    }

    @Test func nextDayForNoLastDate() {
        let sut = Streak()
        #expect(sut.determineOutcome(for: .now) == .streakContinues)
    }

    @Test func sameDay() {
        let sut = Streak(lastDate: .with(day: 1, hour: 9, minute: 0))
        let now = Date.with(day: 1, hour: 13, minute: 0)
        #expect(sut.determineOutcome(for: now) == .alreadyCompletedToday)
    }

    @Test func sameDayExtreme() {
        let sut = Streak(lastDate: .with(day: 1, hour: 0, minute: 0))
        let now = Date.with(day: 1, hour: 23, minute: 59)
        #expect(sut.determineOutcome(for: now) == .alreadyCompletedToday)
    }

    @Test func isValidOnConsecutiveDays() {
        // 12:00 -> 12:00
        let sut = Streak(lastDate: .with(day: 1, hour: 12, minute: 0))
        let now = Date.with(day: 2, hour: 12, minute: 0)
        #expect(sut.determineOutcome(for: now) == .streakContinues)
    }

    @Test func nextDayCloseToMidnight() {
        // 23:59 -> 00:01
        let sut = Streak(lastDate: .with(day: 5, hour: 23, minute: 59))
        let now = Date.with(day: 6, hour: 0, minute: 1)
        #expect(sut.determineOutcome(for: now) == .streakContinues)
    }

    @Test func streakBrokenIfDaySkipped() {
        // 12:00 -|+2|> 12:00
        let sut = Streak(lastDate: .with(day: 10, hour: 12, minute: 0))
        let now = Date.with(day: 12, hour: 12, minute: 0)
        #expect(sut.determineOutcome(for: now) == .streakBroken)
    }
}