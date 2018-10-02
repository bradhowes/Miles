//
//  Scale.swift
//  Miles
//
//  Created by Lalo Martínez on 3/23/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//
import Foundation

public enum Scale: Int, CaseIterable {
    
    case major
    case minor
    case minorHarmonic
    case minorMelodic
    case majorPentatonic
    case minorPentatonic
    case majorBebop
    case minorBebop
    case dominantBebop
    case augmented
    case diminished
    case dorian
    case phrygian
    case lydian
    case mixolydian
    case aeolian
    case locrian
    case blues
    case spanishGypsy

    public func tones(forKey fundamental: Tone) -> [Tone] { return self.intervals.map { fundamental.interval($0) } }
    
    public var intervals: [Interval] {
        switch self {
        case .major: return [.P1, .M2, .M3, .P4, .P5, .M6, .M7]
        case .minor: return [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
        case .minorHarmonic: return [.P1, .M2, .m3, .P4, .P5, .m6, .M7]
        case .minorMelodic:  return [.P1, .M2, .m3, .P4, .P5, .M6, .M7]
        case .majorPentatonic: return [.P1, .M2, .M3, .P5, .M6]
        case .minorPentatonic: return [.P1, .m3, .P4, .P5, .m7]
        case .majorBebop: return [.P1, .M2, .M3, .P4, .P5, .m6, .M6, .M7]
        case .minorBebop: return [.P1, .M2, .m3, .P4, .P5, .m6, .M6, .M7]
        case .dominantBebop: return [.P1, .M2, .M3, .P4, .P5, .M6, .m7, .M7]
        case .augmented: return [.P1, .m3, .M3, .P5, .m6, .M7]
        case .diminished: return [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7]
        case .dorian: return [.P1, .M2, .m3, .P4, .P5, .M6, .m7]
        case .phrygian: return [.P1, .m2, .m3, .P4, .P5, .m6, .m7]
        case .lydian: return [.P1, .M2, .M3, .d5, .P5, .M6, .M7]
        case .mixolydian: return [.P1, .M2, .M3, .P4, .P5, .M6, .m7]
        case .aeolian: return [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
        case .locrian: return [.P1, .m2, .m3, .P4, .d5, .m6, .m7]
        case .blues: return [.P1, .m3, .P4, .d5, .P5, .m7]
        case .spanishGypsy: return [.P1, .m2, .M3, .P4, .P5, .m6, .m7]
        }
    }
    
    public static var count: Int { return Scale.allCases.count }
    public static var allMajor: [Scale] { return [.major, .majorPentatonic, .majorBebop] }
    public static var allMinor: [Scale] { return [.minor, .minorMelodic, .minorHarmonic, .minorPentatonic, .minorBebop] }
    public static var random: Scale { return Scale.allCases.randomElement()! }
}

