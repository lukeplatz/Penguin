//
//  PlayScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
import CoreMotion

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    var destX:CGFloat = 0
    var destY:CGFloat = 0
    
    var calibrateX = CGFloat(0)
    var calibrateY = CGFloat(0)
    var needToCalibrate = true
    
    let penguin = SKSpriteNode(imageNamed: "Penguin")
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let goal = SKSpriteNode(imageNamed: "Spaceship")
    let longBlock = SKSpriteNode(imageNamed: "Tallblock")
    let shortBlock = SKSpriteNode(imageNamed: "Shortblock")
    let winner = SKSpriteNode(imageNamed: "Winner")
    let pausedImage = SKSpriteNode(imageNamed: "Paused")
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    enum BodyType:UInt32 {
        case penguin = 1
        case goal = 2
    }
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0, green: 250, blue: 154, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(9.8, 9.8)
        self.physicsWorld.contactDelegate = self
        
        // 1 Create a physics body that borders the screen
        var borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        //Sets up Penguin Image
        self.penguin.anchorPoint = CGPointMake(0.5, 0.5)
        self.penguin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.penguin.physicsBody = SKPhysicsBody(circleOfRadius: penguin.size.width / 2)
        self.penguin.physicsBody?.mass = 15
        self.penguin.physicsBody?.friction = 0.5
        self.penguin.physicsBody?.restitution = 0.7
        self.penguin.physicsBody?.linearDamping = 5
        self.penguin.physicsBody?.allowsRotation = true
        self.penguin.physicsBody?.usesPreciseCollisionDetection = true
        self.penguin.physicsBody?.categoryBitMask = BodyType.penguin.rawValue
        self.penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        self.penguin.physicsBody?.contactTestBitMask = BodyType.penguin.rawValue | BodyType.goal.rawValue
        
        
        //Sets up Back Image (playButton)
        self.playButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.playButton.xScale = (100/self.playButton.size.width)
        self.playButton.yScale = (50/self.playButton.size.height)
        self.playButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.playButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.playButton.size.height / 2) - statusbarHeight)
        self.playButton.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(100), CGFloat(50)))
        self.playButton.physicsBody?.dynamic = false
        
        //Sets up goal
        self.goal.anchorPoint = CGPointMake(0.5, 0.5)
        self.goal.xScale = (50/self.goal.size.width)
        self.goal.yScale = (50/self.goal.size.height)
        self.goal.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.goal.size.width / 2), CGRectGetMaxY(self.frame) - (self.goal.size.height / 2) - statusbarHeight * 5)
        self.goal.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.goal.physicsBody?.dynamic = false
        self.goal.physicsBody?.categoryBitMask = BodyType.goal.rawValue
        self.goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        //Sets up longblock
        self.longBlock.anchorPoint = CGPointMake(0.5, 0.5)
        let constraint = SKConstraint.zRotation(SKRange(constantValue: 1.575))
        self.longBlock.constraints = [constraint]
        self.longBlock.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.longBlock.size.width), CGRectGetMaxY(self.frame) - (self.longBlock.size.height / 2) - statusbarHeight * 5 - self.longBlock.size.width / 2)
        self.longBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(self.longBlock.size.width), CGFloat(self.longBlock.size.height)))
        self.longBlock.physicsBody?.dynamic = false
        
        
        self.shortBlock.anchorPoint = CGPointMake(0.5, 0.5)
        self.shortBlock.xScale = (50/self.goal.size.width)
        self.shortBlock.yScale = (50/self.goal.size.height)
        self.shortBlock.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.shortBlock.size.width * 1.5), CGRectGetMaxY(self.frame) - (self.shortBlock.size.height / 2) - statusbarHeight * 5)
        self.shortBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.shortBlock.physicsBody?.dynamic = false
        
        
        self.winner.anchorPoint = CGPointMake(0.5, 0.5)
        self.winner.xScale = (200/self.winner.size.width)
        self.winner.yScale = (200/self.winner.size.height)
        self.winner.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.pausedImage.anchorPoint = CGPointMake(0.5, 0.5)
        self.pausedImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        
        //Add all children images to self
        self.addChild(penguin)
        self.addChild(playButton)
        self.addChild(goal)
        self.addChild(longBlock)
        self.addChild(shortBlock)
        
        if (self.motionManager.accelerometerAvailable){
            //Set up and manage motion manager to get accelerometer data
            self.motionManager.accelerometerUpdateInterval = (1/40)
            self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
                data, error in
                if(self.needToCalibrate){
                    self.calibrateX = CGFloat(data.acceleration.x)
                    self.calibrateY = CGFloat(data.acceleration.y)
                    self.needToCalibrate = false
                    println("calibrated: \(self.calibrateX), \(self.calibrateY)")
                }
                self.physicsWorld.gravity = CGVectorMake((CGFloat(data.acceleration.x) - self.calibrateX) * 20 * 9.8, (CGFloat(data.acceleration.y) - self.calibrateY) * 20 * 9.8)
            })
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton{
                motionManager.stopAccelerometerUpdates()
                self.needToCalibrate = true
                var mainMenuScene = MainMenuScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                mainMenuScene.scaleMode = .ResizeFill
                mainMenuScene.size = skView.bounds.size
                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 1.0))
            }else{
                if(self.physicsWorld.speed == 0){
                    //Resume
                    self.pausedImage.removeFromParent()
                    self.physicsWorld.speed = 1
                }else{
                    //Pause
                    self.addChild(pausedImage)
                    self.physicsWorld.speed = 0
                }
            }
        }
    }
    
    
    
    override func update(currentTime: NSTimeInterval) {
        //called every frame
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //this gets called automatically when two objects begin contact with each other
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            
        case BodyType.penguin.rawValue | BodyType.goal.rawValue:
            //println("contact made")
            self.addChild(winner)
            
        default:
            return
            
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        //this gets called automatically when two objects end contact with each other
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
        case BodyType.penguin.rawValue | BodyType.goal.rawValue:
            //either the contactMask was the bro type or the ground type
            //println("contact ended")
            self.winner.removeFromParent()
            
        default:
            return
            
        }
        
    }
    
    
}
