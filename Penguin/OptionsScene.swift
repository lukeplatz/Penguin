//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit


class OptionsScene: SKScene {
    
    let title = SKSpriteNode(imageNamed: "optionsTitle")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let resetButton = SKSpriteNode(imageNamed: "ResetButton")
    let confirmStuff = SKNode.unarchiveFromFile("ConfirmPopup")!
    var blurNode:SKSpriteNode = SKSpriteNode()
    var NumLevelsUnlocked = 6
    
    var retryButtonIndex = 0
    var quitButtonIndex = 0
    var resumeButtonIndex = 0
    
    var confirmYesIndex = 0
    var confirmNoIndex = 0
    var popupUp = false
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        self.title.anchorPoint = CGPointMake(0.5, 0.5)
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 120)
        
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (100/self.backButton.size.width)
        self.backButton.yScale = (100/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        
        self.resetButton.name = "reset"
        self.resetButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.resetButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(resetButton)
        
        self.addChild(title)
        self.addChild(backButton)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton{
                var mainMenuScene = MainMenuScene.unarchiveFromFile("MainMenu") as MainMenuScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                mainMenuScene.scaleMode = .ResizeFill
                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
            }else if(self.nodeAtPoint(location) == self.resetButton){
                loadBlurScreen()
                self.setupConfirm()
                confirmStuff.xScale = 0
                confirmStuff.yScale = 0
                confirmStuff.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                self.addChild(confirmStuff)
                let scale = SKAction.scaleTo(1, duration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0)
                confirmStuff.runAction(scale)
                popupUp = true
            }else if (self.nodeAtPoint(location) == self.confirmStuff.children[confirmYesIndex] as NSObject){
                for index in 1 ... NumLevelsUnlocked{
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "highscore\(index)")
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "highscoreEndless")
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "EndlessInstructions")
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "StoryInstructions")
                    var i = 1
                    while NSUserDefaults.standardUserDefaults().integerForKey("levelWon\(i)") == 1 {
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "levelWon\(i)")
                        i++
                    }
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                popupUp = false
                self.confirmStuff.removeFromParent()
                self.blurNode.removeFromParent()
            }else if (self.nodeAtPoint(location) == self.confirmStuff.children[confirmNoIndex] as NSObject){
                self.confirmStuff.removeFromParent()
                self.blurNode.removeFromParent()
                popupUp = false
            }
        }
    }
    
    func setupConfirm(){
        for index in 0...confirmStuff.children.count - 1{
            if(confirmStuff.children[index].name == "yes"){
                confirmYesIndex = index
            }
            if(confirmStuff.children[index].name == "no"){
                confirmNoIndex = index
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
        pauseBG.alpha = 0
        pauseBG.zPosition = 90
        pauseBG.runAction(SKAction.fadeAlphaTo(1, duration: duration))
        self.addChild(blurNode)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
