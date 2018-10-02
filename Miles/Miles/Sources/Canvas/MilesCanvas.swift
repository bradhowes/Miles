//
//  JazzVisualizer.swift
//  Miles
//
//  Created by Lalo Martínez on 3/27/18.
//  Copyright © 2018 Lalo Martínez. All rights reserved.
//

import SpriteKit

/// MilesCanvas is a sublass of `SKScene` used to render a visual representation of the notes played by Miles. 
open class MilesCanvas: SKScene {
    private let bundle = Bundle(for: MilesCanvas.self)
    
    public enum DrawableNoteType {
        case block
        case circle(size: CGFloat)
        case string
    }
    
    /// The color palette used to create the visuals.
    open var colorPalette: ColorPalette = UIColor.originalMiles
    
    open var tempo: Double = 120
    
    private let commonFadeTime: Double = 1.2
    
    private func makeNode(named: String) -> SKSpriteNode {
        let path = bundle.path(forResource: name, ofType: "png")
        let image = UIImage(named: path!, in: bundle, compatibleWith: nil)
        return SKSpriteNode(texture: SKTexture(image: image!))
    }
    
    //Initial setup
    open override func didMove(to view: SKView) {
        backgroundColor = colorPalette.background
        physicsWorld.gravity = CGVector.zero
        self.scaleMode = .resizeFill
    }
    
    
    open func drawCircle(withSizeMiultiplier multiplier: CGFloat, boring: Bool = false, fades: Bool = false, delay: Double, lifespan: Double) {
        
        let circle = makeNode(named: "circle")
        
        //Size
        let newSize = boring ? 60 : 25 * CGFloat.random(in: 1...multiplier)
        circle.size = CGSize(width: newSize, height: newSize)
        
        //Position
        let heightAdjust = circle.size.height / 2
        let widthAdjust = circle.size.width / 2
        
        let randomY = CGFloat.random(in: ((self.size.height * 0.05) + heightAdjust)...((self.size.height * 0.9) - heightAdjust))
        let randomX = CGFloat.random(in: ((self.size.width * 0.05) + widthAdjust)...((self.size.width * 0.9) - widthAdjust))
        circle.position = CGPoint(x: randomX, y: boring ? size.height / 2 : randomY)
        
        //Color
        circle.color = self.colorPalette.colors.randomElement()!
        circle.colorBlendFactor = 1
        circle.blendMode = SKBlendMode.screen
        
        run(SKAction.wait(forDuration: convertToTempo(delay))) {
            self.addChild(circle)
            if fades {
                circle.run(SKAction.fadeOut(withDuration: self.commonFadeTime)) {
                    circle.removeFromParent()
                }
            } else {
                self.run(SKAction.wait(forDuration: self.convertToTempo(lifespan))) {
                    circle.removeFromParent()
                }
            }
        }
    }
    
    open func drawBlock(withSizeMiultiplier multiplier: CGFloat, boring: Bool = false, fades: Bool = false, delay: Double, lifespan: Double) {
        
        let name = "block\(Int.random(in: 1...3))"
        let block = makeNode(named: name)
        
        //Size
        block.size.height *= boring ? 0.5 : CGFloat.random(in: 0.5...multiplier)
        block.size.width *= boring ? 0.5 : CGFloat.random(in: 0.5...multiplier)
        
        //Rotation
        let rotation: CGFloat = (CGFloat(Int.random(in: 0...4)) * 90) + CGFloat.random(in: 0...3)
        block.zRotation = boring ? 0 : rotation * CGFloat.pi / 180
        
        //Position
        let heightAdjust = block.size.height / 2
        let widthAdjust = block.size.width / 2
        
        let randomY = CGFloat.random(in: ((self.size.height * 0.05) + heightAdjust)...((self.size.height * 0.9) - heightAdjust))
        let randomX = CGFloat.random(in: ((self.size.width * 0.05) + widthAdjust)...((self.size.width * 0.9) - widthAdjust))
        block.position = CGPoint(x: randomX, y: boring ? size.height / 2 : randomY)
        
        //Color
        block.color = self.colorPalette.colors.randomElement()!
        block.colorBlendFactor = 1
        block.blendMode = SKBlendMode.screen
        
        run(SKAction.wait(forDuration: convertToTempo(delay))) {
            self.addChild(block)
            if fades {
                block.run(SKAction.fadeOut(withDuration: self.commonFadeTime)) {
                    block.removeFromParent()
                }
            } else {
                self.run(SKAction.wait(forDuration: self.convertToTempo(lifespan))) {
                    block.removeFromParent()
                }
            }
        }
    }
    
    
    open func drawString(delay: Double, lifespan: Double) {
        
        let string = makeNode(named: "string")
        
        //Adjust size
        string.size.height = size.height
        string.size.width = 5
        
        let partialWith = size.width * 0.2
        let widthOffset = (size.width - partialWith) / 2
        
        let xPosition = partialWith / 3 * CGFloat(Int.random(in: 0...3))
        string.position = CGPoint(x: widthOffset + xPosition, y: size.height / 2)
        
        //Color
        string.color = .white
        string.colorBlendFactor = 1
        string.blendMode = SKBlendMode.screen
        
        run(SKAction.wait(forDuration: convertToTempo(delay))) {
            self.addChild(string)
            string.run(SKAction.fadeOut(withDuration: self.convertToTempo(lifespan))) {
                string.removeFromParent()
            }
        }
    }
    
    open func drawCymbalCircle(delay: Double, lifespan: Double) {
        
        print("will draw cymbal")
        
        let circle = makeNode(named: "circle")
        
        //Size
        let newSize = 40
        circle.size = CGSize(width: newSize, height: newSize)
        
        //Position
        let heightAdjust = circle.size.height / 2
        let widthAdjust = circle.size.width / 2
        
        circle.position = CGPoint(x: (size.width * 0.1 ) + widthAdjust, y:(size.height * 0.1 ) + heightAdjust + CGFloat.random(in: -5...5))
        
        //Color
        circle.color = colorPalette.colors.randomElement()!
        circle.colorBlendFactor = 1
        circle.blendMode = SKBlendMode.screen
        
        run(SKAction.wait(forDuration: convertToTempo(delay))) {
            self.addChild(circle)
            circle.run(SKAction.fadeOut(withDuration: self.convertToTempo(lifespan))) {
                circle.removeFromParent()
            }
        }
    }
    
    private func convertToTempo(_ delay: Double) -> Double {
        return delay * 60 / self.tempo
    }
}
