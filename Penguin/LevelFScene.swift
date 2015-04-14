//
//  LevelEScene.swift
//  Penguin
//
//  Created by Riley Chapin on 4/8/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit

class LevelFScene: PlayScene{
    
    override func retryLevel() {
        var levelStuff = LevelFScene.unarchiveFromFile("LevelF")! as LevelFScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    //    override func nextLevel() {
    //        var levelStuff = LevelEScene.unarchiveFromFile("LevelE")! as LevelEScene
    //        levelStuff.scaleMode = .ResizeFill
    //        let skView = self.view! as SKView
    //        skView.ignoresSiblingOrder = true
    //        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    //    }
    
    override func setupMap(){
        level = 6
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
        
        let bridgePowerup = childNodeWithName("bridgePowerup")
        bridgePowerup?.physicsBody?.categoryBitMask = collision.powerUpCategory
        bridgePowerup?.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
    }
    
    override func addBridges() {
        
        let water1 = childNodeWithName("WtoRemove1") as SKSpriteNode
        water1.physicsBody?.categoryBitMask = collision.none
        water1.physicsBody?.collisionBitMask = 0
        water1.removeFromParent()
        
        let water2 = childNodeWithName("WtoRemove2") as SKSpriteNode
        water2.physicsBody?.categoryBitMask = collision.none
        water2.physicsBody?.collisionBitMask = 0
        water2.removeFromParent()
        
        let bridge1 = SKSpriteNode(imageNamed: "boxAlt")
        bridge1.position = water1.position
        bridge1.zPosition = 2
        bridge1.physicsBody?.categoryBitMask = collision.bridgeCategory
        
        let bridge2 = SKSpriteNode(imageNamed: "boxAlt")
        bridge2.position = water2.position
        bridge2.zPosition = 2
        bridge2.physicsBody?.categoryBitMask = collision.bridgeCategory
        
        self.addChild(bridge1)
        self.addChild(bridge2)
        
    }
}