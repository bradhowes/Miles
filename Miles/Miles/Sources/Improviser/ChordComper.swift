//
//  ChordArpeggiator.swift
//  Miles
//
//  Created by Lalo Martínez on 3/25/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/// Arranges the chord's notes and inversions in a comping rythm to create the accompainment piano.
public class ChordComper: Improviser {
    public weak var delegate: ImproviserDelegate?

    public init() {}
    
    public func improviseNotes(toTrack track: MusicTrack, onBeat beat: MusicTimeStamp, basedOn harmony: Improviser.Harmony) -> MusicTimeStamp {
        let chord = harmony.chord
        let pattern = Rhythm.Comping.pattern
        return pattern.reduce(beat) { beat, block in
            switch block {
            case .note(let dur):
                for _ in 2...Int.random(in: 2..<chord.tones.count) { // Use at least 2 notes to render chords
                    let note = chord.notes(atOctave: Int.random(in: 1...2), inversion: Int.random(in: 0...2)).randomElement()!
                    note.addToTrack(track, onBeat: beat, duration: dur, velocity: Int.random(in: 30...50))
                    self.delegate?.addedNote(withMidiValue: note.midiValue, atBeat: beat, withDuration: dur.value)
                }
                return beat + dur.value
            case .rest(let dur):
                return beat + dur.value
            }
        }
    }
}
