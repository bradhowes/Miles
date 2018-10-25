//
//  Drums.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox
import AVFoundation
import SpriteKit

/// A Drum Kit instrument that can be added to a sequence. It can use different drum elements like hihats, ride, snare and/or bass drum.
public class Drums: Instrument {
    public var sampler: Sampler
    public let arranger: Improviser
    public var canvas: MilesCanvas?
    public let draws: Bool
    
    /// Creates a new Drums instance with the specified parts.
    ///
    /// - Parameters:
    ///   - parts: The parts that the instrument will include
    ///   - volume: The volume for the instrument *(should be between 0 and 1)*. Default is 1.
    public init(engine: AVAudioEngine, withParts parts: Set<DrumSwinger.DrumPart>, volume: Float = 1, draws: Bool = true) {
        self.sampler = Sampler(engine: engine, for: .drums)
        self.arranger = DrumSwinger(withParts: parts)
        self.sampler.volume = volume
        self.draws = draws
    }

    public func createArrangement(sequencer: Sequencer, progression: Sequence.Progression) {
        sequencer.populate(instrument: self) { track in
            _ = progression.steps.reduce(MusicTimeStamp(0.0)) { beat, _ in //The chord does not matter here.
                return self.arranger.improviseNotes(toTrack: track, onBeat: beat,
                    basedOn: (progression.harmonization, progression.harmonization.chords.randomElement()!))
            }
        }
    }

    public func play(beat: MusicTimeStamp, note: Note, duration: Duration) -> MIDINoteMessage {
        if draws && note.midiValue == 51 {
            canvas?.drawCymbalCircle(delay: beat, lifespan: duration.value)
        }
        return MIDINoteMessage(channel: 0,
                               note: UInt8(note.midiValue),
                               velocity: UInt8(Int.random(in: 40...70)),
                               releaseVelocity: UInt8(0),
                               duration: Float(duration.value))
    }
}
