//
//  Interval.swift
//  Miles
//
//  Created by Lalo Martínez on 3/23/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

public enum Interval: Int, CustomStringConvertible  {
    
    case P1
    case m2
    case M2
    case m3
    case M3
    case P4
    case d5
    case P5
    case m6
    case M6
    case m7
    case M7
    case P8

    public var description: String {
        switch self {
        case .P1: return "Unison"
        case .m2: return "Minor Second"
        case .M2: return "Major Second"
        case .m3: return "Minor Third"
        case .M3: return "Major Third"
        case .P4: return "Perfect Fourth"
        case .d5: return "Diminished Fifth"
        case .P5: return "Perfect Fifth"
        case .m6: return "Minor Sixth"
        case .M6: return "Major Sixth"
        case .m7: return "Minor Seventh"
        case .M7: return "Major Seventh"
        case .P8: return "Perfect Octave"
        }
    }
}
