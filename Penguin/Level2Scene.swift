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
    let longBlock = SKSpriteNode(imageNamed: "Tallblock")
    let shortBlock = SKSpriteNode(imageNamed: "Shortblock")
    
    override func setupMap(){
        level = 2
//        self.goal.anchorPoint = CGPointMake(0.5, 0.5)
//        self.goal.xScale = (50/self.goal.size.width)
//        self.goal.yScale = (50/self.goal.size.height)
//        self.goal.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.goal.size.width / 2), CGRectGetMaxY(self.frame) - (self.goal.size.height / 2) - statusbarHeight * 11)
//        self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
//        self.goal.physicsBody?.dynamic = false
//        self.goal.physicsBody?.categoryBitMask = collision.goalCategory
//        self.goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
//        
//        //Sets up longblock
//        self.longBlock.anchorPoint = CGPointMake(0.5, 0.5)
//        let constraint = SKConstraint.zRotation(SKRange(constantValue: 1.575))
//        self.longBlock.constraints = [constraint]
//        self.longBlock.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.longBlock.size.width), CGRectGetMaxY(self.frame) - (self.longBlock.size.height / 2) - statusbarHeight * 10 - self.longBlock.size.width / 2)
//        self.longBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(self.longBlock.size.width), CGFloat(self.longBlock.size.height)))
//        self.longBlock.physicsBody?.dynamic = false
//        
//        //Sets up shortblock
//        self.shortBlock.anchorPoint = CGPointMake(0.5, 0.5)
//        self.shortBlock.xScale = (50/self.goal.size.width)
//        self.shortBlock.yScale = (50/self.goal.size.height)
//        self.shortBlock.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.shortBlock.size.width * 1.5), CGRectGetMaxY(self.frame) - (self.shortBlock.size.height / 2) - statusbarHeight * 10)
//        self.shortBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
//        self.shortBlock.physicsBody?.dynamic = false
//        
//        
//        self.addChild(penguin)
//        self.addChild(goal)
//        self.addChild(longBlock)
//        self.addChild(shortBlock)
        
        println("yay")
        let levelStuff = SKScene.unarchiveFromFile("Level2")!
        
        //let scene = PlayScene.unarchiveFromFile("Level2")! as Level2Scene
        
        //levelStuff.scene?.scaleMode = SKSceneScaleMode.AspectFit
        //self.scene?.scaleMode = SKSceneScaleMode.AspectFit
        
        let pulseUp = SKAction.scaleTo(0.1, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.12, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
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
            if(levelStuff.children[index].name == "fish"){
                let fish = levelStuff.children[index] as SKSpriteNode
                fish.physicsBody?.categoryBitMask = collision.fishCategory
                fish.physicsBody?.collisionBitMask = 0 // dont collide with anything
                fish.runAction(repeatPulse)
            }
            if(levelStuff.children[index].name == "pufferFish"){
                pufferIndex = index
            }
        }
        let penguin = levelStuff.children[penguinIndex] as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
        let goal = levelStuff.children[goalIndex] as SKSpriteNode
        goal.physicsBody?.categoryBitMask = collision.goalCategory
        goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        

        let PufferFish = levelStuff.children[pufferIndex] as SKSpriteNode
        let moveUp = SKAction.moveBy(CGVectorMake(0, 50), duration: 1.5)
        let moveDown = SKAction.moveBy(CGVectorMake(0, -50), duration: 1.5)
        let upDown = SKAction.sequence([moveUp, moveDown])
        let repeatMove = SKAction.repeatActionForever(upDown)
        
        PufferFish.runAction(repeatMove)
        
        //self.addChild(levelStuff)

        
        
    }
}