//
//  JumpScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 01/12/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit

class JumpScene: SKScene, SKPhysicsContactDelegate{

    // Categorie Names
    let blockCategoryName = "block"
    let paddleCategoryName = "paddle"
    var oldTime : NSTimeInterval = 0
    var isJump = false
    var skViewDelegate: SKViewDelegate?
    var timer : NSTimer?
    var level : Int?
    var stopped :Bool = false
    
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
        paddle.physicsBody?.contactTestBitMask =  UInt32(Category.BLOCK.rawValue) | UInt32(Category.WALL_BOTTOM.rawValue)
        
        // Colission
        paddle.physicsBody?.collisionBitMask =  UInt32(Category.BLOCK.rawValue)       |
                                                UInt32(Category.WALL_BOTTOM.rawValue) |
                                                UInt32(Category.WALL_LEFT.rawValue)   |
                                                UInt32(Category.WALL_RIGHT.rawValue)
        
        block.physicsBody?.collisionBitMask = UInt32(Category.WALL_BOTTOM.rawValue)
        
        // SWIPE
        let swipe = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipe.direction = .Up
        view.addGestureRecognizer(swipe)

        self.listener = paddle
        
        // Timer 
        timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: "changeGameTimer:", userInfo: nil, repeats: false)
        
        
        print("JUMP")
    }
    
    // TIMER
    func changeGameTimer(timer: NSTimer){
        timer.invalidate()
        // Change phase
        skViewDelegate?.playerLevelUp(self)
    }
    
    // SWIPE GESTURE
    func swipe(swipe: UISwipeGestureRecognizer){
        let paddle = childNodeWithName(paddleCategoryName)
        let block  = childNodeWithName(blockCategoryName)
        // Check Jump
        if isJump == false{
            isJump = true
            paddle?.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (block?.frame.size.height)! * 2))
            paddle?.runAction(SKAction.playSoundFileNamed("jump3.wav", waitForCompletion: false))
        }
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

        if firstBody.categoryBitMask == UInt32(Category.PADDLE.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.WALL_BOTTOM.rawValue){
                isJump = false
                let paddle = childNodeWithName(paddleCategoryName)
                paddle?.runAction(SKAction.playSoundFileNamed("landing.wav", waitForCompletion: false))
        }
        
        if firstBody.categoryBitMask == UInt32(Category.PADDLE.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.BLOCK.rawValue){
                if stopped == false{
                    stopped = true
                    self.timer?.invalidate()
                    skViewDelegate?.playerLoose(self)
                }
        }
    }
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let paddle = childNodeWithName(paddleCategoryName)

        let touch = touches.first
        let point = touch!.locationInView(self.view)
        let middle = self.frame.height / 2
        
        paddle?.removeAllActions()
        if point.x >= middle{
            let moveRight = SKAction.moveByX(300.0, y: 0.0, duration: 1.0)
            paddle?.runAction(SKAction.repeatActionForever(moveRight))
        } else {
            let moveLeft = SKAction.moveByX(-300.0, y: 0.0, duration: 1.0)
            paddle?.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    // MARK: UPDATE
    override func update(currentTime: CFTimeInterval) {
        if currentTime  - oldTime > 3{
            oldTime = currentTime
            let block = childNodeWithName(blockCategoryName) as! SKSpriteNode
            let blockTemp = block.copyWithPhysicsBody()
            addChild(blockTemp)
            
            // change duration of the time
            let action = SKAction.moveByX(CGFloat(level!), y: 0.0, duration: 1.0)
            blockTemp.runAction(SKAction.repeatActionForever(action))
        }
    }
    
}
