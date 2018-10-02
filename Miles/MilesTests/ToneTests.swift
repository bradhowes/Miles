//
//  ToneTests.swift
//  MilesTests
//
//  Created by Brad Howes on 9/28/18.
//  Copyright © 2018 Brad Howes. All rights reserved.
//

import XCTest
@testable import Miles

class ToneTests: XCTestCase {

    func testAllCasesHas12Notes() {
        XCTAssertEqual(Tone.allCases.count, 12)
    }
    
    func testToneDescriptions() {
        XCTAssertEqual(Tone.C.description, "C")
        XCTAssertEqual(Tone.Csharp.description, "C♯")
        XCTAssertEqual(Tone.D.description, "D")
        XCTAssertEqual(Tone.Eflat.description, "E♭")
        XCTAssertEqual(Tone.E.description, "E")
        XCTAssertEqual(Tone.F.description, "F")
        XCTAssertEqual(Tone.Fsharp.description, "F♯")
        XCTAssertEqual(Tone.G.description, "G")
        XCTAssertEqual(Tone.Aflat.description, "A♭")
        XCTAssertEqual(Tone.A.description, "A")
        XCTAssertEqual(Tone.Bflat.description, "B♭")
        XCTAssertEqual(Tone.B.description, "B")
    }

    func testFromMidi() {
        let v1 = Tone.fromMidi(44)
        XCTAssertEqual(v1.0, Tone.Aflat)
        XCTAssertEqual(v1.1, 1)
        let v2 = Tone.fromMidi(0)
        XCTAssertEqual(v2.0, Tone.C)
        XCTAssertEqual(v2.1, -2)
    }

    func testToMidi() {
        XCTAssertEqual(Tone.B.toMidi(octave: -1), 23)
        XCTAssertEqual(Tone.C.toMidi(octave: 0), 24)
        XCTAssertEqual(Tone.Csharp.toMidi(octave: 0), 25)

        XCTAssertEqual(Tone.Aflat.toMidi(octave: -2), 8)
        XCTAssertEqual(Tone.Aflat.toMidi(octave: -1), 20)
        XCTAssertEqual(Tone.Aflat.toMidi(octave:  0), 32)
        XCTAssertEqual(Tone.Aflat.toMidi(octave:  1), 44)
        XCTAssertEqual(Tone.Aflat.toMidi(octave:  2), 56)
    }

    func testInterval() {
        XCTAssertEqual(Tone.C.interval(.m2), Tone.Csharp)
        XCTAssertEqual(Tone.C.interval(.P8), Tone.C)
        XCTAssertEqual(Tone.C.interval(.P1), Tone.C)
        XCTAssertEqual(Tone.C.interval(.P5), Tone.G)

        XCTAssertEqual(Tone.B.interval(.m2), Tone.C)
        XCTAssertEqual(Tone.B.interval(.P8), Tone.B)
        XCTAssertEqual(Tone.B.interval(.P1), Tone.B)
        XCTAssertEqual(Tone.B.interval(.P5), Tone.Fsharp)
    }
}
