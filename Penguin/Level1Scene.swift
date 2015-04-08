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
        
        
        let levelStuff = SKNode.unarchiveFromFile("Level1")! as SKNode
        //self.scene?.scaleMode = SKSceneScaleMode.Fill
        
        var penguinIndex = 0
        var goalIndex = 0
        var F1Index = 0
        var F2Index = 0
        var F3Index = 0
        var pufferIndex = 0
        for index in 0...levelStuff.children.count - 1{
            if(levelStuff.children[index].name == "Penguin"){
                penguinIndex = index
            }
            if(levelStuff.children[index].name == "goal"){
                goalIndex = index
            }
            if(levelStuff.children[index].name == "fish1"){
                F1Index = index
            }
            if(levelStuff.children[index].name == "fish2"){
                F2Index = index
            }
            if(levelStuff.children[index].name == "fish3"){
                F3Index = index
            }
            if(levelStuff.children[index].name == "pufferFish"){
                pufferIndex = index
            }
        }
        let penguin = levelStuff.children[penguinIndex] as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
        let pulseUp = SKAction.scaleTo(0.1, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.12, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        let goal = levelStuff.children[goalIndex] as SKSpriteNode
        goal.physicsBody?.categoryBitMask = collision.goalCategory
        goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        let F1 = levelStuff.children[F1Index] as SKSpriteNode
        F1.physicsBody?.categoryBitMask = collision.fishCategory
        F1.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F1.runAction(repeatPulse)
        
        let F2 = levelStuff.children[F2Index] as SKSpriteNode
        F1.physicsBody?.categoryBitMask = collision.fishCategory
        F1.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F2.runAction(repeatPulse)
        
        let F3 = levelStuff.children[F3Index] as SKSpriteNode
        F1.physicsBody?.categoryBitMask = collision.fishCategory
        F1.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F3.runAction(repeatPulse)
        
        let PufferFish = levelStuff.children[pufferIndex] as SKSpriteNode
        let moveUp = SKAction.moveBy(CGVectorMake(0, 50), duration: 1.5)
        let moveDown = SKAction.moveBy(CGVectorMake(0, -50), duration: 1.5)
        let upDown = SKAction.sequence([moveUp, moveDown])
        let repeatMove = SKAction.repeatActionForever(upDown)
        
        PufferFish.runAction(repeatMove)

        self.addChild(levelStuff)
        
        
    //eventually this will look like:
        //call goal constructor with location  --  RMC - create goal class!!
        
        //populate list of iceberg coords, sizes
        //loop over list, adding icebergs
        
        //populate list of water coords, sizes
        //loop over list, adding waters
        
        //powerups add
    }
}