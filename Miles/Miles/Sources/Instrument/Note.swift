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
}
