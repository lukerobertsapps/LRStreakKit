//
//  StreakPersistence.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

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
