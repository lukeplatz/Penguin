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
    let instructions1 = SKLabelNode(fontNamed: "Arial")
    let instructions2 = SKLabelNode(fontNamed: "Arial")
    let HUDbar = SKSpriteNode(imageNamed: "HudBar")
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    let speedLabel = SKLabelNode(fontNamed: "Arial")
    
    var PlayerScore = 0
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    var motionManager = CMMotionManager()
    
    var calibrateX = CGFloat(0)
    var calibrateY = CGFloat(0)
    var needToCalibrate = true
    
    var maxDistance = CGFloat(0)
    var scrollSpeed = 1
    
    var blockMaxX = CGFloat(0)
    var origShortBlockPositionY = CGFloat(0)
    var origLongBlockPositionY = CGFloat(0)
    var shortCounted = false
    var longCounted = false
    
    enum BodyType:UInt32 {
        case penguin = 1
        case bottom = 2
    }
    
    var Pause = false
    var gameO = false
    var presentInstructions = true
    var forwardMovement = CGFloat(0.0)
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0, green: 250, blue: 154, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, 2)
        self.physicsWorld.contactDelegate = self
        
        // 1 Create a physics body that borders the screen
        var borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        var bottom = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(CGRectGetWidth(self.frame), 10))
        bottom.position.x = CGRectGetMidX(self.frame)
        bottom.position.y = CGRectGetMinY(self.frame)
        bottom.physicsBody = SKPhysicsBody(rectangleOfSize: bottom.size)
        bottom.physicsBody?.dynamic = false
        bottom.physicsBody?.collisionBitMask = 1
        bottom.physicsBody?.categoryBitMask = BodyType.bottom.rawValue
        bottom.physicsBody?.contactTestBitMask = BodyType.penguin.rawValue | BodyType.bottom.rawValue
        
        let moveUp = SKAction.moveBy(CGVectorMake(0, 5), duration: 1.0)
        let moveDown = SKAction.moveBy(CGVectorMake(0, -5), duration: 1.0)
        let pulse = SKAction.sequence([moveUp, moveDown])
        let repeatMove = SKAction.repeatActionForever(pulse)
        
        bottom.runAction(repeatMove)
        
        self.addChild(bottom)
        
        self.gameOver.text = "Game Over"
        self.gameOver.position.x = CGRectGetMidX(self.frame)
        self.gameOver.position.y = CGRectGetMidY(self.frame)
        self.gameOver.fontColor = UIColor.orangeColor()
        self.gameOver.fontSize = 20
        
        self.instructions1.text = "Press and Hold to slide backwards"
        self.instructions1.position.x = CGRectGetMidX(self.frame)
        self.instructions1.position.y = CGRectGetMidY(self.frame) + 10
        self.instructions1.fontColor = UIColor.orangeColor()
        self.instructions1.fontSize = 20
        
        self.instructions2.text = "Release to slide forwards!"
        self.instructions2.position.x = CGRectGetMidX(self.frame)
        self.instructions2.position.y = CGRectGetMidY(self.frame) - 10
        self.instructions2.fontColor = UIColor.orangeColor()
        self.instructions2.fontSize = 20
        
        self.addChild(instructions1)
        self.addChild(instructions2)
        
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
                self.physicsWorld.gravity = CGVectorMake((CGFloat(data.acceleration.x) - self.calibrateX) * 30 * 9.8, self.forwardMovement)
            })
        }
        let xPosition1 = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
        self.shortBlock.anchorPoint = CGPointMake(0.5, 0.5)
        self.shortBlock.position = CGPointMake(xPosition1, CGRectGetMaxY(self.frame))
        self.shortBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(50)))
        self.shortBlock.physicsBody?.dynamic = false
        self.origShortBlockPositionY = self.shortBlock.position.y
        
        let xPosition2 = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
        self.longBlock.anchorPoint = CGPointMake(0.5, 0.5)
        self.longBlock.position = CGPointMake(xPosition2, CGRectGetMaxY(self.frame) + (CGRectGetHeight(self.frame) / 2))
        self.longBlock.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(CGFloat(50), CGFloat(100)))
        self.longBlock.physicsBody?.dynamic = false
        self.longBlock.zRotation = CGFloat(M_PI / 2)
        self.origLongBlockPositionY = self.longBlock.position.y
        
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
            }else if self.nodeAtPoint(location) == self.pauseButton && self.gameO == false{
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
            }else{
                if(self.presentInstructions == true){
                    instructions1.removeFromParent()
                    instructions2.removeFromParent()
                }
                self.forwardMovement = -3.0
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            self.forwardMovement = 3.0
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
        
        self.speedLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.frame) / 8, self.backButton.position.y - self.backButton.size.height)
        self.speedLabel.zPosition = 2
        self.speedLabel.fontColor = UIColor.orangeColor()
        self.speedLabel.text = "Speed: 1"
        self.speedLabel.fontSize = 15
        
        
        self.addChild(speedLabel)
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
            self.longBlock.position.y = self.origShortBlockPositionY
            self.longCounted = false
        }
        
        if self.shortBlock.position.y <= CGRectGetMinY(self.frame) - self.shortBlock.size.height / 2 {
            let xPosition = random(min: CGRectGetMinX(self.frame), max: CGRectGetMaxX(self.frame))
            self.shortBlock.position.x = xPosition
            self.shortBlock.position.y = self.origShortBlockPositionY
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
                self.speedLabel.text = "Speed: \(self.scrollSpeed)"
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
            self.gameO = true
            self.Pause = true
        default:
            return
        }
    }
}
