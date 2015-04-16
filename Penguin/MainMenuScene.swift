//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit
class MainMenuScene: SKScene {
    //Sets up playbutton and title variables
    var menuStuff = SKNode.unarchiveFromFile("MainMenu")! as SKNode
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let optionsButton = SKSpriteNode(imageNamed: "OptionsButton")
    let highscoresButton = SKSpriteNode(imageNamed: "HighscoresButton")
    let title = SKSpriteNode(imageNamed: "penguinSlideTitle")
    var playIndex = 0
    var highscoresIndex = 0
    var optionsIndex = 0
    
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
        
        var showEndlessInstructs = NSUserDefaults.standardUserDefaults().integerForKey("EndlessInstructions")
        if(showEndlessInstructs != 2){
            println("endless instructions will show")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "EndlessInstructions")
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        self.backgroundColor = UIColor(red: 0, green: 191, blue: 255, alpha: 1)
        
        let pulseUp = SKAction.scaleTo(1.05, duration: 0.5)
        let pulseDown = SKAction.scaleTo(0.95, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        self.addChild(menuStuff)
        self.setupButtonIndexes()
//        self.addChild(title)
//        self.addChild(playButton)
//        self.addChild(optionsButton)
//        self.addChild(highscoresButton)
        
        self.playButton.runAction(repeatPulse)
        self.optionsButton.runAction(repeatPulse)
        self.highscoresButton.runAction(repeatPulse)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.menuStuff.children[playIndex] as NSObject{
                var ModeSelectScene = ModeSelectionScene.unarchiveFromFile("ModeSelection")! as ModeSelectionScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                ModeSelectScene.scaleMode = .ResizeFill
                skView.presentScene(ModeSelectScene, transition: SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }
            else if self.nodeAtPoint(location) == self.menuStuff.children[optionsIndex] as NSObject{
                var optionsScene = OptionsScene.unarchiveFromFile("Options")! as OptionsScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                optionsScene.scaleMode = .ResizeFill
                skView.presentScene(optionsScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }
            else if self.nodeAtPoint(location) == self.menuStuff.children[highscoresIndex] as NSObject{
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
   
    func setupButtonIndexes(){
        for index in 0...menuStuff.children.count - 1{
            if(self.menuStuff.children[index].name == "playButton"){
                self.playIndex = index
            }
            if(self.menuStuff.children[index].name == "highscoreButton"){
                self.highscoresIndex = index
            }
            if(self.menuStuff.children[index].name == "optionsButton"){
                self.optionsIndex = index
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
