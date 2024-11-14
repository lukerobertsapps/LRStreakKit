//
//  StreakPersistence.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

import Foundation

/// Objects conform to this protocol if they can persist data
public protocol StreakPersistence {

    /// Gets streak data
    /// - Returns: Data is nil if not found under the given key
    func getData() -> Data?

    /// Persists data, can throw if the operation fails
    /// - Parameters:
    ///   - data: The data to persist
    func save(data: Data) throws
}
