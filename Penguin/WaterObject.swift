//
//  WaterObject.swift
//  Penguin
//
//  Created by Riley Chapin on 4/6/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Water: Object {
    var sprite: SKSpriteNode
    
    init (position: CGPoint, size: CGSize) {
        self.sprite = SKSpriteNode(imageNamed: "Water")
        sprite.name = "Water"
        sprite.size = size
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.categoryBitMask = collision.WaterCategory
        sprite.physicsBody?.contactTestBitMask = collision.playerCategory
        sprite.physicsBody?.collisionBitMask = collision.none
    }
    
    //    func move() {
    //        sprite.position = CGPointMake(sprite.position.x - 4, sprite.position.y)
    //    }
}
