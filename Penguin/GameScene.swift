//
//  GameScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let title = SKSpriteNode(imageNamed: "Title")
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Sets up Scene */
        self.title.anchorPoint = CGPointMake(0.5, 0.5)
        self.title.xScale = (300/self.title.size.width)
        self.title.yScale = (100/self.title.size.height)
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 120)
        let test = self.title.xScale
        
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame))
        self.addChild(playButton)
        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        let pulseUp = SKAction.scaleTo(1.05, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.95, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        self.addChild(title)
        self.playButton.runAction(repeatPulse)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton{
                var playScene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                playScene.scaleMode = .ResizeFill
                playScene.size = skView.bounds.size
                skView.presentScene(playScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.0))
            }else{
                println("GameScene Background Pressed")
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
