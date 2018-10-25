//
//  Note.swift
//  Miles
//
//  Created by Lalo Martínez on 3/22/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/**
 A note is noting more than a Tone that is played at a particular octave. It can generate a MIDI value
 for the note to command a MIDI device to play the note.
 */
public struct Note {
    /// The Tone value to play
    public let tone: Tone
    /// The octave in which to play the Tone
    public let octave: Int
    /// Obtain the MIDI value associated with the Tone / octave combination
    public var midiValue: Int { return tone.toMidi(octave: octave) }

    /**
     Construct a new Note using the given MIDI value.
    
     - parameter midi: the MIDI value that corresponds to the Note
     */
    public init(midi: Int) {
        let toneOctave = Tone.fromMidi(midi)
        tone = toneOctave.0
        octave = toneOctave.1
    }

    /**
     Construct a new Note
    
     - parameter tone: the Tone to play
     - parameter octave: the octave in which to play it
     */
    public init(tone: Tone, octave: Int) {
        self.tone = tone
        self.octave = octave
    }

    /**
     Create a new note from this one but with the octave value raised.
    
     - returns: new Note value
     */
    public func raiseOctave() -> Note { return Note(tone: self.tone, octave: self.octave + 1) }
}
