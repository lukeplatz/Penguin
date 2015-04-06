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
        self.goal.anchorPoint = CGPointMake(0.5, 0.5)
        self.goal.xScale = (50/self.goal.size.width)
        self.goal.yScale = (50/self.goal.size.height)
        self.goal.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.goal.size.width / 2), CGRectGetMaxY(self.frame) - (self.goal.size.height / 2) - statusbarHeight * 11)
        self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.goal.physicsBody?.dynamic = false
        self.goal.physicsBody?.categoryBitMask = collision.goalCategory
        self.goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        self.addChild(goal)
        
        let icebergTest = Iceberg(position: CGPointMake(CGRectGetMaxX(self.frame) * 0.8, CGRectGetMaxY(self.frame)  - statusbarHeight * 10), size:CGSizeMake(CGFloat(50), CGFloat(50)))
        self.addChild(icebergTest.sprite)
        
        let waterTest = Water(position: CGPointMake(CGRectGetMaxX(self.frame)*0.1,CGRectGetMaxY(self.frame)*0.1), size: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.addChild(waterTest.sprite)
        
        
    //eventually this will look like:
        //call goal constructor with location  --  RMC - create goal class!!
        
        //populate list of iceberg coords, sizes
        //loop over list, adding icebergs
        
        //populate list of water coords, sizes
        //loop over list, adding waters
        
        //powerups add
    }
}