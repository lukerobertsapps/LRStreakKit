//
//  MockEncoder.swift
//  LRStreakKitTests
//
//  Created by Luke Roberts on 08/11/2024.
//

import XCTest
@testable import LRStreakKit

class MockEncoder: JSONEncoder, @unchecked Sendable {
    override func encode<T>(_ value: T) throws -> Data where T: Encodable {
        throw EncoderError.genericError
    }

    enum EncoderError: Error {
        case genericError
    }
}
