//
//  MockDecoder.swift
//  LRStreakKitTests
//
//  Created by Luke Roberts on 08/11/2024.
//

import XCTest
@testable import LRStreakKit

class MockDecoder: JSONDecoder, @unchecked Sendable {
    override func decode<T>(
        _ type: T.Type, from data: Data
    ) throws -> T where T: Decodable {
        throw DecoderError.genericError
    }

    enum DecoderError: Error {
        case genericError
    }
}
