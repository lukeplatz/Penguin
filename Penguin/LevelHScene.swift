//
//  LevelHScene.swift
//  Penguin
//
//  Created by Riley Chapin on 4/15/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit

class LevelHScene: PlayScene{
    
    override func retryLevel() {
        motionManager.stopAccelerometerUpdates()
        var levelStuff = LevelHScene.unarchiveFromFile("LevelH")! as LevelHScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func nextLevel() {
        motionManager.stopAccelerometerUpdates()
        var levelStuff = LevelIScene.unarchiveFromFile("LevelI")! as LevelIScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func setupMap(){
        level = 8
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
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
        
        let moveleft = SKAction.moveBy(CGVectorMake(-(self.size.width / 3), 0), duration: 1.0)
        let moveright = SKAction.moveBy(CGVectorMake((self.size.width / 3), 0), duration: 1.0)
        let leftRight = SKAction.sequence([moveleft, moveright, moveright, moveleft])
        let repeatLRMove = SKAction.repeatActionForever(leftRight)
        
        let moveup = SKAction.moveBy(CGVectorMake(0,(self.size.height / 2)), duration: 1.0)
        let movedown = SKAction.moveBy(CGVectorMake(0,-(self.size.height / 2)), duration: 1.0)
        let upDown = SKAction.sequence([moveup, movedown, movedown, moveup])
        let repeatUDMove = SKAction.repeatActionForever(upDown)
        
        let puffer1 = childNodeWithName("pf1") as SKSpriteNode
        puffer1.physicsBody?.categoryBitMask = collision.WaterCategory
        puffer1.physicsBody?.collisionBitMask = 1 // allow contact
        puffer1.runAction(repeatLRMove)
        
        let puffer2 = childNodeWithName("pf2") as SKSpriteNode
        puffer2.physicsBody?.categoryBitMask = collision.WaterCategory
        puffer2.physicsBody?.collisionBitMask = 1 // allow contact
        puffer2.runAction(repeatUDMove)
        
        let puffer3 = childNodeWithName("pf3") as SKSpriteNode
        puffer3.physicsBody?.categoryBitMask = collision.WaterCategory
        puffer3.physicsBody?.collisionBitMask = 1 // allow contact
        puffer3.runAction(repeatUDMove)
    }
}