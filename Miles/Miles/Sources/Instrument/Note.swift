//
//  Note.swift
//  Miles
//
//  Created by Lalo Martínez on 3/22/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

public struct Note {
    public let tone: Tone
    public let octave: Int
    public var midiValue: Int { return tone.toMidi(octave: octave) }

    public init(midi: Int) {
        let toneOctave = Tone.fromMidi(midi)
        tone = toneOctave.0
        octave = toneOctave.1
    }

    public init(tone: Tone, octave: Int) {
        self.tone = tone
        self.octave = octave
    }

    public func raiseOctave() -> Note { return Note(tone: self.tone, octave: self.octave + 1) }

    public func addToTrack(_ track: MusicTrack, onBeat beat: MusicTimeStamp, duration: Duration,
                           velocity: Int = Int.random(in: 40...70)) {
        
        var mess = MIDINoteMessage(channel: 0,
                                   note: UInt8(midiValue),
                                   velocity: UInt8(velocity),
                                   releaseVelocity: UInt8(10),
                                   duration: Float(duration.value))
        let status = MusicTrackNewMIDINoteEvent(track, beat, &mess)
        if status != noErr {
            print("Error creating new midi note event \(status)")
        }
    }
}




