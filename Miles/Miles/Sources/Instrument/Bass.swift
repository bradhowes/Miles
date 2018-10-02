//
//  Bass.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox
import AVFoundation
import SpriteKit

/**
 A bass instrument that can be added to a sequence. It creates a walking bassline on top of the sequence chords.
 */
public class Bass: Instrument {
    
    private let arranger: Improviser = Bassliner()
    public let sampler: Sampler
    public var canvas: MilesCanvas?
    public let draws: Bool

    /**
     Create a new Bass instrument.
    
     - parameter engine: the AVAudioEngine instance to use
     - parameter volume: the volume to play at
     - parameter draws: if true, draw on a canvas when notes are played
     */
    public init(engine: AVAudioEngine, volume: Float = 1, draws: Bool = true) {
        self.sampler = Sampler(engine: engine, for: .bass)
        self.sampler.volume = volume
        self.draws = draws
    }

    /**
     Generate a sequence of bass notes.
    
     - parameter sequencer: the Sequencer to use for holding Track data
     - parameter progression: the note generator to use
     */
    public func createArrangementFor(sequencer: Sequencer, progression: Sequence.Progression) {
        sequencer.populate(instrument: self) { track in
            _ = progression.steps.reduce(MusicTimeStamp(0.0)) { beat, chordIndex in
                print("beat; \(beat)  chordIndex: \(chordIndex)")
                return arranger.improviseNotes(toTrack: track, onBeat: beat,
                                               basedOn: (progression.harmonization, progression.harmonization.chords[chordIndex]))
            }
        }
    }

    /**
     Generate and return a MIDINoteMessage
    
     - parameter beat: when to play the note
     - parameter note: what note to play
     - parameter duration: how long to play the note
     - returns: new MIDINoteMessage instance
     */
    public func play(beat: MusicTimeStamp, note: Note, duration: Duration) -> MIDINoteMessage {

        if draws {
            canvas?.drawString(delay: beat, lifespan: duration.value)
        }

        return MIDINoteMessage(channel: 0,
                               note: UInt8(note.midiValue),
                               velocity: UInt8(Int.random(in: 40...70)),
                               releaseVelocity: UInt8(10),
                               duration: Float(duration.value))
    }
}
