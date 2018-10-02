![Could not resist designing  a logo](https://image.ibb.co/k4tmVS/logoessay.jpg)

## A jazz improviser created in Swift Playgrounds as a submission for WWDC 2018 Student Scholarship. 


Miles can create jazz improvisations for piano, bass and drums in any key and any tempo. 
 

## Technologies 
* **AudioToolbox** (for MIDI)
* **AVFoundation:** AVAudioUnitSampler and AVAudioSequencer to create the MIDI playback and soundfont sampling
* **SpriteKit** to create the animations

[Watch it on Youtube](https://www.youtube.com/watch?v=gX_dBSTE-cE)

# Notes on This Fork

The original [Miles](https://github.com/LaloMrtnz/Miles) worked fine and it has some good ideas for synthetic improvisation. I wanted to expand on them so I refactored the code into a framework to make it easier to debug and test. I also -- I think -- simplified some of the AVFoundation usage by only using one AVAudioEngine for all of the instruments, as well as one AVAudioSequencer that generates a separate MIDI track for each instrument.

Note that the original code only worked on macOS. My version only works on iOS. :)

# Notes on Running

* You should probably build the framework first before attempting to run the playgrounds
* When viewing one of the three playgrounds, make sure you are also showing a "Live View" by enabling the "Assistant Editor" and then selecting the "Live View (1)" item in the popup menu available at the top of the assistant editor. 
* You may have to play/stop/play a playground to get everything working right.
