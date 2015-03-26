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
    //let longBlock = SKSpriteNode(imageNamed: "Tallblock")
    let shortBlock = SKSpriteNode(imageNamed: "Shortblock")
    
    override func setupMap(){
        self.goal.anchorPoint = CGPointMake(0.5, 0.5)
        self.goal.xScale = (50/self.goal.size.width)
        self.goal.yScale = (50/self.goal.size.height)
        self.goal.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.goal.size.width / 2), CGRectGetMaxY(self.frame) - (self.goal.size.height / 2) - statusbarHeight * 11)
        self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.goal.physicsBody?.dynamic = false
        self.goal.physicsBody?.categoryBitMask = BodyType.goal.rawValue
        self.goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        //Sets up longblock
     //   self.longBlock.anchorPoint = CGPointMake(0.5, 0.5)
        let constraint = SKConstraint.zRotation(SKRange(constantValue: 1.575))
      //  self.longBlock.constraints = [constraint]
      //  self.longBlock.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.longBlock.size.width), CGRectGetMaxY(self.frame) - (self.longBlock.size.height / 2) - statusbarHeight * 10 - self.longBlock.size.width / 2)
       // self.longBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(self.longBlock.size.width), CGFloat(self.longBlock.size.height)))
       // self.longBlock.physicsBody?.dynamic = false
        
        //Sets up shortblock
        self.shortBlock.anchorPoint = CGPointMake(0.5, 0.5)
        self.shortBlock.xScale = (50/self.goal.size.width)
        self.shortBlock.yScale = (50/self.goal.size.height)
        self.shortBlock.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.shortBlock.size.width * 1.5), CGRectGetMaxY(self.frame) - (self.shortBlock.size.height / 2) - statusbarHeight * 10)
        self.shortBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.shortBlock.physicsBody?.dynamic = false
        
        self.addChild(goal)
     //   self.addChild(longBlock)
        self.addChild(shortBlock)
    }
}