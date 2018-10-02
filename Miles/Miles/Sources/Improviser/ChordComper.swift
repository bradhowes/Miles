//
//  ChordArpeggiator.swift
//  Miles
//
//  Created by Lalo Martínez on 3/25/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/**
 Arranges the chord's notes and inversions in a comping rhythm to create the accompainiment piano.
 */
public class ChordComper: Improviser {

    public func improviseNotes(toTrack track: Track, onBeat beat: MusicTimeStamp, basedOn harmony: Improviser.Harmony) -> MusicTimeStamp {
        let chord = harmony.chord
        let pattern = Rhythm.Comping.pattern
        return pattern.reduce(beat) { beat, block in
            switch block {
            case .note(let dur):

                // Generate randomly-ordered set of notes for the current chord.
                let notes = chord.notes(atOctave: Int.random(in: 1...2), inversion: Int.random(in: 0...2)).shuffled()

                // Randomly pick the number of notes to sound in the chord, with the minimum being 2
                let count = Int.random(in: 2..<notes.count)

                // Add the notes at the same time position and with the same duration
                notes[0..<count].forEach { track.add(note: $0, onBeat: beat, duration: dur) }
                return beat + dur.value

            case .rest(let dur):
                return beat + dur.value
            }
        }
    }
}
