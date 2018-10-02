//
//  Tone.swift
//  Miles
//
//  Created by Lalo Martínez on 3/22/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

public enum Tone: Int, CustomStringConvertible, CaseIterable {
  
    case C = 0
    case Csharp
    case D
    case Eflat
    case E
    case F
    case Fsharp
    case G
    case Aflat
    case A
    case Bflat
    case B

    public static let baseOctave = 2
    
    public static func fromMidi(_ midi: Int) -> (Tone, Int) {
        return (Tone.allCases[midi % 12], midi / 12 - Tone.baseOctave)
    }

    public func interval(_ interval: Interval) -> Tone {
        return Tone.allCases[ (self.rawValue + interval.rawValue) % Tone.allCases.count ]
    }

    public func toMidi(octave: Int) -> Int { return self.rawValue + 12 * (octave + Tone.baseOctave) }

    public var description: String {
        switch self {
        case .C:      return "C"
        case .Csharp: return "C♯"
        case .D:      return "D"
        case .Eflat:  return "E♭"
        case .E:      return "E"
        case .F:      return "F"
        case .Fsharp: return "F♯"
        case .G:      return "G"
        case .Aflat:  return "A♭"
        case .A:      return "A"
        case .Bflat:  return "B♭"
        case .B:      return "B"
        }
    }
}
