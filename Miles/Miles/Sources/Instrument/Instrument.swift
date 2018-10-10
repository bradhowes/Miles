//
//  Instrument.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AVFoundation

/// An enum representing the different types an instrument can have. 
public enum InstrumentVoice: String {

    case bass = "bass"
    case drums = "drums"
    case guitar = "GeneralUser"
    case piano = "piano"
    case sax = "sax"
    case trumpet = "trumpet"

    /**
     There are two types of MIDI banks in the General MIDI standard: melody and percussion
     */
    public enum MidiBankType  {
        case melody
        case percussion

        /// Obtain the most-significant byte of the bank for the program/voice
        public var bankMSB: Int {
            switch self {
            case .percussion: return kAUSampler_DefaultPercussionBankMSB
            default: return kAUSampler_DefaultMelodicBankMSB
            }
        }

        /// Obtain the least-significant byte of the bank for the program/voice
        public var bankLSB: Int {
            return kAUSampler_DefaultBankLSB
        }
    }

    /// Obtain the MIDI bank type for the voice
    public var midiBankType: MidiBankType {
        switch self {
        case .drums: return .percussion
        default: return .melody
        }
    }

    /// Obtain the program to select when performing
    public var program: Int {
        switch self {
        case .guitar: return 26
        default: return 0
        }
    }

    public var bankMSB: Int {
        return midiBankType.bankMSB
    }

    public var bankLSB: Int {
        return midiBankType.bankLSB
    }
}

public protocol Instrument: class, Drawable {

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

    /**
     Generate and return a MIDINoteMessage that can be added to a Track/MusicTrack for this instrument.
     Note that the instrument can modify and/or ignore any of the values. These are only suggestions
     provided by an Improviser. That said, the `note` value probably should remain the same, and the
     `beat` value should only deviate slightly if at all.

     - parameter beat: when to play the note
     - parameter note: what note to play
     - parameter duration: how long to play the note
     - returns: new MIDINoteMessage instance
     */
    func play(beat: MusicTimeStamp, note: Note, duration: Duration) -> MIDINoteMessage
}
