//
//  ShotterScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 12/2/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ShotterScene: SKScene, SKPhysicsContactDelegate {

    // Category Name
    let heroCategoryName = "Hero"
    let enemyCategoryName = "Enemy"
    let shotCategoryName = "Shot"
    var distribution: GKRandomDistribution!
    
    var oldTime : NSTimeInterval = 0 // control enemies
    var shotTime : NSTimeInterval = 0 // control shots
    var timer: NSTimer?
    var skDelegate: SKViewDelegate?
    var level: Int?
    var stopped: Bool = false
    
    // MARK: MOVE
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Create Walls
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y  , frame.size.width, 1)
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
        let enemy = childNodeWithName(enemyCategoryName) as! SKSpriteNode
        let hero = childNodeWithName(heroCategoryName) as! SKSpriteNode
        let shot = childNodeWithName(shotCategoryName) as! SKSpriteNode
       
        // Categorie
        enemy.physicsBody?.categoryBitMask = UInt32(Category.ENEMY.rawValue)
        hero.physicsBody?.categoryBitMask = UInt32(Category.HERO.rawValue)
        shot.physicsBody?.categoryBitMask = UInt32(Category.BLOCK.rawValue)
        bottom.physicsBody?.categoryBitMask = UInt32(Category.WALL_BOTTOM.rawValue)
        right.physicsBody?.categoryBitMask = UInt32(Category.WALL_RIGHT.rawValue)
        left.physicsBody?.categoryBitMask = UInt32(Category.WALL_LEFT.rawValue)
        
        // Test contact
        enemy.physicsBody?.contactTestBitMask = UInt32(Category.WALL_BOTTOM.rawValue) |
                                                UInt32(Category.HERO.rawValue)
        
        shot.physicsBody?.contactTestBitMask = UInt32(Category.ENEMY.rawValue)
        
        // Collision
        hero.physicsBody?.collisionBitMask = UInt32(Category.WALL_BOTTOM.rawValue) |
                                             UInt32(Category.WALL_RIGHT.rawValue) |
                                             UInt32(Category.WALL_LEFT.rawValue)
        
        // Create Timer
        timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "changeGameTimer:", userInfo: nil, repeats: false)
        
        // Random Distribution
        distribution = GKRandomDistribution(lowestValue: 44, highestValue: 1050)
        
        self.listener = self
        
        print("SHOTTER ")

        
    }
    
    // MARK: TIMER DELEGATE
    func changeGameTimer(timer: NSTimer){
        timer.invalidate()
        skDelegate?.playerLevelUp(self)
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
        
        if firstBody.categoryBitMask == UInt32(Category.ENEMY.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.WALL_BOTTOM.rawValue) {
                if stopped == false{
                    stopped = true
                    self.timer?.invalidate()
                    skDelegate?.playerLoose(self)
                }
        }
        
        if firstBody.categoryBitMask == UInt32(Category.ENEMY.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.HERO.rawValue) {
                if stopped == false{
                    stopped = true
                    self.timer?.invalidate()
                    skDelegate?.playerLoose(self)
                }
        }
        
        if firstBody.categoryBitMask == UInt32(Category.BLOCK.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.ENEMY.rawValue){
                // Destroy both
                firstBody.node?.runAction(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion:   false), completion: { () -> Void in
                     firstBody.node?.removeFromParent()
                })
                secondBody.node?.removeFromParent()
        }
    }

    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let hero = childNodeWithName(heroCategoryName)
        
        let touch = touches.first
        let point = touch!.locationInView(self.view)
        let middle = self.frame.height / 2
        
        hero?.removeAllActions()
        if point.x >= middle{
            let moveRight = SKAction.moveByX(300.0, y: 0.0, duration: 1.0)
            hero?.runAction(SKAction.repeatActionForever(moveRight))
        } else {
            let moveLeft = SKAction.moveByX(-300.0, y: 0.0, duration: 1.0)
            hero?.runAction(SKAction.repeatActionForever(moveLeft))
        }
    }
    
    // MARK: UPDATE
    override func update(currentTime: CFTimeInterval) {
        if currentTime  - oldTime > 3{
            oldTime = currentTime
            let enemy = childNodeWithName(enemyCategoryName) as! SKSpriteNode
            let enemyTemp = enemy.copyWithPhysicsBody()
            enemyTemp.position.x = CGFloat(distribution.nextInt())
            addChild(enemyTemp)
            
            // change duration of the time
            let action = SKAction.moveByX(0.0, y: -CGFloat(level!), duration: 1.0)
            enemyTemp.runAction(SKAction.repeatActionForever(action))
        }
        
        if currentTime - shotTime > 0.5{
            shotTime = currentTime
            let hero = childNodeWithName(heroCategoryName) as! SKSpriteNode
            let shot = childNodeWithName(shotCategoryName) as! SKSpriteNode
            let shotTemp = shot.copyWithPhysicsBody()
            shotTemp.position = hero.position
            shotTemp.position.y += 50
            addChild(shotTemp)
            
            // change duration of the time
            let action = SKAction.moveByX(0.0, y: 100, duration: 0.08)
            shotTemp.runAction(SKAction.repeatActionForever(action))
           // shotTemp.runAction(SKAction.playSoundFileNamed("shot1.wav", waitForCompletion: false))
        }
    }
}
