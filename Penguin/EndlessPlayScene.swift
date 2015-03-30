//
//  EndlessPlayScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/29/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
import CoreMotion

class EndlessPlayScene : SKScene, SKPhysicsContactDelegate {
    
    let longBlock = SKSpriteNode(imageNamed: "Tallblock")
    let shortBlock = SKSpriteNode(imageNamed: "Shortblock")
    let penguin = SKSpriteNode(imageNamed: "Penguin")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let pausedImage = SKSpriteNode(imageNamed: "Paused")
    let score = SKLabelNode(fontNamed: "Arial")
    let gameOver = SKLabelNode(fontNamed: "Arial")
    let HUDbar = SKSpriteNode(imageNamed: "HudBar")
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    
    var PlayerScore = 0
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    var motionManager = CMMotionManager()
    
    var calibrateX = CGFloat(0)
    var calibrateY = CGFloat(0)
    var needToCalibrate = true
    
    var maxDistance = CGFloat(0)
    var scrollSpeed = 2
    
    var blockMaxX = CGFloat(0)
    var origBlockPositionY = CGFloat(0)
    var shortCounted = false
    var longCounted = false
    
    enum BodyType:UInt32 {
        case penguin = 1
        case bottom = 2
    }
    
    var Pause = false
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0, green: 250, blue: 154, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        // 1 Create a physics body that borders the screen
        var borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        var bottom = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(CGRectGetWidth(self.frame), 1))
        bottom.position.x = CGRectGetMidX(self.frame)
        bottom.position.y = CGRectGetMinY(self.frame) + 1
        bottom.physicsBody = SKPhysicsBody(rectangleOfSize: bottom.size)
        bottom.physicsBody?.dynamic = false
        bottom.physicsBody?.collisionBitMask = 1
        bottom.physicsBody?.categoryBitMask = BodyType.bottom.rawValue
        bottom.physicsBody?.contactTestBitMask = BodyType.penguin.rawValue | BodyType.bottom.rawValue
        
        self.addChild(bottom)
        
        self.gameOver.text = "Game Over"
        self.gameOver.position.x = CGRectGetMidX(self.frame)
        self.gameOver.position.y = CGRectGetMidY(self.frame)
        self.gameOver.fontColor = UIColor.orangeColor()
        self.gameOver.fontSize = 20
        
        
        maxDistance = CGRectGetMaxY(self.frame) - CGRectGetMidY(self.frame)
        
        //Sets up Penguin Image
        setupPenguin()
        
        
        //Sets up BackButton, Score, PauseButton
        setupHUD()
        
        if (self.motionManager.accelerometerAvailable){
            //Set up and manage motion manager to get accelerometer data
            self.motionManager.accelerometerUpdateInterval = (1/40)
            self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
                data, error in
                if(self.needToCalibrate){
                    self.calibrateX = CGFloat(data.acceleration.x)
                    self.needToCalibrate = false
                    println("calibrated: \(self.calibrateX)")
                }
                self.physicsWorld.gravity = CGVectorMake((CGFloat(data.acceleration.x) - self.calibrateX) * 20 * 9.8, 0)
            })
        }
        let xPosition1 = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
        self.shortBlock.position = CGPointMake(xPosition1, CGRectGetMaxY(self.frame) + self.shortBlock.size.height / 2)
        self.shortBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.shortBlock.physicsBody?.dynamic = false
        
        let xPosition2 = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
        self.longBlock.position = CGPointMake(xPosition2, self.shortBlock.position.y + CGFloat(maxDistance))
        self.longBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(100)))
        self.longBlock.physicsBody?.dynamic = false
        origBlockPositionY = self.longBlock.position.y
        
        self.addChild(shortBlock)
        self.addChild(longBlock)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton{
                motionManager.stopAccelerometerUpdates()
                self.needToCalibrate = true
                
                //Sets HighScore
                setHighScore()
                
                var mainMenuScene = MainMenuScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                mainMenuScene.scaleMode = .ResizeFill
                mainMenuScene.size = skView.bounds.size
                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
            }else if self.nodeAtPoint(location) == self.pauseButton{
                if(self.Pause == true){
                    //Resume
                    self.pausedImage.removeFromParent()
                    self.Pause = false
                    self.physicsWorld.speed = 1
                }else{
                    //Pause
                    self.addChild(pausedImage)
                    self.physicsWorld.speed = 0
                    self.Pause = true
                }
            }
        }
    }
    
    func setHighScore(){
        NSUserDefaults.standardUserDefaults().integerForKey("highscoreEndless")
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if PlayerScore > NSUserDefaults.standardUserDefaults().integerForKey("highscoreEndless") {
            NSUserDefaults.standardUserDefaults().setInteger(PlayerScore, forKey: "highscoreEndless")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        var x = NSUserDefaults.standardUserDefaults().integerForKey("highscoreEndless")
        println(x)
    }
    
    func setupPenguin(){
        self.penguin.anchorPoint = CGPointMake(0.5, 0.5)
        self.penguin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 100)
        self.penguin.physicsBody = SKPhysicsBody(circleOfRadius: penguin.size.width / 2)
        self.penguin.physicsBody?.mass = 15
        self.penguin.physicsBody?.friction = 0.5
        self.penguin.physicsBody?.restitution = 0.7
        self.penguin.physicsBody?.linearDamping = 5
        self.penguin.physicsBody?.allowsRotation = true
        self.penguin.physicsBody?.usesPreciseCollisionDetection = true
        self.penguin.physicsBody?.categoryBitMask = BodyType.penguin.rawValue
        self.penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        self.penguin.physicsBody?.contactTestBitMask = BodyType.penguin.rawValue | BodyType.bottom.rawValue
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

        
        //Paused image
        self.pausedImage.anchorPoint = CGPointMake(0.5, 0.5)
        self.pausedImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.pausedImage.zPosition = 1
        
        
        self.addChild(HUDbar)
        self.addChild(backButton)
        self.addChild(score)
        self.addChild(pauseButton)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.Pause == false){
            blockRunner()
        }
    }
    
    func blockRunner() {
        if longBlock.position.y <= CGRectGetMinY(self.frame) - self.longBlock.size.height / 2 {
            let xPosition = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
            self.longBlock.position.x = xPosition
            self.longBlock.position.y = self.origBlockPositionY
            self.longCounted = false
        }
        
        if self.shortBlock.position.y <= CGRectGetMinY(self.frame) - self.shortBlock.size.height / 2 {
            let xPosition = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
            self.shortBlock.position.x = xPosition
            self.shortBlock.position.y = self.origBlockPositionY
            self.shortCounted = false
        }
        if (self.shortBlock.position.y < self.penguin.position.y || self.longBlock.position.y < self.penguin.position.y) && self.shortCounted == false && self.longCounted == false{
            if(self.shortBlock.position.y < self.penguin.position.y){
                self.shortCounted = true
            }
            if(self.longBlock.position.y < self.penguin.position.y){
                self.longCounted = true
            }
            self.PlayerScore++
            self.score.text = "Score: \(self.PlayerScore)"
            if ((self.PlayerScore % 5) == 0) {
                self.scrollSpeed++
            }
        }
        longBlock.position.y -= CGFloat(self.scrollSpeed)
        shortBlock.position.y -= CGFloat(self.scrollSpeed)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        //this gets called automatically when two objects begin contact with each other
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case BodyType.penguin.rawValue | BodyType.bottom.rawValue:
            self.addChild(gameOver)
            self.physicsWorld.speed = 0
            self.Pause = true
        default:
            return
        }
    }
}
