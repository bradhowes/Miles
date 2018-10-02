//
//  Bassliner.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/// Creates a walking baseline that works on top of a specified chord. 
public class Bassliner: Improviser {
    public weak var delegate: ImproviserDelegate?

    public func improviseNotes(toTrack track: MusicTrack, onBeat beat: MusicTimeStamp, basedOn harmony: Improviser.Harmony) -> MusicTimeStamp {
        let pattern = Rhythm.Bassline.pattern.enumerated()
        return pattern.reduce(beat) { beat, block in
            switch block.element {
            case .note(let dur):
                let notes = harmony.chord.notes(atOctave: 2)
                let note: Note = {
                    switch (block.offset) {
                    case 0 : return notes.first{ $0.tone == harmony.chord.root }!
                    case 2 : return notes.first{ $0.tone == harmony.chord.tones[2] }!
                    default: return notes.randomElement()!
                    }
                }()
                note.addToTrack(track, onBeat: beat, duration: dur)
                self.delegate?.addedNote(withMidiValue: note.midiValue, atBeat: beat, withDuration: dur.value)
                return beat + dur.value

            case .rest(let dur):
                return beat + dur.value
            }
        }
    }
}
