//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
//Gamescene == View
class MainMenuScene: SKScene {
    //Sets up playbutton and title variables

    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let optionsButton = SKSpriteNode(imageNamed: "OptionsButton")
    let highscoresButton = SKSpriteNode(imageNamed: "HighscoresButton")
    let title = SKSpriteNode(imageNamed: "Title")

    
    override func didMoveToView(view: SKView) {
        /* Sets up Scene */
        /*self == this*/
        self.title.anchorPoint = CGPointMake(0.5, 0.5)
        self.title.xScale = (300/self.title.size.width)
        self.title.yScale = (100/self.title.size.height)
        self.title.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 120)
        
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame) + 40 )
        self.optionsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 40)
        self.highscoresButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100)

        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        let pulseUp = SKAction.scaleTo(1.05, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.95, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        self.addChild(title)
        self.addChild(playButton)
        self.addChild(optionsButton)
        self.addChild(highscoresButton)
        
        self.playButton.runAction(repeatPulse)
        self.optionsButton.runAction(repeatPulse)
        self.highscoresButton.runAction(repeatPulse)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton{
                var ModeSelectScene = ModeSelectionScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                ModeSelectScene.scaleMode = .ResizeFill
                ModeSelectScene.size = skView.bounds.size
                skView.presentScene(ModeSelectScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }
            else if self.nodeAtPoint(location) == self.optionsButton{
                var optionsScene = OptionsScene.unarchiveFromFile("Options")! as OptionsScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                optionsScene.scaleMode = .ResizeFill
                skView.presentScene(optionsScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }
            else if self.nodeAtPoint(location) == self.highscoresButton{
                var highscoreScene = HighscoreScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                highscoreScene.scaleMode = .ResizeFill
                highscoreScene.size = skView.bounds.size
                skView.presentScene(highscoreScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }
            else{
                println("Background Pressed")
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
