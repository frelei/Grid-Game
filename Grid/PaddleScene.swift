//
//  PaddleScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 12/1/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit

class PaddleScene: SKScene, SKPhysicsContactDelegate {

    // Categorie Names
    let BallCategoryName = "ball"
    let PaddleCategoryName = "paddle"
    
    
    override func didMoveToView(view: SKView) {
        // Create Cam
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
//        borderBody.categoryBitMask = UInt32(Category.WORLD.rawValue)
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(100, -100))
        ball.physicsBody!.contactTestBitMask =   UInt32(Category.WALL_BOTTOM.rawValue)
        
        // Create bottom
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)

        // Create Left
        let leftRect = CGRectMake(frame.origin.x, frame.origin.y,  1, frame.size.height)
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeLoopFromRect: leftRect)
        addChild(left)
        
        // Create Right
        let rightRect = CGRectMake(frame.size.width, frame.origin.y, 1, frame.size.height)
        let right = SKNode()
        right.physicsBody = SKPhysicsBody(edgeLoopFromRect: rightRect)
        addChild(right)
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        
        
        // Add Categories
        bottom.physicsBody!.categoryBitMask = UInt32(Category.WALL_BOTTOM.rawValue)
        right.physicsBody!.categoryBitMask = UInt32(Category.BLOCK.rawValue)
        left.physicsBody!.categoryBitMask = UInt32(Category.BLOCK.rawValue)
        ball.physicsBody!.categoryBitMask = UInt32(Category.BALL.rawValue)
        paddle.physicsBody!.categoryBitMask = UInt32(Category.PADDLE.rawValue)
        // contact paddle
//        right.physicsBody?.contactTestBitMask = UInt32(Category.PADDLE.rawValue)
//        right.physicsBody?.collisionBitMask = UInt32(Category.PADDLE.rawValue)
        // contact wall
//        paddle.physicsBody?.contactTestBitMask = UInt32(Category.BLOCK.rawValue)
        paddle.physicsBody?.collisionBitMask =  UInt32(Category.BLOCK.rawValue)
    }
    
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("began")
        let touch = touches.first
        let point = touch!.locationInView(self.view)
        let middle = self.frame.height / 2
        let paddle = childNodeWithName(PaddleCategoryName)
        
        paddle?.removeAllActions()
        if point.x >= middle{
            let moveRight = SKAction.moveByX(200.0, y: 0.0, duration: 1.0)
            paddle?.runAction(SKAction.repeatActionForever(moveRight))
        }else{
            let moveLeft = SKAction.moveByX(-200.0, y: 0.0, duration: 1.0)
            paddle?.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    

    // MARK: DELEGATE
    
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
        
        // 3. react to the contact between ball and bottom
        if firstBody.categoryBitMask == UInt32(Category.BALL.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.WALL_BOTTOM.rawValue) {
            //TODO: Replace the log statement with display of Game Over Scene
            print("Game Over")
        }
        
        
        if firstBody.categoryBitMask == UInt32(Category.BALL.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.PADDLE.rawValue){
               print("Paddle")
        }
        
//        if firstBody.categoryBitMask == UInt32(Category.PADDLE.rawValue) &&
//            secondBody.categoryBitMask == UInt32(Category.BLOCK.rawValue){
//                print("Touch Left")
//        }

        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
 //       print("lalala")
    }
    
}
