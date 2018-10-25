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
    
    class Tapper {
        public var maxValue: Float = 0.0
        let mixer: AVAudioMixerNode
        public init(_ mixer: AVAudioMixerNode, volume: Float = 0.0) {
            self.mixer = mixer
            self.mixer.outputVolume = volume
            mixer.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, when in
                let z = (buffer.floatChannelData?.pointee)!
                let y = Array<Float>(UnsafeBufferPointer(start: z, count: Int(buffer.frameLength)))
                self.maxValue = max(y.max() ?? 0.0, self.maxValue)
            }
        }
    }

    func testDirectMIDIPlaying() {
        let expectation = XCTestExpectation(description: "Play real-time MIDI notes")

        let engine = AVAudioEngine()
        let instrument = Piano(engine: engine, for: .comping)
        try! engine.start()

        // Tap the output so we can see if there is any audio being generated
        //
        let tapper = Tapper(engine.mainMixerNode)

        // Play a major chords
        //
        let sampler = instrument.sampler.ausampler
        sampler.startNote(48, withVelocity: 80, onChannel: 0)
        sampler.startNote(52, withVelocity: 80, onChannel: 0)
        sampler.startNote(55, withVelocity: 80, onChannel: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            sampler.stopNote(48, onChannel: 0)
            sampler.stopNote(52, onChannel: 0)
            sampler.stopNote(55, onChannel: 0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800), execute: {
            engine.stop()
            XCTAssertTrue(tapper.maxValue > 0.0, "no sound from AU graph")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMIDISequencePlayback() {
        let expectation = XCTestExpectation(description: "Play recoded MIDI sequences")
        
        // Test a simple audio wiring setup.
        let engine = AVAudioEngine()
        let instrument = Piano(engine: engine, for: .comping)
        let sequencer = Sequencer(engine: engine, withTempo: 150)
        try! engine.start()
        let tapper = Tapper(engine.mainMixerNode)

        let scale: Scale = .blues
        let octaves = [2, 3, 4]
        let inKey: Tone = .Eflat
        sequencer.populate(instrument: instrument) { track in
            octaves.forEach { octave in
                _ = notesForScale(scale: scale, key: inKey, atOctave: octave).reduce(MusicTimeStamp(0.0)) { beat, note in
                    let dur: Duration = .quarter(dotted: false)
                    track.add(note: note, onBeat: beat, duration: dur)
                    return beat + dur.value
                }
            }
        }
        
        sequencer.complete()
        sequencer.start()

        print("started - \(sequencer.duration)")
        
        XCTAssertTrue(sequencer.isPlaying)

        // We wish to periodically check the sequencer to see if it has stopped playing. There is probably a better
        // way to do this, but it works.
        var workItems: [DispatchWorkItem] = []
        workItems.append(DispatchWorkItem(qos: DispatchQoS.default, flags: DispatchWorkItemFlags(), block: {
            if sequencer.isPlaying {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: workItems.first!)
            }
            else {
                print("stopped")
                engine.stop()
                XCTAssertTrue(tapper.maxValue > 0.0, "no sound from AU graph")
                expectation.fulfill()
            }
        }))

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: workItems.first!)
        wait(for: [expectation], timeout: 10.0)
    }
}
