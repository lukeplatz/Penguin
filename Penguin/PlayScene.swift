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
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let goal = SKSpriteNode(imageNamed: "Spaceship")
   
    let winner = SKSpriteNode(imageNamed: "Winner")
    let pausedImage = SKSpriteNode(imageNamed: "Paused")
    let score = SKLabelNode(fontNamed: "Arial")
    let HUDbar = SKSpriteNode(imageNamed: "HudBar")
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    var PlayerScore = 0
    
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
        setupPenguin()
        
        
        //Sets up BackButton, Score, PauseButton
        setupHUD()
        
        
        //Sets up Everything on map, except the Penguin
        setupMap()
        
        
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
            if self.nodeAtPoint(location) == self.backButton{
                motionManager.stopAccelerometerUpdates()
                self.needToCalibrate = true
                
                //Sets High Scores
                
                NSUserDefaults.standardUserDefaults().integerForKey("highscore")
                
                //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
                if PlayerScore > NSUserDefaults.standardUserDefaults().integerForKey("highscore") {
                    NSUserDefaults.standardUserDefaults().setInteger(PlayerScore, forKey: "highscore")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                NSUserDefaults.standardUserDefaults().integerForKey("highscore")
                
                //Done setting high scores
                
                var mainMenuScene = MainMenuScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                mainMenuScene.scaleMode = .ResizeFill
                mainMenuScene.size = skView.bounds.size
                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
            }else if self.nodeAtPoint(location) == self.pauseButton{
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
    
    
    func setupPenguin(){
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
        
        self.addChild(penguin)
    }
    
    func setupHUD(){
        //Back Image
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (50/self.backButton.size.width)
        self.backButton.yScale = (50/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        self.backButton.zPosition = 2
        
        self.HUDbar.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - self.HUDbar.size.height / 2)
        self.HUDbar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(self.HUDbar.size.width), CGFloat(self.HUDbar.size.height)))
        self.HUDbar.physicsBody?.dynamic = false
        self.HUDbar.zPosition = 1
        
        //Score
        self.PlayerScore = 0
        self.score.text = "Score: \(PlayerScore)"
        self.score.position = CGPointMake(HUDbar.position.x, backButton.position.y - backButton.size.height / 4)
        //self.score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        self.score.zPosition = 2
        
        
        self.pauseButton.xScale = (50/self.pauseButton.size.width)
        self.pauseButton.yScale = (50/self.pauseButton.size.height)
        self.pauseButton.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.pauseButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.pauseButton.size.height / 2) - statusbarHeight)
        self.pauseButton.zPosition = 2
        
        //Winner Message
        self.winner.anchorPoint = CGPointMake(0.5, 0.5)
        self.winner.xScale = (200/self.winner.size.width)
        self.winner.yScale = (200/self.winner.size.height)
        self.winner.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.winner.zPosition = 1
        
        
        //Paused image
        self.pausedImage.anchorPoint = CGPointMake(0.5, 0.5)
        self.pausedImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.pausedImage.zPosition = 1
        
        
        self.addChild(HUDbar)
        self.addChild(backButton)
        self.addChild(score)
        self.addChild(pauseButton)
    }
    
    
    func setupMap(){
        //Sets up goal
       
    }
    

    func didBeginContact(contact: SKPhysicsContact) {
        //this gets called automatically when two objects begin contact with each other
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case BodyType.penguin.rawValue | BodyType.goal.rawValue:
            //println("contact made")
            self.addChild(winner)
            PlayerScore++
            self.score.text = "Score: \(PlayerScore)"
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
