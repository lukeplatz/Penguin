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
    let level2Button = SKSpriteNode(imageNamed: "Level2")
    
    let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        self.title.anchorPoint = CGPointMake(0.5, 0.5)
        self.title.xScale = (300/self.title.size.width)
        self.title.yScale = (100/self.title.size.height)
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 120)
        
        self.backButton.anchorPoint = CGPointMake(0.5, 0.5)
        self.backButton.xScale = (50/self.backButton.size.width)
        self.backButton.yScale = (50/self.backButton.size.height)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + (self.backButton.size.width / 2), CGRectGetMaxY(self.frame) - (self.backButton.size.height / 2) - statusbarHeight)
        
        self.level1Button.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame) + 40 )
        self.level2Button.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame) - 40)
        
        
        self.addChild(title)
        self.addChild(backButton)
        self.addChild(level1Button)
        self.addChild(level2Button)
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton{
                var modeSelectionScene = ModeSelectionScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                modeSelectionScene.scaleMode = .ResizeFill
                modeSelectionScene.size = skView.bounds.size
                skView.presentScene(modeSelectionScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
                
            }
            else if self.nodeAtPoint(location) == self.level1Button{
                var level1 = Level1Scene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                level1.scaleMode = .ResizeFill
                level1.size = skView.bounds.size
                skView.presentScene(level1, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }
            else if self.nodeAtPoint(location) == self.level2Button{
                var level2 = Level2Scene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                level2.scaleMode = .ResizeFill
                level2.size = skView.bounds.size
                skView.presentScene(level2, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }else{
                println("LevelSelectScene Background Pressed")
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
