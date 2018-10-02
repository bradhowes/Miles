//
//  Soloer.swift
//  Miles
//
//  Created by Lalo Martínez on 3/26/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox

/// Creates a melody line based on a random scale that works with each chord. 
public class Soloer: Improviser {
    private let durations: [Duration] = [.half(dotted: false), .quarter(dotted: false), .eighth(dotted: false)]

    public typealias ScaleRange = (min: Int, max: Int)
    public let scaleRange: ScaleRange
    public let canOverlapNotes: Bool

    public init(inScales scales: ScaleRange = (3, 4), canOverlapNotes:Bool = true) {
        self.scaleRange = scales
        self.canOverlapNotes = canOverlapNotes
    }
    
    public func improviseNotes(toTrack track: Track, onBeat beat: MusicTimeStamp, basedOn harmony: Improviser.Harmony) -> MusicTimeStamp {
        var internalBeat = MusicTimeStamp(0.0)
        let availableScales = harmony.chord.quality.improvScales + [harmony.harmonization.scale]
        let improvScale = availableScales.randomElement()!

        print("Will solo in \(harmony.harmonization.key)\(improvScale) over \(harmony.chord)")

        while internalBeat <= 4 {
            if Int.random(in: 0...5) != 0 { // 1/6 = probability of not having a note
                let duration = durations.randomElement()!
                let realBeat = beat + internalBeat
                let note = Note(tone: improvScale.tones(forKey: harmony.harmonization.key).randomElement()!,
                                octave: Int.random(in: scaleRange.min...scaleRange.max))
                track.add(note: note, onBeat: realBeat, duration: duration)

                //If overlapping notes is permitted, advances a random duration, if not, advances the note's duration.
                internalBeat += (canOverlapNotes ? durations.randomElement()! : duration).value
            } else {
                //If theres no note and should add a rest.
                internalBeat += durations.randomElement()!.value
            }
        }

        return beat + 4
    }
}
