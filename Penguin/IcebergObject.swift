//
//  IcebergObject.swift
//  Penguin
//
//  Created by Luke Platz on 4/2/15.
//  Copyright (c) 2015 Luke Platz. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Iceberg: Object {
    var sprite: SKSpriteNode
    
    init (position: CGPoint, size: CGSize) {
        self.sprite = SKSpriteNode(imageNamed: "Shortblock")
        sprite.name = "Iceberg"
        sprite.size = size
        sprite.position = position
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.dynamic = false
//        sprite.physicsBody?.categoryBitMask = collision.IcebergCategory
//        sprite.physicsBody?.contactTestBitMask = collision.playerCategory
//        sprite.physicsBody?.collisionBitMask = collision.IcebergCategory
    }
    
//    func move() {
//        sprite.position = CGPointMake(sprite.position.x - 4, sprite.position.y)
//    }
}