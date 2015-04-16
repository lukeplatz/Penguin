//
//  Level2Scene.swift
//  Penguin
//
//  Created by Jacob Gerstler on 3/26/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import Foundation
//
//  Level1Scene.swift
//  Penguin
//
//  Created by Jacob Gerstler on 3/26/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//


//
//let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
//blur.frame = frame
//self.view?.addSubview(blur)

import SpriteKit
import CoreMotion
import UIKit

class LevelBScene: PlayScene{
    
    override func retryLevel() {
        var levelStuff = LevelBScene.unarchiveFromFile("LevelB")! as LevelBScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func nextLevel() {
                var levelStuff = LevelAScene.unarchiveFromFile("LevelA")! as LevelAScene
                levelStuff.scaleMode = .ResizeFill
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func stopActions(){
        //stop all actions
    }
    
    override func startActions(){
        //Start all actions
    }
    
    override func setupMap(){
        level = 4
        
        let pulseUp = SKAction.scaleTo(0.95, duration: 0.5)
        let pulseDown = SKAction.scaleTo(1.05, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        
        //apply action to all fish
        let fish = childNodeWithName("fish1") as SKSpriteNode
        fish.physicsBody?.categoryBitMask = collision.fishCategory
        fish.physicsBody?.collisionBitMask = 0 // dont collide with anything
        fish.runAction(repeatPulse)
        
        let fish2 = childNodeWithName("fish2") as SKSpriteNode
        fish2.physicsBody?.categoryBitMask = collision.fishCategory
        fish2.physicsBody?.collisionBitMask = 0 // dont collide with anything
        fish2.runAction(repeatPulse)
        
        let fish3 = childNodeWithName("fish3") as SKSpriteNode
        fish3.physicsBody?.categoryBitMask = collision.fishCategory
        fish3.physicsBody?.collisionBitMask = 0 // dont collide with anything
        fish3.runAction(repeatPulse)

        
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // Enable Colliding
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
        let goal = childNodeWithName("goal") as SKSpriteNode
        goal.physicsBody?.categoryBitMask = collision.goalCategory
        goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        
        let PufferFish = childNodeWithName("pufferFish") as SKSpriteNode
        PufferFish.physicsBody?.categoryBitMask = collision.WaterCategory
        PufferFish.physicsBody?.collisionBitMask = 1 // allow contact
        PufferFish.zPosition = 2
        let moveleft = SKAction.moveBy(CGVectorMake(-(self.size.width / 2), 0), duration: 1.0)
        let moveright = SKAction.moveBy(CGVectorMake((self.size.width / 2), 0), duration: 1.0)
        let leftRight = SKAction.sequence([moveleft, moveright, moveright, moveleft])
        let repeatMove = SKAction.repeatActionForever(leftRight)
        
        PufferFish.runAction(repeatMove)
    }
}