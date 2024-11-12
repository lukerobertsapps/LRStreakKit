//
//  MockPersistence.swift
//  ScienceQuiz
//
//  Created by Luke Roberts on 12/11/2024.
//

import Foundation
@testable import LRStreakKit

class MockPersistence: StreakPersistence {

    var dataToGet: Data?
    func getData() -> Data? {
        dataToGet
    }

    func save(data: Data) throws {
        dataToGet = data
    }
}
