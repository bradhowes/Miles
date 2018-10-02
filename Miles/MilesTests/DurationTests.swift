//
//  DurationTests.swift
//  MilesTests
//
//  Created by Brad Howes on 9/28/18.
//  Copyright © 2018 Brad Howes. All rights reserved.
//

import XCTest
@testable import Miles

class DurationTests: XCTestCase {

    func testValues() {
        XCTAssertEqual(Duration.whole(dotted: false).value, 4.0)
        XCTAssertEqual(Duration.whole(dotted: true).value, 6.0)
        XCTAssertEqual(Duration.half(dotted: false).value, 2.0)
        XCTAssertEqual(Duration.half(dotted: true).value, 3.0)
        XCTAssertEqual(Duration.quarter(dotted: false).value, 1.0)
        XCTAssertEqual(Duration.quarter(dotted: true).value, 1.5)
        XCTAssertEqual(Duration.eighth(dotted: false).value, 0.5)
        XCTAssertEqual(Duration.eighth(dotted: true).value, 0.75)
        XCTAssertEqual(Duration.sixteenth(dotted: false).value, 0.25)
        XCTAssertEqual(Duration.sixteenth(dotted: true).value, 0.375)
        XCTAssertEqual(Duration.thirtySecond(dotted: false).value, 0.125)
        XCTAssertEqual(Duration.thirtySecond(dotted: true).value, 0.1875)
    }
}
