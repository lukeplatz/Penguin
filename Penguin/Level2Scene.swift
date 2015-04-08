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

import SpriteKit
import CoreMotion

class Level2Scene: PlayScene{
    
    override func retryLevel() {
        var levelStuff = Level2Scene.unarchiveFromFile("Level2")! as Level2Scene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
    }
    
    override func setupMap(){
        level = 2
        
        //var levelStuff = Level2Scene.unarchiveFromFile("Level2")!
        
        let pulseUp = SKAction.scaleTo(0.25, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.15, duration: 0.5)
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
        PufferFish.zPosition = 2
        let moveleft = SKAction.moveBy(CGVectorMake(-(self.size.width / 2), 0), duration: 1.0)
        let moveright = SKAction.moveBy(CGVectorMake((self.size.width / 2), 0), duration: 1.0)
        let leftRight = SKAction.sequence([moveleft, moveright, moveright, moveleft])
        let repeatMove = SKAction.repeatActionForever(leftRight)
        
        PufferFish.runAction(repeatMove)
    }
}