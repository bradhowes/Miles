//
//  Teacher.swift
//  Miles
//
//  Created by Lalo Martínez on 3/28/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import AudioToolbox
import AVFoundation

/// The PianoTeacher is an instrument-like class designed to show how music works by playing different scales and harmonizations in a non-jazz way.
open class PianoTeacher: Drawable {
    private let durations: [Duration] = [.half(dotted: false), .quarter(dotted: false), .eighth(dotted: false)]
    private let engine: AVAudioEngine
    private let sequencer: Sequencer
    private let instrument: Instrument

    open var canvas: MilesCanvas?
    open var draws: Bool

    public init(draws: Bool = true, withTempo tempo: Double) {
        self.engine = AVAudioEngine()
        self.instrument = Piano(engine: engine, for: .comping, volume: 1.0, draws: draws)
        self.sequencer = Sequencer(engine: engine, withTempo: tempo)
        try? engine.start()
        self.draws = draws
    }

    /// Allows the PianoTeacher to show how a scale *feels*. Plays the notes of the scale specified in the key specified.
    ///
    /// - Parameters:
    ///   - scale: The scale to play in.
    ///   - key: The tone used as root by the scale.
    ///   - octaves: The octaves the scale should be played in.
    ///   - tempo: The speed at which the scale should be played.
    ///   - useStaticTime: A Boolean value indicating wether or not all notes should have the same duration.
    open func play(scale: Scale, inKey key: Tone, inOctaves octaves: [Int], useStaticTime: Bool) {
        canvas?.tempo = sequencer.tempo
        sequencer.populate(instrument: instrument) { track in
            octaves.forEach { octave in
                _ = notesForScale(scale: scale, key: key, atOctave: octave).reduce(MusicTimeStamp(0.0)) { beat, note in
                    let dur: Duration = useStaticTime ? .quarter(dotted: false) : durations.randomElement()!
                    track.add(note: note, onBeat: beat, duration: dur)
                    canvas?.drawCircle(withSizeMiultiplier: 6, boring: useStaticTime, fades: true, delay: beat, lifespan: dur.value)
                    return beat + dur.value
                }
            }
        }

        sequencer.complete()
        sequencer.start()
    }

    /// Allows the PianoTeacher to show how a *harmonization* sounds like. Plays the chords inside the specified harmonization.
    /// All chords' duration is 2 beats of a bar.
    ///
    /// - Parameters:
    ///   - harmonization: The harmonization the `PianoTeacher` instance should play.
    ///   - octave: The octave to play the chords in.
    ///   - tempo: The speed at which the chords should be played
    ///   - arpeggiated: A boolean value indicating wether or not the notes in the chord should be arpeggiated.
    open func playChordsIn(harmonization: Harmonization, atOctave octave: Int, arpeggiated: Bool) {
        canvas?.tempo = sequencer.tempo
        sequencer.populate(instrument: instrument) { track in
            _ = harmonization.chords.reduce(MusicTimeStamp(0.0)) { beat, chord in
                _ = chord.notes(atOctave: octave).reduce(MusicTimeStamp(0.0)) { internalBeat, note in
                    let realBeat = beat + internalBeat
                    let dur = Duration.half(dotted: false)
                    track.add(note: note, onBeat: realBeat, duration: dur)
                    canvas?.drawCircle(withSizeMiultiplier: 6, fades: true, delay: realBeat, lifespan: dur.value)
                    return internalBeat + (arpeggiated ? 0.2 : 0.0)
                }
                return beat + 2
            }
        }
        sequencer.complete()
        sequencer.start()
    }
    
    private func notesForScale(scale: Scale, key: Tone, atOctave octave: Int) -> [Note] {
        let mappedNotes = scale.tones(forKey: key).map { (tone: Tone) -> Note in
            let correctOctave: Int = tone.rawValue < key.rawValue ? octave + 1 : octave
            return Note(tone: tone, octave: correctOctave)
        }
        return mappedNotes
    }
}
