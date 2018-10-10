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
 This class encapsulates Apple's AVAudioUnitSampler in order to load MIDI soundbank.
 */
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
    public let sampler: AVAudioUnitSampler = AVAudioUnitSampler()
    
    /// - Parameter voice: The desired voice type.
 
    /**
     Creates a new Sampler instance for the specified instrument voice.
 
     - parameter engine: the AVAudioEngine instance to use
     - parameter voice: the desired voice type to use
     */
    public init(engine: AVAudioEngine, for voice: InstrumentVoice) {
        self.engine = engine

        let bundle = Bundle(for: Sampler.self)
        guard let url = bundle.url(forResource: voice.rawValue, withExtension: "sf2") else { fatalError("Could not load file") }

        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, fromBus: 0, toBus: engine.mainMixerNode.nextAvailableInputBus, format: sampler.outputFormat(forBus: 0))

        do {
            try sampler.loadSoundBankInstrument(at: url,
                                                program: UInt8(voice.program),
                                                bankMSB: UInt8(voice.bankMSB),
                                                bankLSB: UInt8(voice.bankLSB))
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            fatalError("Could not load file")
        }

        sampler.masterGain = 1.0
    }

    /**
     Associate a MIDI track with a sampler so that when the MIDI sequence begins playing,
     the sampler will play the notes held by the given track.
    
     - parameter track: the track to play
     */
    public func assign(track: AVMusicTrack) {
        track.destinationAudioUnit = sampler
    }
}
