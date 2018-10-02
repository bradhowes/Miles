
//
//  File.swift
//  Miles
//
//  Created by Lalo Martínez on 3/21/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

public class Sequencer {

    private var sequencer: AVAudioSequencer
    private var sequence: MusicSequence
    private var samplers: [Sampler] = []

    private var data: Data {
        get {
            var status = OSStatus(noErr)
            var data:Unmanaged<CFData>?
            status = MusicSequenceFileCreateData(sequence,
                                                 MusicSequenceFileTypeID.midiType,
                                                 MusicSequenceFileFlags.eraseFile,
                                                 480, &data)
            if status != noErr {
                fatalError("failed MusicSequenceFileCreateData - \(status)")
            }

            let ns: Data = data!.takeUnretainedValue() as Data
            data!.release()

            return ns
        }
    }
    
    public let tempo: Double
    public private(set) var duration: TimeInterval = 0.0

    public init(engine: AVAudioEngine, withTempo tempo: Double) {
        self.sequencer = AVAudioSequencer(audioEngine: engine)

        var ms: MusicSequence?
        var status = NewMusicSequence(&ms)
        if status != noErr {
            fatalError("failed NewMusicSequence - \(status)")
        }

        self.sequence = ms!
        self.tempo = tempo

        // Set tempo track -- necessary?
        var tempoTrack: MusicTrack?
        status = MusicSequenceGetTempoTrack(sequence, &tempoTrack)
        if status != noErr {
            fatalError("failed MusicSequenceGetTempoTrack - \(status)")
        }

        status = MusicTrackNewExtendedTempoEvent(tempoTrack!, 0, tempo)
        if status != noErr {
            fatalError("failed MusicTrackNewExtendedTempoEvent - \(status)")
        }
    }
    
    private func initializeMIDI(_ track: MusicTrack) {
        // Is all of this necessary? Perhaps if there is an external MIDI device connected to the network.
        // Bank select msb
        var chanmess = MIDIChannelMessage(status: 0xB0, data1: 0, data2: 0, reserved: 0) //MIDI Channel Message for status 176
        var status = MusicTrackNewMIDIChannelEvent(track, 0, &chanmess)
        if status != OSStatus(noErr) {
            print("creating bank select event \(status)")
        }
        
        // Bank select lsb
        chanmess = MIDIChannelMessage(status: 0xB0, data1: 32, data2: 0, reserved: 0)// MIDI Channel Message for status 176 / Data byte 1: 32-63 LSB of 0-31
        status = MusicTrackNewMIDIChannelEvent(track, 0, &chanmess)
        if status != OSStatus(noErr) {
            print("creating bank select event \(status)")
        }
        
        // program change. first data byte is the patch, the second data byte is unused for program change messages. Status 192: Command value for Program Change message (https://docs.oracle.com/javase/7/docs/api/javax/sound/midi/ShortMessage.html#PROGRAM_CHANGE)
        chanmess = MIDIChannelMessage(status: 0xC0, data1: 0, data2: 0, reserved: 0)
        status = MusicTrackNewMIDIChannelEvent(track, 0, &chanmess)
        if status != OSStatus(noErr) {
            print("creating program change event \(status)")
        }
    }

    public func populate(sampler: Sampler, withArrangement arrange: (MusicTrack) -> Void) {
        var mt: MusicTrack?
        let status = MusicSequenceNewTrack(sequence, &mt)
        if status != noErr {
            fatalError("failed MusicSequenceNewTrack - \(status)")
        }

        samplers.append(sampler)
        initializeMIDI(mt!)
        arrange(mt!)
    }
    
    public func complete() {
        try! sequencer.load(from: data)
        sequencer.prepareToPlay()
        zip(samplers, sequencer.tracks).forEach { $0.0.assign(track: $0.1) }
        duration = sequencer.tracks.map { $0.lengthInSeconds }.max()!
        sequencer.prepareToPlay()
    }
    
    public func start() {
        sequencer.currentPositionInBeats = TimeInterval(0)
        try! sequencer.start()
    }

    public func stop() {
        sequencer.stop()
    }
    
    public var isPlaying: Bool {
        print("\(sequencer.isPlaying) - \(sequencer.currentPositionInSeconds)")
        if sequencer.isPlaying && sequencer.currentPositionInSeconds >= duration {
            print("stpppoing")
            sequencer.currentPositionInSeconds = 0.0
            sequencer.stop()
        }
        return sequencer.isPlaying
    }
}
