//
//  FileManager+Persistence.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

import Foundation

extension FileManager: StreakPersistence {

    private var key: String {
        StreakOptions.shared.key
    }

    public func getData() -> Data? {
        guard let documents = getDocumentsDirectory() else { return nil }
        let file = documents.appendingPathComponent(key)
        return try? Data(contentsOf: file)
    }

    public func save<T: Codable>(data: T) throws {
        guard let documents = getDocumentsDirectory() else { throw FileError.failedToFetchDocuments }
        let file = documents.appendingPathComponent(key)
        let fileData = try JSONEncoder().encode(data)
        try fileData.write(to: file, options: [.atomic])
    }

    private func getDocumentsDirectory() -> URL? {
        if #available(iOS 16.0, *) {
            return URL.documentsDirectory
        } else {
            return urls(for: .documentDirectory, in: .userDomainMask).first
        }
    }

    enum FileError: Error {
        case failedToFetchDocuments
    }
}
