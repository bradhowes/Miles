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

/// A bass instrument that can be added to a sequence. It creates a walking bassline on top of the sequence chords.
public class Bass: Instrument {
    private let arranger: Improviser = Bassliner()
    public let sampler: Sampler
    public var canvas: MilesCanvas?
    public let draws: Bool
    
    /// Creates a new bass instrument instance.
    ///
    /// - Parameter volume: The volume for the instrument *(should be between 0 and 1)*. Default is 1.
    public init(engine: AVAudioEngine, volume: Float = 1, draws: Bool = true) {
        self.sampler = Sampler(engine: engine, for: .bass)
        self.sampler.volume = volume
        self.draws = draws
        self.arranger.delegate = self
    }
    
    public func createArrangementFor(sequencer: Sequencer, progression: Sequence.Progression) {
        sequencer.populate(sampler: self.sampler) { track in
            _ = progression.steps.reduce(MusicTimeStamp(0.0)) { beat, chordIndex in
                print("beat; \(beat)  chordIndex: \(chordIndex)")
                return arranger.improviseNotes(toTrack: track, onBeat: beat,
                                               basedOn: (progression.harmonization, progression.harmonization.chords[chordIndex]))
            }
        }
    }

    public func addedNote(withMidiValue: Int, atBeat beat: Double, withDuration duration: Double) {
        if draws {
            canvas?.drawString(delay: beat, lifespan: duration)
        }
    }
}
