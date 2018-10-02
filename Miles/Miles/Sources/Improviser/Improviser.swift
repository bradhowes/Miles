//
//  Sequentable.swift
//  Miles
//
//  Created by Lalo Martínez on 3/22/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//
import AudioToolbox

/**
 Protocol for a note improviser. An improviser will generate MIDI notes to be written to a MusicTrack.
 */
public protocol Improviser: class {
    
    /**
     The info that all improvisers share when generating an improvisation.
     */
    typealias Harmony = (harmonization: Harmonization, chord: Chord)

    /**
     Generate notes for a Track at a given time in a performance. More than one note may be generated -- or none at all.
    
     - parameter track: the Track to add to
     - parameter beat: the current time in the performance for this instrument
     - parameter harmony: description of what and how to improvise
     - returns: the new time of the performance for the track
     */
    func improviseNotes(toTrack track: Track, onBeat beat: MusicTimeStamp, basedOn harmony: Harmony) -> MusicTimeStamp
}
