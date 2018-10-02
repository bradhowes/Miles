//
//  Piano.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//
import AudioToolbox
import AVFoundation
import SpriteKit

/// A guitar instrument that can be added to a sequence.
public class Guitar: Instrument {
    
    public enum GuitarType {
        case rhythm
        case solo
    }
    
    public var sampler: Sampler
    public var arranger: Improviser
    public var canvas: MilesCanvas?
    public let draws: Bool

    /// Creates a new Piano instrument instance.
    ///
    /// - Parameters:
    ///   - type: A `PianoType` value indicating how the piano will generate the music.
    ///   - volume: The volume for the instrument *(should be between 0 and 1)*. Default is 1. 
    public init(engine: AVAudioEngine, for type: GuitarType, volume: Float = 1, draws: Bool = true) {
        self.sampler = Sampler(engine: engine, for: .guitar)
        self.sampler.volume = volume
        self.draws = draws
        self.arranger = type == .rhythm ? ChordComper() : Soloer()
    }

    public func createArrangementFor(sequencer: Sequencer, progression: Sequence.Progression) {
        sequencer.populate(instrument: self) { track in
            _ = progression.steps.reduce(MusicTimeStamp(0.0)) { beat, chordIndex in
                return arranger.improviseNotes(toTrack: track, onBeat: beat, basedOn: (progression.harmonization, progression.harmonization.chords[chordIndex]))
            }
        }
    }

    public func play(beat: MusicTimeStamp, note: Note, duration: Duration) -> MIDINoteMessage {
        if draws {
            if Bool.random() {
                canvas?.drawCircle(withSizeMiultiplier: 9, delay: beat, lifespan: duration.value)
            } else {
                canvas?.drawBlock(withSizeMiultiplier: 2, delay: beat, lifespan: duration.value)
            }
        }
        return MIDINoteMessage(channel: 0,
                               note: UInt8(note.midiValue),
                               velocity: UInt8(Int.random(in: 40...70)),
                               releaseVelocity: UInt8(0),
                               duration: Float(duration.value / 4.0))
    }
}
