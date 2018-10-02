//
//  ScaleTests.swift
//  MilesTests
//
//  Created by Brad Howes on 9/28/18.
//  Copyright © 2018 Brad Howes. All rights reserved.
//

import XCTest
import AVFoundation
import AVKit

@testable import Miles

class WiringTests: XCTestCase {

    private func notesForScale(scale: Scale, key: Tone, atOctave octave: Int) -> [Note] {
        let mappedNotes = scale.tones(forKey: key).map { (tone: Tone) -> Note in
            let correctOctave: Int = tone.rawValue < key.rawValue ? octave + 1 : octave
            return Note(tone: tone, octave: correctOctave)
        }
        return mappedNotes
    }

    func testWiring() {
        let expectation = XCTestExpectation(description: "Play MIDI sequence")

        // Test a simple audio wiring setup.
        let engine = AVAudioEngine()
        let sampler1 = Sampler(engine: engine, for: .piano)
        let sequencer = Sequencer(engine: engine, withTempo: 100)
        try! engine.start()

        let scale: Scale = .blues
        let octaves = [2, 3, 4]
        let inKey: Tone = .Eflat
        sequencer.populate(sampler: sampler1) { track in
            octaves.forEach { octave in
                _ = notesForScale(scale: scale, key: inKey, atOctave: octave).reduce(MusicTimeStamp(0.0)) { beat, note in
                    let dur: Duration = .quarter(dotted: false)
                    note.addToTrack(track, onBeat: beat, duration: dur)
                    return beat + dur.value
                }
            }
        }

        sequencer.complete()
        sequencer.start()
        print("started - \(sequencer.duration)")
        
         XCTAssertTrue(sequencer.isPlaying)

        // We wish to periodically check the sequencer to see if it has stopped playing. There is probably a better
        // way to do this...
        var workItems: [DispatchWorkItem] = []
        workItems.append(DispatchWorkItem(qos: DispatchQoS.default, flags: DispatchWorkItemFlags(), block: {
            if sequencer.isPlaying {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),
                                              execute: workItems.first!)
            }
            else {
                print("stopped")
                expectation.fulfill()
            }
        }))

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: workItems.first!)

        // Keep the test running for a max amount of time while we wait for fulfillment
        wait(for: [expectation], timeout: 30.0)
    }
}
