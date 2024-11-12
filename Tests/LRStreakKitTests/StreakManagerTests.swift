//
//  StreakManagerTests.swift
//  LRStreakKitTests
//
//  Created by Luke Roberts on 08/11/2024.
//

import Foundation
import Testing
@testable import LRStreakKit

class StreakManagerTests {

    var persistence: MockPersistence

    init() {
        persistence = MockPersistence()
    }

    deinit {
        persistence = MockPersistence()
    }

    @Test func loadStreakReturnsDefaultIfNoData() {
        let sut = StreakManager(persistence: persistence)
        let streak = sut.loadStreak()
        #expect(streak.lastDate == nil)
    }

    @Test func loadStreakReturnsDefaultIfDecodeError() {
        let date = Date()
        try? persistence.save(data: makeData(from: Streak(lastDate: date)))
        let sut = StreakManager(persistence: persistence)
        let streak = sut.loadStreak(decoder: MockDecoder())
        #expect(streak.lastDate != date)
    }

    @Test func loadStreakSucceedsIfNoErrors() {
        let date = Date()
        try? persistence.save(data: makeData(from: Streak(lastDate: date)))
        let sut = StreakManager(persistence: persistence)
        let streak = sut.loadStreak()
        #expect(streak.lastDate == date)
    }

    @Test func saveStreakFailsIfEncodingError() {
        let sut = StreakManager(persistence: persistence)
        sut.save(streak: Streak(lastDate: Date()), encoder: MockEncoder())
        #expect(persistence.getData() == nil)
    }

    @Test func saveStreakSucceedsIfNoErrors() {
        let sut = StreakManager(persistence: persistence)
        sut.save(streak: Streak(lastDate: Date()))
        #expect(persistence.getData() != nil)
    }

    @Test func streakStaysSameOnSameDay() {
        let streak = Streak(length: 5, lastDate: .with(day: 5, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        sut.updateStreak(onDate: .with(day: 5, hour: 14, minute: 0))
        #expect(sut.currentStreak.length == 5)
    }

    @Test func streakIncrementsOnConsecutiveDay() {
        let streak = Streak(length: 1, lastDate: .with(day: 10, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        sut.updateStreak(onDate: .with(day: 11, hour: 14, minute: 0))
        #expect(sut.currentStreak.length == 2)
    }

    @Test func streakBreaksOnNonConsecutiveDay() {
        let streak = Streak(length: 10, lastDate: .with(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        sut.updateStreak(onDate: .with(day: 30, hour: 12, minute: 0))
        #expect(sut.currentStreak.length == 1)
    }

    @Test func getStreakLengthForSameDay() {
        let streak = Streak(length: 100, lastDate: .with(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.getStreakLength(forDate: .with(day: 1, hour: 13, minute: 0))
        #expect(result == 100)
    }

    @Test func getStreakLengthForNextDay() {
        let streak = Streak(length: 10, lastDate: .with(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.getStreakLength(forDate: .with(day: 2, hour: 12, minute: 0))
        #expect(result == 10)
    }

    @Test func getStreakLengthForInvalidDay() {
        let streak = Streak(length: 50, lastDate: .with(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.getStreakLength(forDate: .with(day: 25, hour: 12, minute: 0))
        #expect(result == 0)
    }
}

// MARK: Helper

extension StreakManagerTests {
    func makeData(from streak: Streak) -> Data {
        return try! JSONEncoder().encode(streak)
    }
}

extension Date {
    static func with(month: Int = 5, day: Int, hour: Int, minute: Int) -> Date {
        DateComponents(calendar: Calendar.current, month: month, day: day, hour: hour, minute: minute).date!
    }
}
