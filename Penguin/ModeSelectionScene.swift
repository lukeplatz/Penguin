//
//  MainMenuScene.swift
//  Penguin
//
//  Created by Luke Platz on 3/17/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit


class ModeSelectionScene: SKScene {
    var modeStuff = SKNode.unarchiveFromFile("ModeSelection")! as SKNode
    var storyIndex = 0
    var endlessIndex = 0
    var backIndex = 0
    let title = SKSpriteNode(imageNamed: "selectModeTitle")
    let backButton = SKSpriteNode(imageNamed: "BackButton")
    let storyButton = SKSpriteNode(imageNamed: "StoryButton")
    let endlessButton = SKSpriteNode(imageNamed: "EndlessButton")
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
        self.storyButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 40)
        self.endlessButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 40)
        setupButtonIndexes()
        self.addChild(modeStuff)
//        self.addChild(title)
//        self.addChild(backButton)
//        self.addChild(storyButton)
//        self.addChild(endlessButton)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.modeStuff.children[backIndex] as NSObject{
                var mainMenuScene = MainMenuScene.unarchiveFromFile("MainMenu") as MainMenuScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                mainMenuScene.scaleMode = .ResizeFill
                skView.presentScene(mainMenuScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.5))
            }
            else if self.nodeAtPoint(location) == self.modeStuff.children[storyIndex] as NSObject{
                var levelSelectScene = LevelSelectScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                levelSelectScene.scaleMode = .ResizeFill
                levelSelectScene.size = skView.bounds.size
                skView.presentScene(levelSelectScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }else if self.nodeAtPoint(location) == self.modeStuff.children[endlessIndex] as NSObject{
                var endlessScene = EndlessPlayScene.unarchiveFromFile("EndlessLevel")! as EndlessPlayScene
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                endlessScene.scaleMode = .Fill
                skView.presentScene(endlessScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0.5))
            }else{
                println("ModeSelectionScene Background Pressed")
            }
        }
    }
    
    func setupButtonIndexes(){
        for index in 0...modeStuff.children.count - 1{
            if(self.modeStuff.children[index].name == "storyButton"){
                self.storyIndex = index
            }
            if(self.modeStuff.children[index].name == "endlessButton"){
                self.endlessIndex = index
            }
            if(self.modeStuff.children[index].name == "backButton"){
                self.backIndex = index
            }

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
