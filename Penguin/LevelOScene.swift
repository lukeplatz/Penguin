//
//  LevelKScene.swift
//  Penguin
//
//  Created by Riley Chapin on 4/16/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit

class LevelOScene: PlayScene{
    
    override func retryLevel() {
        motionManager.stopAccelerometerUpdates()
        var levelStuff = LevelOScene.unarchiveFromFile("LevelO")! as LevelOScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    //        override func nextLevel() {
    //            motionManager.stopAccelerometerUpdates()
    //            var levelStuff = LevelJScene.unarchiveFromFile("LevelJ")! as LevelJScene
    //            levelStuff.scaleMode = .ResizeFill
    //            let skView = self.view! as SKView
    //            skView.ignoresSiblingOrder = true
    //            skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    //        }
    
    var leverFlipped = Bool()
    var goalSide = Bool()
    var on_island = Bool()
    var doorEnter = SKSpriteNode()
    var doorExit = SKSpriteNode()
    
    override func setupMap(){
        level = 15
        self.lvlNum.text = "Level \(level)"

        leverFlipped = false
        goalSide = false
        
        
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory | collision.doorCategory
        
        let pulseUp = SKAction.scaleTo(0.95, duration: 0.5)
        let pulseDown = SKAction.scaleTo(1.05, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        let goal = childNodeWithName("goal") as SKSpriteNode
        goal.physicsBody?.categoryBitMask = collision.goalCategory
        goal.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        let F1 = childNodeWithName("fish1") as SKSpriteNode
        F1.physicsBody?.categoryBitMask = collision.fishCategory
        F1.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F1.runAction(repeatPulse)
        
        let F2 = childNodeWithName("fish2") as SKSpriteNode
        F2.physicsBody?.categoryBitMask = collision.fishCategory
        F2.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F2.runAction(repeatPulse)
        
        let F3 = childNodeWithName("fish3") as SKSpriteNode
        F3.physicsBody?.categoryBitMask = collision.fishCategory
        F3.physicsBody?.collisionBitMask = 0 // dont collide with anything
        F3.runAction(repeatPulse)
        
        let lever = childNodeWithName("lever") as SKSpriteNode
        lever.physicsBody?.categoryBitMask = collision.powerUpCategory
        lever.physicsBody?.collisionBitMask = 0 // dont collide with anything
        
        doorEnter = childNodeWithName("door1") as SKSpriteNode
        doorEnter.physicsBody?.categoryBitMask = collision.doorCategory
        doorEnter.physicsBody?.contactTestBitMask = collision.playerCategory
        doorEnter.physicsBody?.collisionBitMask = 0
        
        doorExit = childNodeWithName("door2") as SKSpriteNode
        doorExit.physicsBody?.categoryBitMask = collision.doorCategory
        doorExit.physicsBody?.contactTestBitMask = collision.playerCategory
        doorExit.physicsBody?.collisionBitMask = 0
    }
    
    override func addBridges() {
        if(leverFlipped == false){
            leverFlipped = true
            let lever = childNodeWithName("lever") as SKSpriteNode
            lever.texture = SKTexture(imageNamed: "switchRight")
            
            let water1 = childNodeWithName("WtoRemove1") as SKSpriteNode
            water1.physicsBody?.categoryBitMask = collision.none
            water1.physicsBody?.collisionBitMask = 0
            water1.removeFromParent()
            
            let water2 = childNodeWithName("WtoRemove2") as SKSpriteNode
            water2.physicsBody?.categoryBitMask = collision.none
            water2.physicsBody?.collisionBitMask = 0
            water2.removeFromParent()
            
            let water3 = childNodeWithName("WtoRemove3") as SKSpriteNode
            water3.physicsBody?.categoryBitMask = collision.none
            water3.physicsBody?.collisionBitMask = 0
            water3.removeFromParent()
            
            let water4 = childNodeWithName("WtoRemove4") as SKSpriteNode
            water4.physicsBody?.categoryBitMask = collision.none
            water4.physicsBody?.collisionBitMask = 0
            water4.removeFromParent()

            let water5 = childNodeWithName("WtoRemove5") as SKSpriteNode
            water5.physicsBody?.categoryBitMask = collision.none
            water5.physicsBody?.collisionBitMask = 0
            water5.removeFromParent()
            
            let water6 = childNodeWithName("WtoRemove6") as SKSpriteNode
            water6.physicsBody?.categoryBitMask = collision.none
            water6.physicsBody?.collisionBitMask = 0
            water6.removeFromParent()
            
            let water7 = childNodeWithName("WtoRemove7") as SKSpriteNode
            water7.physicsBody?.categoryBitMask = collision.none
            water7.physicsBody?.collisionBitMask = 0
            water7.removeFromParent()

            let water8 = childNodeWithName("WtoRemove8") as SKSpriteNode
            water8.physicsBody?.categoryBitMask = collision.none
            water8.physicsBody?.collisionBitMask = 0
            water8.removeFromParent()
            
            let water9 = childNodeWithName("WtoRemove9") as SKSpriteNode
            water9.physicsBody?.categoryBitMask = collision.none
            water9.physicsBody?.collisionBitMask = 0
            water9.removeFromParent()

            let water10 = childNodeWithName("WtoRemove10") as SKSpriteNode
            water10.physicsBody?.categoryBitMask = collision.none
            water10.physicsBody?.collisionBitMask = 0
            water10.removeFromParent()
            
            let water11 = childNodeWithName("WtoRemove11") as SKSpriteNode
            water11.physicsBody?.categoryBitMask = collision.none
            water11.physicsBody?.collisionBitMask = 0
            water11.removeFromParent()

            let water12 = childNodeWithName("WtoRemove12") as SKSpriteNode
            water12.physicsBody?.categoryBitMask = collision.none
            water12.physicsBody?.collisionBitMask = 0
            water12.removeFromParent()
            
            let water13 = childNodeWithName("WtoRemove13") as SKSpriteNode
            water13.physicsBody?.categoryBitMask = collision.none
            water13.physicsBody?.collisionBitMask = 0
            water13.removeFromParent()

            let water14 = childNodeWithName("WtoRemove14") as SKSpriteNode
            water14.physicsBody?.categoryBitMask = collision.none
            water14.physicsBody?.collisionBitMask = 0
            water14.removeFromParent()
            
            let water15 = childNodeWithName("WtoRemove15") as SKSpriteNode
            water15.physicsBody?.categoryBitMask = collision.none
            water15.physicsBody?.collisionBitMask = 0
            water15.removeFromParent()

            let water16 = childNodeWithName("WtoRemove16") as SKSpriteNode
            water16.physicsBody?.categoryBitMask = collision.none
            water16.physicsBody?.collisionBitMask = 0
            water16.removeFromParent()
            
            let bridge1 = SKSpriteNode(imageNamed: "boxAlt")
            bridge1.position = water1.position
            bridge1.zPosition = 0.9
            bridge1.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge2 = SKSpriteNode(imageNamed: "boxAlt")
            bridge2.position = water2.position
            bridge2.zPosition = 0.9
            bridge2.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge3 = SKSpriteNode(imageNamed: "boxAlt")
            bridge3.position = water3.position
            bridge3.zPosition = 0.9
            bridge3.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge4 = SKSpriteNode(imageNamed: "boxAlt")
            bridge4.position = water4.position
            bridge4.zPosition = 0.9
            bridge4.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge5 = SKSpriteNode(imageNamed: "boxAlt")
            bridge5.position = water5.position
            bridge5.zPosition = 0.9
            bridge5.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge6 = SKSpriteNode(imageNamed: "boxAlt")
            bridge6.position = water6.position
            bridge6.zPosition = 0.9
            bridge6.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge7 = SKSpriteNode(imageNamed: "boxAlt")
            bridge7.position = water7.position
            bridge7.zPosition = 0.9
            bridge7.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge8 = SKSpriteNode(imageNamed: "boxAlt")
            bridge8.position = water8.position
            bridge8.zPosition = 0.9
            bridge8.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge9 = SKSpriteNode(imageNamed: "boxAlt")
            bridge9.position = water9.position
            bridge9.zPosition = 0.9
            bridge9.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge10 = SKSpriteNode(imageNamed: "boxAlt")
            bridge10.position = water10.position
            bridge10.zPosition = 0.9
            bridge10.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge11 = SKSpriteNode(imageNamed: "boxAlt")
            bridge11.position = water11.position
            bridge11.zPosition = 0.9
            bridge11.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge12 = SKSpriteNode(imageNamed: "boxAlt")
            bridge12.position = water12.position
            bridge12.zPosition = 0.9
            bridge12.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge13 = SKSpriteNode(imageNamed: "boxAlt")
            bridge13.position = water13.position
            bridge13.zPosition = 0.9
            bridge13.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge14 = SKSpriteNode(imageNamed: "boxAlt")
            bridge14.position = water14.position
            bridge14.zPosition = 0.9
            bridge14.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge15 = SKSpriteNode(imageNamed: "boxAlt")
            bridge15.position = water15.position
            bridge15.zPosition = 0.9
            bridge15.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            let bridge16 = SKSpriteNode(imageNamed: "boxAlt")
            bridge16.position = water16.position
            bridge16.zPosition = 0.9
            bridge16.physicsBody?.categoryBitMask = collision.bridgeCategory
            
            self.addChild(bridge1)
            self.addChild(bridge2)
            self.addChild(bridge3)
            self.addChild(bridge4)
            self.addChild(bridge5)
            self.addChild(bridge6)
            self.addChild(bridge7)
            self.addChild(bridge8)
            self.addChild(bridge9)
            self.addChild(bridge10)
            self.addChild(bridge11)
            self.addChild(bridge12)
            self.addChild(bridge13)
            self.addChild(bridge14)
            self.addChild(bridge15)
            self.addChild(bridge16)
        }
    }
    
    override func teleport() {
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory | collision.doorCategory
        println("teleport")
        penguin.physicsBody?.dynamic = false
        
        var shrink = SKAction.scaleTo(0, duration: 0.5)
        penguin.runAction(shrink)
        
        var wait = SKAction.waitForDuration(0.5)
        var b = SKAction.runBlock({self.spawnPenguin()})
        var seq = SKAction.sequence([wait, b])
        self.runAction(seq)
    }
    
    func spawnPenguin(){
        let penguin = childNodeWithName("Penguin") as SKSpriteNode
        if (!on_island)
        {
            penguin.position = doorExit.position
            penguin.position.y -= doorExit.size.height
            penguin.zPosition = 1
            on_island = true
        }
        else
        {
            penguin.position = doorEnter.position
            penguin.position.y -= doorEnter.size.height
            penguin.zPosition = 1
            on_island = false
        }
        
        penguin.physicsBody?.categoryBitMask = collision.playerCategory
        penguin.physicsBody?.collisionBitMask = 1 // dont collide with anything
        penguin.physicsBody?.contactTestBitMask = collision.WaterCategory | collision.IcebergCategory | collision.powerUpCategory | collision.goalCategory | collision.doorCategory
        var grow = SKAction.scaleTo(1, duration: 0.5)
        penguin.runAction(grow)
        
        penguin.physicsBody?.dynamic = true
    }
}
