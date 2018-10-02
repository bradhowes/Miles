//
//  Sampler.swift
//  Miles
//
//  Created by Lalo Martínez on 3/20/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

/// This class encapsulates Apple's AVAudioUnitSampler and AVAudioSequencer in order to load MIDI soundbanks, and create and sequence MIDI events on CoreMIDI tracks and sequences.
///
/// The sampler audio unit can be configured by loading different types of instruments such as an .aupreset file, a DLS or SF2 sound bank. The output is a single stereo bus.

public class Sampler {
    
    /// The volume of the Sampler when connected to the AVAUdioEngine
    public var volume: Float {
        set {
            self.sampler.volume = newValue
        }
        get {
            return self.sampler.volume
        }
    }

    private let engine: AVAudioEngine
    private let sampler: AVAudioUnitSampler = AVAudioUnitSampler()
    
    /// Creates a new Sampler instance for the specified instrument voice.
    ///
    /// - Parameter voice: The desired voice type.
    public init(engine: AVAudioEngine, for voice: InstrumentVoice) {
        self.engine = engine

        let bundle = Bundle(for: Sampler.self)
        guard let url = bundle.url(forResource: voice.rawValue, withExtension: "sf2") else { fatalError("Could not load file") }
        
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, fromBus: 0, toBus: engine.mainMixerNode.nextAvailableInputBus, format: sampler.outputFormat(forBus: 0))
        // engine.connect(sampler, to: engine.mainMixerNode, format: nil)

        do {
            try sampler.loadSoundBankInstrument(at: url, program: MidiBankType.defaultProgram,
                                                bankMSB: voice.midiType.value, bankLSB: MidiBankType.DefaultBankLSB.value)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            fatalError("Could not load file")
        }

        sampler.masterGain = 1.0
    }

    /// The MIDI bank types a sampler can use for the different sounds.
    public enum MidiBankType  {
        case Melody
        case Percussion
        case DefaultBankLSB
        
        public var value: UInt8 {
            switch self {
            case .Melody: return UInt8(kAUSampler_DefaultMelodicBankMSB)
            case .Percussion: return UInt8(kAUSampler_DefaultPercussionBankMSB)
            case .DefaultBankLSB: return UInt8(kAUSampler_DefaultBankLSB)
            }
        }
        
        public static let defaultProgram: UInt8 = 0
        
    }

    public func assign(track: AVMusicTrack) {
        track.destinationAudioUnit = sampler
    }
}
