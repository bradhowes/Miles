//
//  DrumSwinger.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/// Creates a swing drum pattern with the drum parts specified (snare, hihats, etc.)
public class DrumSwinger: Improviser {

    public enum DrumPart {
        case hihats
        case bass
        case snare
        case ride
        
        /// Returns the correct note(MIDI Value) for the specified drum part
        public var midiValue: Int {
            switch self {
            case .hihats: return [42, 44].randomElement()!
            case .ride:   return 51
            case .bass:   return 36
            case .snare:  return 38
            }
        }
        
        public var preferedVelocity: Int {
            switch self {
            case .hihats: return Int.random(in: 45...55)
            case .ride:   return Int.random(in: 30...35)
            case .bass:   return Int.random(in: 40...50)
            case .snare:  return Int.random(in: 30...45)
            }
        }
    }
    
    private let parts: Set<DrumPart>

    public init(withParts parts: Set<DrumPart>) {
        self.parts = parts
    }
    
    public func improviseNotes(toTrack track: Track, onBeat beat: MusicTimeStamp, basedOn harmony: Improviser.Harmony) -> MusicTimeStamp {
        parts.forEach { part in
            _ = Rhythm.DrumBeat(part: part).pattern.reduce(MusicTimeStamp(0.0)) { partBeat, bit in
                switch bit {
                case .note(let dur):
                    let realBeat = beat + partBeat
                    track.add(note: Note(midi: part.midiValue), onBeat: realBeat, duration: dur)
                    return partBeat + dur.value
                case .rest(let dur):
                    return partBeat + dur.value
                }
            }
        }
        return beat + 4
    }
}
