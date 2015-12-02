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
    var skViewDelegate: SKViewDelegate?
    var timer: NSTimer?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        // Create Cam
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = UInt32(Category.WORLD.rawValue)
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(200, -200))
        
        // Create bottom
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        
        // Add Categories
        bottom.physicsBody!.categoryBitMask = UInt32(Category.WALL_BOTTOM.rawValue)
        ball.physicsBody!.categoryBitMask = UInt32(Category.BALL.rawValue)
        paddle.physicsBody!.categoryBitMask = UInt32(Category.PADDLE.rawValue)
        
        // ball contact
        ball.physicsBody!.contactTestBitMask =   UInt32(Category.WALL_BOTTOM.rawValue) | UInt32(Category.WORLD.rawValue)
        // paddle contact
        paddle.physicsBody?.collisionBitMask =  UInt32(Category.WORLD.rawValue)
        
        self.listener = paddle
        
        // Timer
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "changeGameTimer:", userInfo: nil, repeats: false)
    }
    
   // MARK: TIMER
    func changeGameTimer(timer: NSTimer){
        timer.invalidate()
        skViewDelegate?.playerLevelUp(self)
    }
    
    
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self.view)
        let middle = self.frame.height / 2
        let paddle = childNodeWithName(PaddleCategoryName)
        
        paddle?.removeAllActions()
        if point.x >= middle{
            let moveRight = SKAction.moveByX(300.0, y: 0.0, duration: 1.0)
            paddle?.runAction(SKAction.repeatActionForever(moveRight))
        }else{
            let moveLeft = SKAction.moveByX(-300.0, y: 0.0, duration: 1.0)
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
                skViewDelegate?.playerLoose(self)
        }
        
        
        if firstBody.categoryBitMask == UInt32(Category.BALL.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.PADDLE.rawValue){
                let ball = childNodeWithName(BallCategoryName)
                ball?.runAction(SKAction.playSoundFileNamed("ball.wav", waitForCompletion: false))
        }
        
        if firstBody.categoryBitMask == UInt32(Category.WORLD.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.BALL.rawValue){
                let ball = childNodeWithName(BallCategoryName)
                ball?.runAction(SKAction.playSoundFileNamed("ball.wav", waitForCompletion: false))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
 //       print("lalala")
    }
    
}
