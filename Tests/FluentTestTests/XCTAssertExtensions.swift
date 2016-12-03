//
//  XCTAssertExtensions.swift
//  GotYourBackServer
//
//  Created by Charlie Woloszynski on 11/23/16.
//
//

import XCTest

func XCTAssertThrows<T>(_ expression: @autoclosure () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        let _ = try expression()
        XCTAssert(false, "No error to catch! - \(message)", file: file, line: line)
    } catch {
    }
}

func XCTAssertNoThrow<T>(_ expression: @autoclosure () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        let _ = try expression()
    } catch let error {
        XCTAssert(false, "Caught error: \(error) - \(message)", file: file, line: line)
    }
}
