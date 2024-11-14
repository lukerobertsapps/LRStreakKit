//
//  UserDefaults+StreakPersistence.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

import Foundation

/// Default conformance to persistence for user defaults
extension UserDefaults: StreakPersistence {

    private var key: String {
        StreakOptions.shared.key
    }

    public func getData() -> Data? {
        data(forKey: key)
    }

    public func save(data: Data) throws {
        set(data, forKey: key)
    }
}
