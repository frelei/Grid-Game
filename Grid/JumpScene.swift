//
//  JumpScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 01/12/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit

class JumpScene: SKScene, SKPhysicsContactDelegate {

    // Categorie Names
    let blockCategoryName = "block"
    let paddleCategoryName = "paddle"
    var oldTime : NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {

        physicsWorld.contactDelegate = self
        
    
        // Create Walls
        let bottomRect = CGRectMake(frame.origin.x - 300 , frame.origin.y  , frame.size.width + 300, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let rightRect = CGRectMake(frame.size.width , frame.origin.y , 1, frame.size.height)
        let right = SKNode()
        right.physicsBody = SKPhysicsBody(edgeLoopFromRect: rightRect)
        addChild(right)
        
        let leftRect = CGRectMake(frame.origin.x, frame.origin.y , 1, frame.size.height)
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeLoopFromRect: leftRect)
        addChild(left)
        
        // Get Objects
        let paddle = childNodeWithName(paddleCategoryName) as! SKSpriteNode
        let block = childNodeWithName(blockCategoryName) as! SKSpriteNode

        // Categorie Bits
        paddle.physicsBody?.categoryBitMask = UInt32(Category.PADDLE.rawValue)
        block.physicsBody?.categoryBitMask  = UInt32(Category.BLOCK.rawValue)
        left.physicsBody?.categoryBitMask = UInt32(Category.WALL_LEFT.rawValue)
        right.physicsBody?.categoryBitMask = UInt32(Category.WALL_RIGHT.rawValue)
        bottom.physicsBody?.categoryBitMask = UInt32(Category.WALL_BOTTOM.rawValue)
        
        // Contact
        paddle.physicsBody?.contactTestBitMask =  UInt32(Category.BLOCK.rawValue)

        // Colission
        paddle.physicsBody?.collisionBitMask =  UInt32(Category.BLOCK.rawValue)       |
                                                UInt32(Category.WALL_BOTTOM.rawValue) |
                                                UInt32(Category.WALL_LEFT.rawValue)   |
                                                UInt32(Category.WALL_RIGHT.rawValue)
        
        block.physicsBody?.collisionBitMask = UInt32(Category.WALL_BOTTOM.rawValue)

    }
    
    // MARK: PHISYCS
    func didBeginContact(contact: SKPhysicsContact) {

        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        
        print("hit")
        
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        if currentTime  - oldTime > 5{
            oldTime = currentTime
            let block = childNodeWithName(blockCategoryName) as! SKSpriteNode
            let blockTemp = block.copyWithPhysicsBody()
            addChild(blockTemp)
            let action = SKAction.moveByX(100, y: 0.0, duration: 1.0)
            blockTemp.runAction(SKAction.repeatActionForever(action))
        }
    }

}
