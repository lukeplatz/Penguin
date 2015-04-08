//
//  Level1Scene.swift
//  Penguin
//
//  Created by Jacob Gerstler on 3/26/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
//import CoreMotion

class LevelAScene: PlayScene{
    
    override func retryLevel() {
        var levelStuff = LevelAScene.unarchiveFromFile("LevelA")! as LevelAScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func nextLevel() {
        var levelStuff = Level2Scene.unarchiveFromFile("Level2")! as Level2Scene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func setupMap(){
        level = 1
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
        let pulseUp = SKAction.scaleTo(0.1, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.12, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        let goal = childNodeWithName("goal") as SKSpriteNode
        goal.physicsBody?.categoryBitMask = collision.goalCategory
        goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        let F1 = childNodeWithName("fish1") as SKSpriteNode
        F1.physicsBody?.categoryBitMask = collision.fishCategory
        F1.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F1.runAction(repeatPulse)
        
        let F2 = childNodeWithName("fish2") as SKSpriteNode
        F2.physicsBody?.categoryBitMask = collision.fishCategory
        F2.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F2.runAction(repeatPulse)
        
        let F3 = childNodeWithName("fish3") as SKSpriteNode
        F3.physicsBody?.categoryBitMask = collision.fishCategory
        F3.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F3.runAction(repeatPulse)
        
        let PufferFish = childNodeWithName("pufferFish") as SKSpriteNode
        PufferFish.physicsBody?.categoryBitMask = collision.WaterCategory
        PufferFish.physicsBody?.collisionBitMask = 1 // allow contact
        let moveUp = SKAction.moveBy(CGVectorMake(0, 50), duration: 1.5)
        let moveDown = SKAction.moveBy(CGVectorMake(0, -50), duration: 1.5)
        let upDown = SKAction.sequence([moveUp, moveDown])
        let repeatMove = SKAction.repeatActionForever(upDown)
        
        PufferFish.runAction(repeatMove)
        
    }
}