//
//  LevelKScene.swift
//  Penguin
//
//  Created by Riley Chapin on 4/16/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit

class LevelOScene: PlayScene{
    
    override func retryLevel() {
        motionManager.stopAccelerometerUpdates()
        var levelStuff = LevelOScene.unarchiveFromFile("LevelO")! as LevelOScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    //        override func nextLevel() {
    //            motionManager.stopAccelerometerUpdates()
    //            var levelStuff = LevelJScene.unarchiveFromFile("LevelJ")! as LevelJScene
    //            levelStuff.scaleMode = .ResizeFill
    //            let skView = self.view! as SKView
    //            skView.ignoresSiblingOrder = true
    //            skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    //        }
    
    var leverFlipped = Bool()
    var goalSide = Bool()
    var doorEnter = SKSpriteNode()
    var doorExit = SKSpriteNode()
    
    override func setupMap(){
        level = 15
        leverFlipped = false
        goalSide = false
        
        
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory | collision.doorCategory
        
        let pulseUp = SKAction.scaleTo(0.95, duration: 0.5)
        let pulseDown = SKAction.scaleTo(1.05, duration: 0.5)
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
    }
}
