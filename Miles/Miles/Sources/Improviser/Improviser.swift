//
//  Sequentable.swift
//  Miles
//
//  Created by Lalo Martínez on 3/22/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//
import AudioToolbox

public protocol ImproviserDelegate: class {
    
    func addedNote(withMidiValue: Int, atBeat: Double, withDuration: Double)
}

public protocol Improviser: class {
    typealias Harmony = (harmonization: Harmonization, chord: Chord)

    var delegate: ImproviserDelegate? {get set}

    func improviseNotes(toTrack track: MusicTrack, onBeat beat: MusicTimeStamp, basedOn harmony: Harmony ) -> MusicTimeStamp
}
