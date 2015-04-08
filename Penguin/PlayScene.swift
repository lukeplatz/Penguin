//
//  PlayScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
import CoreMotion


struct collision {
    static let none            : UInt32 = 0b0
    static let playerCategory  : UInt32 = 1
    static let ballCategory    : UInt32 = 0b10
    static let IcebergCategory : UInt32 = 2
    static let WaterCategory   : UInt32 = 69
    static let powerUpCategory : UInt32 = 0b10000
    static let goalCategory    : UInt32 = 100
    static let fishCategory    : UInt32 = 22

}

enum GameState {
    case Loading
    case Playing
    case Paused
    case GameWon
    case GameOver
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    let GameOverStuff = SKNode.unarchiveFromFile("GameOver")!
    let LevelWinStuff = SKNode.unarchiveFromFile("LevelWin")!
    var calibrateX = CGFloat(0)
    var calibrateY = CGFloat(0)
    var needToCalibrate = true
    var state = GameState.Loading
    var level = 1
    var PlayerScore = 0
    
    var levelWin = false
    var died = false
    var gameStarted = false
    
    let penguin = SKSpriteNode(imageNamed: "Penguin")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let goal = SKSpriteNode(imageNamed: "Spaceship")
    let winner = SKSpriteNode(imageNamed: "Winner")
    let pausedImage = SKSpriteNode(imageNamed: "Paused")
    let score = SKLabelNode(fontNamed: "Arial")
    let HUDbar = SKSpriteNode(imageNamed: "HudBar")
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    var blurNode:SKSpriteNode = SKSpriteNode()
    
    var quitButtonIndex = 0
    var retryButtonIndex = 0
    
    var nextLevelButtonIndex = 0
    
    //let gameOver = SKLabelNode(fontNamed: "Arial")
    let instructions1 = SKLabelNode(fontNamed: "Arial Bold")
    let instructions2 = SKLabelNode(fontNamed: "Arial Bold")
    
    var SPEED_MULTIPLIER = CGFloat(3)
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0, green: 250, blue: 154, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        // 1 Create a physics body that borders the screen
        var borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        self.physicsWorld.speed = 0
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
                self.physicsWorld.gravity = CGVectorMake((CGFloat(data.acceleration.x) - self.calibrateX) * self.SPEED_MULTIPLIER * 9.8, (CGFloat(data.acceleration.y) - self.calibrateY) * self.SPEED_MULTIPLIER * 9.8)
            })
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if(self.died == false && self.levelWin == false){
                if self.nodeAtPoint(location) == self.backButton{
                    motionManager.stopAccelerometerUpdates()
                    self.needToCalibrate = true
                    
                    //Sets HighScore
                    setHighScore()
                    
                    var mainMenuScene = LevelSelectScene(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    mainMenuScene.scaleMode = .ResizeFill
                    mainMenuScene.size = skView.bounds.size
                    skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                }else if self.nodeAtPoint(location) == self.pauseButton{
                    if(self.died == false && self.levelWin == false){
                        if(self.physicsWorld.speed == 0){
                            //Resume
                            self.blurNode.removeFromParent()
                            self.pausedImage.removeFromParent()
                            self.physicsWorld.speed = 1
                        }else{
                            //Pause
                            loadBlurScreen()
                            self.pauseButton.zPosition = 100
                            self.pausedImage.zPosition = 100
                            self.addChild(pausedImage)
                            self.physicsWorld.speed = 0
                        }
                    }
                }else{
                    self.instructions1.removeFromParent()
                    self.instructions2.removeFromParent()
                    self.physicsWorld.speed = 1
                    self.gameStarted = true
                    self.state = GameState.Playing
                    self.needToCalibrate = true
                }
            }
            else if(self.died == true && self.levelWin == false){
                if (self.nodeAtPoint(location) == self.GameOverStuff.children[quitButtonIndex] as NSObject){
                    var levelSelectScene = LevelSelectScene(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    levelSelectScene.scaleMode = .ResizeFill
                    levelSelectScene.size = skView.bounds.size
                    skView.presentScene(levelSelectScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))

                }
                if (self.nodeAtPoint(location) == self.GameOverStuff.children[retryButtonIndex] as NSObject){
                    retryLevel()
                    
                }
            }
            else if(self.died == false && self.levelWin == true){
                if (self.nodeAtPoint(location) == self.LevelWinStuff.children[quitButtonIndex] as NSObject){
                    var levelSelectScene = LevelSelectScene(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    levelSelectScene.scaleMode = .ResizeFill
                    levelSelectScene.size = skView.bounds.size
                    skView.presentScene(levelSelectScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                    
                    
                }
                else if(self.nodeAtPoint(location) == self.LevelWinStuff.children[retryButtonIndex] as NSObject){
                    retryLevel()
                }
                else if(self.nodeAtPoint(location) == self.LevelWinStuff.children[nextLevelButtonIndex] as NSObject){
                    nextLevel()
                }
                

            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        //called every frame
    }
    
    func nextLevel(){
        
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
        self.penguin.physicsBody?.categoryBitMask = collision.playerCategory
        self.penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        self.penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory
        
        //self.addChild(penguin)
    }
    
    func setupHUD(){
        //Back Image
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (100/self.backButton.size.width)
        self.backButton.yScale = (100/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        self.backButton.zPosition = 2
        
        self.HUDbar.yScale = 125/self.HUDbar.size.height
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
        
        
        self.pauseButton.xScale = (100/self.pauseButton.size.width)
        self.pauseButton.yScale = (100/self.pauseButton.size.height)
        self.pauseButton.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.pauseButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.pauseButton.size.height / 2) - statusbarHeight)
        self.pauseButton.zPosition = 2
        
        //Winner Message
        self.winner.anchorPoint = CGPointMake(0.5, 0.5)
        self.winner.xScale = (200/self.winner.size.width)
        self.winner.yScale = (200/self.winner.size.height)
        self.winner.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.winner.zPosition = 10
        
        
        //Paused image
        self.pausedImage.anchorPoint = CGPointMake(0.5, 0.5)
        self.pausedImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.pausedImage.zPosition = 10
        
       
        
        self.instructions1.text = "Tilt to move your Penguin"
        self.instructions1.position.x = CGRectGetMidX(self.frame)
        self.instructions1.position.y = CGRectGetMidY(self.frame) + 10
        self.instructions1.fontColor = UIColor.blackColor()
        self.instructions1.fontSize = 20
        
        self.instructions2.text = "Gather Fish, Reach Spaceship!"
        self.instructions2.position.x = CGRectGetMidX(self.frame)
        self.instructions2.position.y = CGRectGetMidY(self.frame) - 10
        self.instructions2.fontColor = UIColor.blackColor()
        self.instructions2.fontSize = 20
        
        self.addChild(instructions1)
        self.addChild(instructions2)
        
        self.addChild(HUDbar)
        self.addChild(backButton)
        self.addChild(score)
        self.addChild(pauseButton)
    }
    
    
    func setupMap(){
        //Sets up goal
       
    }
    
    func setupGameOver(){
        for index in 0...GameOverStuff.children.count - 1{
            if(GameOverStuff.children[index].name == "retryButton"){
                retryButtonIndex = index
            }
            if(GameOverStuff.children[index].name == "quitButton"){
                quitButtonIndex = index
            }
        }

    }
    
    func setupLevelWon(){
        for index in 0...GameOverStuff.children.count - 1{
            if(LevelWinStuff.children[index].name == "retryButton"){
                retryButtonIndex = index
            }
            if(LevelWinStuff.children[index].name == "quitButton"){
                quitButtonIndex = index
            }
            if(LevelWinStuff.children[index].name == "nextLevelButton"){
                nextLevelButtonIndex = index
            }
        }
    }
    
    func setHighScore(){
        NSUserDefaults.standardUserDefaults().integerForKey("highscore\(self.level)")
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if PlayerScore > NSUserDefaults.standardUserDefaults().integerForKey("highscore\(self.level)") {
            NSUserDefaults.standardUserDefaults().setInteger(PlayerScore, forKey: "highscore\(self.level)")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        var x = NSUserDefaults.standardUserDefaults().integerForKey("highscore\(self.level)")
    }
    

    func didBeginContact(contact: SKPhysicsContact) {
        //this gets called automatically when two objects begin contact with each other
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case collision.playerCategory | collision.goalCategory:
            if(self.levelWin == false){
                self.levelWin = true
                self.state = GameState.GameWon
                self.physicsWorld.speed = 0
                loadBlurScreen()
                setupLevelWon()
                self.addChild(LevelWinStuff)
                //throw up "start next level?" dialog
            }
        case collision.playerCategory | collision.WaterCategory:
            //die
            self.physicsWorld.speed = 0
            
            contact.bodyA.node?.removeAllActions()
            self.died = true
            self.state = GameState.GameOver
            //restart level / main menu dialog
            loadBlurScreen()
            GameOverStuff.removeFromParent()
            setupGameOver()
            self.addChild(GameOverStuff)
            
        case collision.playerCategory | collision.fishCategory:
            PlayerScore++;
            self.score.text = "Score: \(PlayerScore)"
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0 // So it doesnt double count it
            let move = SKAction.moveTo(self.score.position, duration: 0.2)
            contact.bodyA.node?.runAction(move)
        default:
            return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        //this gets called automatically when two objects end contact with each other
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case collision.goalCategory | collision.playerCategory:
            //either the contactMask was the bro type or the ground type
            println("contact ended")
            self.winner.removeFromParent()
        case collision.playerCategory | collision.WaterCategory:
            //die
            
            self.physicsWorld.speed = 1
            println("remove this functionality - end contact water|penguin")
        default:
            return
        }
    }
    
    
    func getBluredScreenshot() -> SKSpriteNode{
        
        //create the graphics context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.view!.frame.size.width, height: self.view!.frame.size.height), true, 1)
        
        self.view!.drawViewHierarchyInRect(self.view!.frame, afterScreenUpdates: true)
        
        // retrieve graphics context
        let context = UIGraphicsGetCurrentContext()
        
        // query image from it
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // create Core Image context
        let ciContext = CIContext(options: nil)
        // create a CIImage, think of a CIImage as image data for processing, nothing is displayed or can be displayed at this point
        let coreImage = CIImage(image: image)
        // pick the filter we want
        let filter = CIFilter(name: "CIGaussianBlur")
        // pass our image as input
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        //edit the amount of blur
        filter.setValue(3, forKey: kCIInputRadiusKey)
        
        //retrieve the processed image
        let filteredImageData = filter.valueForKey(kCIOutputImageKey) as CIImage
        // return a Quartz image from the Core Image context
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent())
        // final UIImage
        let filteredImage = UIImage(CGImage: filteredImageRef)
        
        // create a texture, pass the UIImage
        let texture = SKTexture(image: filteredImage!)
        // wrap it inside a sprite node
        let sprite = SKSpriteNode(texture:texture)
        
        // make image the position in the center
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        var scale:CGFloat = UIScreen.mainScreen().scale
        
        sprite.size.width  *= scale
        
        sprite.size.height *= scale
        
        return sprite
        
        
    }
    
    
    func loadBlurScreen(){
        
        let duration = 0.5
        
        let pauseBG:SKSpriteNode = self.getBluredScreenshot()
        self.blurNode = pauseBG
        
        //pauseBG.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        pauseBG.alpha = 0
        pauseBG.zPosition = 90
        pauseBG.runAction(SKAction.fadeAlphaTo(1, duration: duration))
        
        self.addChild(blurNode)
        
    }
    
    func retryLevel(){
        
    }
}

