//
//  LevelKScene.swift
//  Penguin
//
//  Created by Riley Chapin on 4/16/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import SpriteKit

class LevelNScene: PlayScene{
    
    override func retryLevel() {
        var levelStuff = LevelNScene.unarchiveFromFile("LevelN")! as LevelNScene
        levelStuff.scaleMode = .ResizeFill
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    override func nextLevel() {
            var levelStuff = LevelBScene.unarchiveFromFile("LevelB")! as LevelBScene
            levelStuff.scaleMode = .ResizeFill
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            skView.presentScene(levelStuff, transition: SKTransition.fadeWithDuration(1))
    }
    
    var leverFlipped = Bool()
    
    override func setupMap(){
        level = 10
        leverFlipped = false
        
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
        
        let moveleft = SKAction.moveBy(CGVectorMake(-(self.size.width / 3), 0), duration: 1.0)
        let moveright = SKAction.moveBy(CGVectorMake((self.size.width / 3), 0), duration: 1.0)
        let leftRight = SKAction.sequence([moveleft, moveright, moveright, moveleft])
        let repeatLRMove = SKAction.repeatActionForever(leftRight)
        let rightLeft = SKAction.sequence([moveright, moveleft, moveleft, moveright])
        let repeatRLMove = SKAction.repeatActionForever(rightLeft)
        
        let puffer1 = childNodeWithName("pf1") as SKSpriteNode
        puffer1.physicsBody?.categoryBitMask = collision.WaterCategory
        puffer1.physicsBody?.collisionBitMask = 1 // allow contact
        puffer1.runAction(repeatLRMove)
        
        let puffer2 = childNodeWithName("pf2") as SKSpriteNode
        puffer2.physicsBody?.categoryBitMask = collision.WaterCategory
        puffer2.physicsBody?.collisionBitMask = 1 // allow contact
        puffer2.runAction(repeatRLMove)
        
        let lever = childNodeWithName("lever") as SKSpriteNode
        lever.physicsBody?.categoryBitMask = collision.powerUpCategory
        lever.physicsBody?.collisionBitMask = 0 // dont collide with anything
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
            
            self.addChild(bridge1)
            self.addChild(bridge2)
            self.addChild(bridge3)
            self.addChild(bridge4)
        }
    }
}
