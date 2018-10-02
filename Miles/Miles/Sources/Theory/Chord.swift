//
//  Chord.swift
//  Miles
//
//  Created by Lalo Martínez on 3/23/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import Foundation

public enum ChordQuality: String {
    
    case Maj7
    case M7s5
    case min7
    case m7b5
    case dim7
    case dom7
    case sus4
    
    public var intervals: [Interval] {
        switch self {
        case .Maj7: return [.P1, .M3, .P5, .M7]
        case .M7s5: return [.P1, .M3, .m6, .M7]
        case .min7: return [.P1, .m3, .P5, .m7]
        case .m7b5: return [.P1, .m3, .d5, .m7]
        case .dim7: return [.P1, .m3, .d5, .M6]
        case .dom7: return [.P1, .M3, .P5, .m7]
        case .sus4: return [.P1, .P4, .P5, .m7]
        }
    }
    
    public var improvScales: [Scale] {
        switch self {
        case .Maj7: return [.major, .lydian] + Scale.allMajor
        case .min7: return [.aeolian, .phrygian, .dorian, .blues] + Scale.allMinor
        case .m7b5: return [.locrian]
        case .dom7: return [.mixolydian, .lydian, .dominantBebop]
        case .sus4: return Scale.allMajor
        case .dim7: return [.diminished, .minorBebop]
        case .M7s5: return [.diminished, .minorBebop]
        }
    }
    
}

public enum ChordExtension {
    case m9
    case M9
    case A9
    case P11
    case A11
    case m13
    case M13
    
    public var interval: Interval {
        switch self {
        case .m9: return .m2
        case .M9: return .M2
        case .A9: return .m3
        case .P11: return .P4
        case .A11: return .d5
        case .m13: return .m6
        case .M13: return .M6
        }
    }
}

public struct Chord: CustomStringConvertible {
    public let root: Tone
    public let quality: ChordQuality
    public let extensions: [ChordExtension]
    public let tones: [Tone]
    
    public func notes(atOctave octave:Int, inversion: Int = 0) -> [Note] {
        let notes = tones.map { Note(tone: $0, octave: self.root.rawValue < $0.rawValue ? octave : octave + 1) }
        let extns = extensions.map{ Note(tone: root.interval($0.interval), octave: octave + 1) }
        return (notes + extns).enumerated().map { ($0 < inversion) ? $1.raiseOctave() : $1 }
    }
    
    public init(root: Tone, quality: ChordQuality, extensions: [ChordExtension] = []) {
        self.root = root
        self.quality = quality
        self.extensions = extensions
        self.tones =  quality.intervals.map{ root.interval($0) }
    }
    
    public var description: String {
        return "\(self.root)\(self.quality.rawValue)"
    }
}

