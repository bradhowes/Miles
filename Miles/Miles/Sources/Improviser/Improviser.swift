//
//  Sequentable.swift
//  Miles
//
//  Created by Lalo Martínez on 3/22/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//
import AudioToolbox

/**
 Delegate protocol for an Improviser. The `addNote` method of the delegate will be called for each
 note generated for an instrument in a performance.
 */
public protocol ImproviserDelegate: class {
    
    /**
     Notification from an Improviser about a new note in performance.
    
     - parameter withMidiValue: the MIDI note value
     - parameter atBeat: the time of the note start
     - parameter withDuration: the duration of the note
     */
    func addedNote(withMidiValue: Int, atBeat: Double, withDuration: Double)
}

/**
 Protocol for a note improviser. An improviser will generate MIDI notes to be written to a MusicTrack.
 */
public protocol Improviser: class {
    
    /**
     The info that all improvisers share when generating an improvisation.
     */
    typealias Harmony = (harmonization: Harmonization, chord: Chord)

    /// Optional delegate for the improviser.
    var delegate: ImproviserDelegate? {get set}

    /**
     Generate MIDI notes for a MusicTrack at a given time in a performance. More than one note may be
     generated -- or none at all.
    
     - parameter track: the MusicTrack to write into
     - parameter beat: the current time in the performance for this instrument
     - parameter harmony: description of what and how to improvise
     - returns: the new time of the performance for this instrument
     */
    func improviseNotes(toTrack track: MusicTrack, onBeat beat: MusicTimeStamp, basedOn harmony: Harmony) -> MusicTimeStamp
}
