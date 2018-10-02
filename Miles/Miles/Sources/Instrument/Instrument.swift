//
//  Instrument.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

/// An enum representing the different types an instrument can have. 
public enum InstrumentVoice: String {
    case piano
    case drums
    case bass
    case sax
    case trumpet

    public var midiType: Sampler.MidiBankType {
        switch self {
        case .drums: return Sampler.MidiBankType.Percussion
        default:  return Sampler.MidiBankType.Melody
        }
    }
}

public protocol Instrument: ImproviserDelegate, Drawable {
    var sampler: Sampler { get }
    var canvas: MilesCanvas? { get set }

    /// Uses the instrument's algorithm to create a music sequence based on the specified harmonization, chords and instrument type.
    ///
    /// - Parameters:
    ///   - progression: A tuple with the most important info about the sequence.
    ///
    ///     **Porgression** = (harmonization: `Harmonization`, steps: `[Int]` )
    ///   - tempo: The tempo *(in beats per minute)* that the music will have.
    func createArrangementFor(sequencer: Sequencer, progression: Sequence.Progression)
}
