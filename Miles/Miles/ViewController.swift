//
//  ViewController.swift
//  Miles
//
//  Created by Lalo Martínez on 3/19/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
  
  var sequence: Sequence!

  override func loadView() {
    super.loadView()
    
    self.view.backgroundColor = .white
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Touch", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(touched1), for: .touchDown)
    button.addTarget(self, action: #selector(leaved1), for: .touchUpInside)
    self.view.addSubview(button)
    
    button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    
    let button2 = UIButton()
    button2.translatesAutoresizingMaskIntoConstraints = false
    button2.setTitle("Touch2", for: .normal)
    button2.setTitleColor(.black, for: .normal)
    button2.addTarget(self, action: #selector(touched2), for: .touchDown)
    button2.addTarget(self, action: #selector(leaved2), for: .touchUpInside)
    self.view.addSubview(button2)
    
    button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    button2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
    
    let piano = Piano(for: .comping)
    let drums = Drums(withParts: [.Ride, .Hihats, .Snare, .Bass])
    let bass = Bass()
    let harmonization = Harmonization(key: .A, type: .major)
    
    sequence = Sequence(harmonization: harmonization, withInstruments: [piano, drums, bass])
    sequence.createArrangement()
  }
  
  @objc private func touched1() {
//    sampler.startNote(note: 60)
    
  }
  
  @objc func leaved1() {
//    sampler.stopNote(note: 60)
  }
  
  @objc private func touched2() {
//    sampler.startPlaying()
    
  }
  
  @objc func leaved2() {
    sequence.startPlaying()
  }

}
