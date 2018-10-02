//: ![I could not resist designing a logo](miles_logo.pdf)
//: ## [Previous](@previous) | [Next](@next)

import PlaygroundSupport
import SpriteKit
import Miles

PlaygroundPage.current.needsIndefiniteExecution = true
let view = SKView(frame: CGRect(x: 0, y: 0, width: 800, height: 500))
PlaygroundPage.current.liveView = view

// Creates the canvas
let canvas = MilesCanvas()
canvas.colorPalette = UIColor.purpleRain
canvas.scaleMode = .resizeFill
view.presentScene(canvas)
/*:
 ## Harmonizations
 
 Just as scales can help a musician to create melodies. Harmonizations help them to create chord progressions.
 
 Harmonizations are a group of chords (which are in turn, based on scale) that sound good when played together.
 
 Now, let's create a new harmonization that our teacher can play:
 
 ---
 */

let harmonization = Harmonization(key: .Eflat, type: .harmonicMinor)
let teacher = PianoTeacher(withTempo: 100)
teacher.canvas = canvas
teacher.playChordsIn(harmonization: harmonization, atOctave: 2, arpeggiated: false)

/*:
 ▶️ Run the playground now to make our teacher play the harmonization

 Interesting, right?
 
 + Experiment:
 Let's listen other types of harmonizations
 
 - Change the harmonization's `key` and `type` to hear different types of chords
 - Change the `arpeggiated` argument to `true` to play the notes of each chord as an arpeggio.
 
 ---
 
 ## [Previous](@previous) | [Next](@next)
 */
