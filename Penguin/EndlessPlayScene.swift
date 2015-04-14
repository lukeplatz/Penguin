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
    let GameOverStuff = SKNode.unarchiveFromFile("GameOver")!

    let PauseStuff = SKNode.unarchiveFromFile("PausePopup")!
    
    let longBlock = SKSpriteNode(imageNamed: "Tallblock")
    let shortBlock = SKSpriteNode(imageNamed: "Shortblock")
    let penguin = SKSpriteNode(imageNamed: "Penguin")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let pausedImage = SKSpriteNode(imageNamed: "Paused")
    let score = SKLabelNode(fontNamed: "Arial")
    let instructions1 = SKLabelNode(fontNamed: "Arial")
    let instructions2 = SKLabelNode(fontNamed: "Arial")
    let HUDbar = SKSpriteNode(imageNamed: "HudBar")
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    let speedLabel = SKLabelNode(fontNamed: "Arial")
    var blurNode:SKSpriteNode = SKSpriteNode()
    
    var retryButtonIndex = 0
    var resumeButtonIndex = 0
    var quitButtonIndex = 0
    
    var moveObstacleAction: SKAction!
    var moveObstacleForeverAction: SKAction!
    let spawnThenDelay: SKAction!
    let spawnThenDelayForever: SKAction!
    var obstacles = [SKNode]()
    
    var PlayerScore = 0
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    var timerThread = NSThread()
    var motionManager = CMMotionManager()
    
    var calibrateX = CGFloat(0)
    var calibrateY = CGFloat(0)
    var needToCalibrate = true
    
    var scrollSpeed = 5
    
    var minDistance = CGFloat(650)
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
        
        var bottom = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(CGRectGetWidth(self.frame), 10))
        bottom.position.x = CGRectGetMidX(self.frame)
        bottom.position.y = CGRectGetMinY(self.frame)
        bottom.physicsBody = SKPhysicsBody(rectangleOfSize: bottom.size)
        bottom.physicsBody?.dynamic = false
        bottom.physicsBody?.collisionBitMask = 1
        bottom.physicsBody?.categoryBitMask = BodyType.bottom.rawValue
        bottom.physicsBody?.contactTestBitMask = BodyType.penguin.rawValue | BodyType.bottom.rawValue
        
        self.addChild(bottom)
        
        let snow = SKEmitterNode.unarchiveFromFile("SnowParticles")
        snow?.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 30)
        self.addChild(snow!)
        
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
        
        let spawn = SKAction.runBlock({() in self.timerFired()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        moveObstacleAction = SKAction.moveBy(CGVectorMake(0, -CGFloat(scrollSpeed)), duration: 0.02)
        moveObstacleForeverAction = SKAction.repeatActionForever(SKAction.sequence([moveObstacleAction]))
        
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
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if(self.gameO == true){
                if (self.nodeAtPoint(location) == self.GameOverStuff.children[quitButtonIndex] as NSObject){
                    var ModeSelect = ModeSelectionScene(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    ModeSelect.scaleMode = .ResizeFill
                    ModeSelect.size = skView.bounds.size
                    skView.presentScene(ModeSelect, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                    
                }
                if (self.nodeAtPoint(location) == self.GameOverStuff.children[retryButtonIndex] as NSObject){
                    self.Pause = false
                    var endlessScene = EndlessPlayScene.unarchiveFromFile("EndlessLevel")! as EndlessPlayScene
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    endlessScene.scaleMode = .Fill
                    skView.presentScene(endlessScene, transition: SKTransition.fadeWithDuration(1))
                    
                }

            }
            
            else if(self.Pause == false){
                if self.nodeAtPoint(location) == self.backButton{
                    motionManager.stopAccelerometerUpdates()
                    self.needToCalibrate = true
                    var mainMenuScene = MainMenuScene(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    mainMenuScene.scaleMode = .ResizeFill
                    mainMenuScene.size = skView.bounds.size
                    skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                }else if self.nodeAtPoint(location) == self.pauseButton && self.gameO == false{
                    if(self.Pause == true){
                        //Resume
                        self.blurNode.removeFromParent()
                        self.pausedImage.removeFromParent()
                        self.Pause = false
                        self.physicsWorld.speed = 1
                    }else{
                        //Pause
                        loadBlurScreen()
                        self.setupPausePopup()
                        self.addChild(PauseStuff)
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
           
            else if(self.Pause == true){
                if(self.nodeAtPoint(location) == self.PauseStuff.children[resumeButtonIndex] as NSObject){
                    self.Pause = false
                    self.blurNode.removeFromParent()
                    PauseStuff.removeFromParent()
                    self.physicsWorld.speed = 1
                }
                if (self.nodeAtPoint(location) == self.PauseStuff.children[quitButtonIndex] as NSObject){
                    var ModeSelection = ModeSelectionScene(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    ModeSelection.scaleMode = .ResizeFill
                    ModeSelection.size = skView.bounds.size
                    skView.presentScene(ModeSelection, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                    
                    
                }
                else if(self.nodeAtPoint(location) == self.PauseStuff.children[retryButtonIndex] as NSObject){
                    self.Pause = false
                    var endlessScene = EndlessPlayScene.unarchiveFromFile("EndlessLevel")! as EndlessPlayScene
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    endlessScene.scaleMode = .Fill
                    skView.presentScene(endlessScene, transition: SKTransition.fadeWithDuration(1))
                    
                }

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
        self.backButton.xScale = (100/self.backButton.size.width)
        self.backButton.yScale = (100/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - (statusbarHeight) - 12)
        self.backButton.zPosition = 2
        
        self.HUDbar.yScale = 135/self.HUDbar.size.height
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
        self.pauseButton.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.pauseButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.pauseButton.size.height / 2) - (statusbarHeight) - 12)
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
    
    func stopAnimations(){
        for index in 0 ... obstacles.count - 1{
            obstacles[index].removeAllActions()
        }
    }
    
    func startAnimations(){
        for index in 0 ... obstacles.count - 1{
            obstacles[index].runAction(moveObstacleForeverAction)
        }
    }
    
    func timerFired(){
        if(self.paused == false){
            var obstacleSet = SKNode()
            var rand = random(min: -250, max: 250)
            println(rand)
//            var spriteName = "tiki-bottom-0\(rand)"
//            if(rand == CGFloat(1)){
//                println("powerup")
//                var powerup1 = SKSpriteNode(imageNamed: "BridgePowerup")
//                powerup1.xScale = 100/powerup1.size.width
//                powerup1.yScale = 100/powerup1.size.height
//                powerup1.position = CGPointMake(CGRectGetMinX(self.frame) + 150, CGRectGetMaxY(self.frame))
//                powerup1.physicsBody = SKPhysicsBody(rectangleOfSize: powerup1.size)
//                powerup1.physicsBody?.dynamic = false
//                obstacleSet.addChild(powerup1)
//                
//                var powerup2 = SKSpriteNode(imageNamed: "BridgePowerup")
//                powerup2.xScale = 100/powerup2.size.width
//                powerup2.yScale = 100/powerup2.size.height
//                powerup2.position = CGPointMake(CGRectGetMaxX(self.frame) - 150, CGRectGetMaxY(self.frame))
//                powerup2.physicsBody = SKPhysicsBody(rectangleOfSize: powerup2.size)
//                powerup2.physicsBody?.dynamic = false
//                obstacleSet.addChild(powerup2)
//            }
            
            var iceBlock = SKSpriteNode(imageNamed: "endlessIce")
            iceBlock.xScale = 500/iceBlock.size.width
            iceBlock.yScale = 50/iceBlock.size.height
            iceBlock.position = CGPointMake(rand, CGRectGetMaxY(self.frame))
            iceBlock.physicsBody = SKPhysicsBody(rectangleOfSize: iceBlock.size)
            iceBlock.physicsBody?.dynamic = false
            obstacleSet.addChild(iceBlock)
            
            var iceBlock2 = SKSpriteNode(imageNamed: "endlessIce")
            iceBlock2.xScale = 500/iceBlock2.size.width
            iceBlock2.yScale = 50/iceBlock2.size.height
            iceBlock2.position = CGPointMake(iceBlock.position.x + CGFloat(minDistance), CGRectGetMaxY(self.frame))
            iceBlock2.physicsBody = SKPhysicsBody(rectangleOfSize: iceBlock.size)
            iceBlock2.physicsBody?.dynamic = false
            obstacleSet.addChild(iceBlock2)
            
            obstacles.append(obstacleSet)
            obstacleSet.runAction(moveObstacleForeverAction)
            self.addChild(obstacleSet)
            obstacleSet.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame))
            if(obstacles.count > 4){
                obstacles.removeLast()
            }

        }
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //this gets called automatically when two objects begin contact with each other
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case BodyType.penguin.rawValue | BodyType.bottom.rawValue:
            self.physicsWorld.speed = 0
            GameOverStuff.removeFromParent()
            loadBlurScreen()
            var score = GameOverStuff.childNodeWithName("ScoreLabel") as SKLabelNode
            score.text = "SCORE: \(PlayerScore)"
            stopAnimations()
            setHighScore()
            setupGameOver()
            
            self.addChild(GameOverStuff)
            self.gameO = true
            self.Pause = true
        default:
            return
        }
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
    
    func setupPausePopup(){
        for index in 0...PauseStuff.children.count - 1{
            if(self.PauseStuff.children[index].name == "retryButton"){
                self.retryButtonIndex = index
            }
            if(self.PauseStuff.children[index].name == "quitButton"){
                self.quitButtonIndex = index
            }
            if(self.PauseStuff.children[index].name == "resumeButton"){
                self.resumeButtonIndex = index
            }
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

}
