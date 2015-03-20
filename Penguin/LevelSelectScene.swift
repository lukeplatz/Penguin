//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit


class LevelSelectScene: SKScene {
    
    let title = SKSpriteNode(imageNamed: "LevelSelectTitle")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let level1Button = SKSpriteNode(imageNamed: "Level1")
    
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        self.title.anchorPoint = CGPointMake(0.5, 0.5)
        self.title.xScale = (300/self.title.size.width)
        self.title.yScale = (100/self.title.size.height)
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 120)
        
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (100/self.backButton.size.width)
        self.backButton.yScale = (50/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        
        self.level1Button.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame) + 40 )
        
        
        self.addChild(title)
        self.addChild(backButton)
        self.addChild(level1Button)
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton{
                var mainMenuScene = MainMenuScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                mainMenuScene.scaleMode = .ResizeFill
                mainMenuScene.size = skView.bounds.size
                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
                
            }
            else if self.nodeAtPoint(location) == self.level1Button{
                var playScene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                playScene.scaleMode = .ResizeFill
                playScene.size = skView.bounds.size
                skView.presentScene(playScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }else{
                println("LevelSelectScene Background Pressed")
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
