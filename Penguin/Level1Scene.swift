//
//  Level1Scene.swift
//  Penguin
//
//  Created by Jacob Gerstler on 3/26/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
//import CoreMotion

class Level1Scene: PlayScene{
    
    override func retryLevel() {
        var levelStuff = Level1Scene.unarchiveFromFile("Level1")! as Level1Scene
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
//        self.goal.anchorPoint = CGPointMake(0.5, 0.5)
//        self.goal.xScale = (50/self.goal.size.width)
//        self.goal.yScale = (50/self.goal.size.height)
//        self.goal.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.goal.size.width / 2), CGRectGetMaxY(self.frame) - (self.goal.size.height / 2) - statusbarHeight * 11)
//        self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
//        self.goal.physicsBody?.dynamic = false
//        self.goal.physicsBody?.categoryBitMask = collision.goalCategory
//        self.goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
//
//        self.addChild(goal)
//        
//        let icebergTest = Iceberg(position: CGPointMake(CGRectGetMaxX(self.frame) * 0.8, CGRectGetMaxY(self.frame)  - statusbarHeight * 10), size:CGSizeMake(CGFloat(50), CGFloat(50)))
//        self.addChild(icebergTest.sprite)
//        
//        let waterTest = Water(position: CGPointMake(CGRectGetMaxX(self.frame)*0.1,CGRectGetMaxY(self.frame)*0.1), size: CGSizeMake(CGFloat(50), CGFloat(50)))
//        self.addChild(waterTest.sprite)
        
        
//        let levelStuff = SKNode.unarchiveFromFile("Level1")! as SKNode
        //self.scene?.scaleMode = SKSceneScaleMode.Fill
        
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
        
        
    //eventually this will look like:
        //call goal constructor with location  --  RMC - create goal class!!
        
        //populate list of iceberg coords, sizes
        //loop over list, adding icebergs
        
        //populate list of water coords, sizes
        //loop over list, adding waters
        
        //powerups add
    }
}