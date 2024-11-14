//
//  StreakManagerTests.swift
//  LRStreakKitTests
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

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
        #expect(streak.length == 0)
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
        let date = Date.make(day: 5, hour: 12, minute: 0)
        let streak = Streak(length: 5, lastDate: date)
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        sut.updateStreak(onDate: .make(day: 5, hour: 14, minute: 0))
        #expect(sut.currentStreak.length == 5)
        #expect(sut.currentStreak.lastDate == date)
    }

    @Test func streakIncrementsOnConsecutiveDay() {
        let streak = Streak(length: 1, lastDate: .make(day: 10, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let date = Date.make(day: 11, hour: 14, minute: 0)
        sut.updateStreak(onDate: date)
        #expect(sut.currentStreak.length == 2)
        #expect(sut.currentStreak.lastDate == date)
    }

    @Test func streakBreaksOnNonConsecutiveDay() {
        let streak = Streak(length: 10, lastDate: .make(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let date = Date.make(day: 30, hour: 12, minute: 0)
        sut.updateStreak(onDate: date)
        #expect(sut.currentStreak.length == 1)
        #expect(sut.currentStreak.lastDate == date)
    }

    @Test func getStreakLengthForSameDay() {
        let streak = Streak(length: 100, lastDate: .make(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.getStreakLength(forDate: .make(day: 1, hour: 13, minute: 0))
        #expect(result == 100)
    }

    @Test func getStreakLengthForNextDay() {
        let streak = Streak(length: 10, lastDate: .make(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.getStreakLength(forDate: .make(day: 2, hour: 12, minute: 0))
        #expect(result == 10)
    }

    @Test func getStreakLengthForInvalidDay() {
        let streak = Streak(length: 50, lastDate: .make(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.getStreakLength(forDate: .make(day: 25, hour: 12, minute: 0))
        #expect(result == 0)
    }

    @Test func hasCompletedStreak() {
        let streak = Streak(length: 50, lastDate: .make(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.hasCompletedStreak(today: .make(day: 1, hour: 13, minute: 0))
        #expect(result == true)
    }

    @Test func hasNotCompletedStreak() {
        let streak = Streak(length: 50, lastDate: .make(day: 1, hour: 12, minute: 0))
        let sut = StreakManager(persistence: persistence)
        sut.currentStreak = streak
        let result = sut.hasCompletedStreak(today: .make(day: 5, hour: 12, minute: 0))
        #expect(result == false)
    }
}

// MARK: Helper

extension StreakManagerTests {
    func makeData(from streak: Streak) -> Data {
        return try! JSONEncoder().encode(streak)
    }
}
