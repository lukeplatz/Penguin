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
        
        
        let levelStuff = SKNode.unarchiveFromFile("Level1")!
        var penguinIndex = 0
        
        //self.scene?.scaleMode = SKSceneScaleMode.ResizeFill
        var goalIndex = 0
        for index in 0...levelStuff.children.count - 1{
            if(levelStuff.children[index].name == "Penguin"){
                penguinIndex = index
            }
            if(levelStuff.children[index].name == "goal"){
                goalIndex = index
            }
        }
        let penguin = levelStuff.children[penguinIndex] as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
        let goal = levelStuff.children[goalIndex] as SKSpriteNode
        goal.physicsBody?.categoryBitMask = collision.goalCategory
        goal.physicsBody?.collisionBitMask = 0 // dont collide with anything

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