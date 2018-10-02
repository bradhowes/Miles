//
//  ScaleTests.swift
//  MilesTests
//
//  Created by Brad Howes on 9/28/18.
//  Copyright © 2018 Brad Howes. All rights reserved.
//

import XCTest
@testable import Miles

class ScaleTests: XCTestCase {

    func testSetup() {
        XCTAssertEqual(Scale.count, 19)
        XCTAssertEqual(Scale.allMajor, [Scale.major, Scale.majorPentatonic, Scale.majorBebop])
        XCTAssertEqual(Scale.allMinor, [Scale.minor, Scale.minorMelodic, Scale.minorHarmonic, Scale.minorPentatonic, Scale.minorBebop])
    }
    
    func testIntervals() {
        XCTAssertEqual(Scale.major.intervals, [.P1, .M2, .M3, .P4, .P5, .M6, .M7])
        XCTAssertEqual(Scale.minor.intervals, [.P1, .M2, .m3, .P4, .P5, .m6, .m7])
        XCTAssertEqual(Scale.minorHarmonic.intervals, [.P1, .M2, .m3, .P4, .P5, .m6, .M7])
        XCTAssertEqual(Scale.minorMelodic.intervals, [.P1, .M2, .m3, .P4, .P5, .M6, .M7])
        XCTAssertEqual(Scale.majorPentatonic.intervals, [.P1, .M2, .M3, .P5, .M6])
        XCTAssertEqual(Scale.minorPentatonic.intervals, [.P1, .m3, .P4, .P5, .m7])
        XCTAssertEqual(Scale.majorBebop.intervals, [.P1, .M2, .M3, .P4, .P5, .m6, .M6, .M7])
        XCTAssertEqual(Scale.minorBebop.intervals, [.P1, .M2, .m3, .P4, .P5, .m6, .M6, .M7])
        XCTAssertEqual(Scale.dominantBebop.intervals, [.P1, .M2, .M3, .P4, .P5, .M6, .m7, .M7])
        XCTAssertEqual(Scale.augmented.intervals, [.P1, .m3, .M3, .P5, .m6, .M7])
        XCTAssertEqual(Scale.diminished.intervals, [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7])
        XCTAssertEqual(Scale.dorian.intervals, [.P1, .M2, .m3, .P4, .P5, .M6, .m7])
        XCTAssertEqual(Scale.phrygian.intervals, [.P1, .m2, .m3, .P4, .P5, .m6, .m7])
        XCTAssertEqual(Scale.lydian.intervals, [.P1, .M2, .M3, .d5, .P5, .M6, .M7])
        XCTAssertEqual(Scale.mixolydian.intervals, [.P1, .M2, .M3, .P4, .P5, .M6, .m7])
        XCTAssertEqual(Scale.aeolian.intervals, [.P1, .M2, .m3, .P4, .P5, .m6, .m7])
        XCTAssertEqual(Scale.locrian.intervals, [.P1, .m2, .m3, .P4, .d5, .m6, .m7])
        XCTAssertEqual(Scale.blues.intervals, [.P1, .m3, .P4, .d5, .P5, .m7])
        XCTAssertEqual(Scale.spanishGypsy.intervals, [.P1, .m2, .M3, .P4, .P5, .m6, .m7])
    }
    
    func testRandom() {

        // This CAN fail though the chance is really small.
        let samples = (0...10000).map { _ in Scale.random }
        for scale in Scale.allCases {
            XCTAssertTrue(samples.contains(scale))
        }
    }
}
