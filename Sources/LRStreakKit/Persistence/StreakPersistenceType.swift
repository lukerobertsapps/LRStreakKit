//
//  StreakPersistenceType.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

import Foundation

/// The available types of persistence provided by the library
public enum StreakPersistenceType {
    case userDefaults
    case documentsDirectory
    case custom(any StreakPersistence)

    /// Creates an instance of persistence for each case
    func makePersistence() -> StreakPersistence {
        switch self {
        case .userDefaults:
            return UserDefaults.standard
        case .documentsDirectory:
            return FileManager.default
        case .custom(let streakPersistence):
            return streakPersistence
        }
    }
}
