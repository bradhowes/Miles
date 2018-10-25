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

/**
 An enum representing the different sounds that we can play. The value of the enum will be used
 to form the name of the sound font to load in order to play the sound.
 */
public enum Patch: String {

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
        public var bankLSB: Int { return kAUSampler_DefaultBankLSB }
    }
    
    /// Obtain the MIDI bank type for this InstrumentVoice
    public var midiBankType: MidiBankType {
        switch self {
        case .drums: return .percussion
        default: return .melody
        }
    }
    
    /// Obtain the program to select when performing.
    public var program: Int {
        switch self {
        case .guitar: return 26
        default: return 0
        }
    }
    
    public var bankMSB: Int { return midiBankType.bankMSB }
    public var bankLSB: Int { return midiBankType.bankLSB }
}

/**
 This class encapsulates Apple's AVAudioUnitSampler in order to load MIDI soundbank.
 */
public class Sampler {
    
    /// The volume of the Sampler when connected to the AVAUdioEngine
    public var volume: Float {
        set {
            self.ausampler.volume = newValue
        }
        get {
            return self.ausampler.volume
        }
    }

    private let engine: AVAudioEngine
    
    /// The actual AVAudioSampler being used to generate audio from MIDI traffic
    public let ausampler: AVAudioUnitSampler = AVAudioUnitSampler()

    /**
     Creates a new Sampler instance for the specified instrument voice.
 
     - parameter engine: the AVAudioEngine instance to use
     - parameter voice: the desired voice type to use
     */
    public init(engine: AVAudioEngine, for patch: Patch) {
        self.engine = engine
        engine.attach(ausampler)
        engine.connect(ausampler, to: engine.mainMixerNode, fromBus: 0, toBus: engine.mainMixerNode.nextAvailableInputBus, format: ausampler.outputFormat(forBus: 0))
        ausampler.masterGain = 1.0
        load(patch: patch)
    }

    /**
     Set the InstrumentVoice (sound font) and patch to use in eh AVAudioUnitSampler when generating audio output.
    
     - parameter voice: the sound font and patch to use
     */
    public func load(patch: Patch) {
        let bundle = Bundle(for: Sampler.self)
        guard let url = bundle.url(forResource: patch.rawValue, withExtension: "sf2") else { fatalError("Could not load file") }
        do {
            try ausampler.loadSoundBankInstrument(at: url, program: UInt8(patch.program), bankMSB: UInt8(patch.bankMSB), bankLSB: UInt8(patch.bankLSB))
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            fatalError("Could not load file")
        }
    }
}
