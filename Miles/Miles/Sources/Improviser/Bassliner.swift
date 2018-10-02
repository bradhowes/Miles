//
//  Bassliner.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/**
 Creates a "walking" bass line that works on top of a specified chord.
 The first note of a measure (assuming 4/4) will always be the tonic or
 root note of the current chord progression in the performance, while The third
 note will be the dominant note. The remaining two notes will be randomly picked.
 */
public class Bassliner: Improviser {

    public func improviseNotes(toTrack track: Track, onBeat beat: MusicTimeStamp, basedOn harmony: Improviser.Harmony) -> MusicTimeStamp {
        let pattern = Rhythm.Bassline.pattern.enumerated()
        return pattern.reduce(beat) { beat, part in
            switch part.element {
            case .note(let dur):
                let notes = harmony.chord.notes(atOctave: 2)
                let note: Note = {
                    switch (part.offset) {
                    case 0 : return notes.first{ $0.tone == harmony.chord.root }!
                    case 2 : return notes.first{ $0.tone == harmony.chord.tones[2] }!
                    default: return notes.randomElement()!
                    }
                }()
                
                track.add(note: note, onBeat: beat, duration: dur)
                return beat + dur.value

            case .rest(let dur):
                return beat + dur.value
            }
        }
    }
}
