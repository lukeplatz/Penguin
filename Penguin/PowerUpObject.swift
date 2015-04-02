//
//  PowerUpObject.swift
//  Penguin
//
//  Created by Luke Platz on 4/2/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class PowerUp: Object {
    var sprite: SKSpriteNode
    
    init (position: CGPoint, size: CGSize) {
        self.sprite = SKSpriteNode(imageNamed: "PowerUp")
        sprite.name = "PowerUp"
        sprite.size = size
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.categoryBitMask = collision.powerUpCategory
        sprite.physicsBody?.contactTestBitMask = collision.playerCategory
        sprite.physicsBody?.collisionBitMask = collision.none
    }
    
    //    func move() {
    //        sprite.position = CGPointMake(sprite.position.x - 4, sprite.position.y)
    //    }
}