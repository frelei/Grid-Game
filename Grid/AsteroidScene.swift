//
//  AsteroidScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 12/2/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit

class AsteroidScene: SKScene, SKPhysicsContactDelegate {

    let enemyCategoryName = "Enemy"
    let heroCategoryName = "Hero"
    let defenseCategoryName = "Defense"
    var circlePath: UIBezierPath?
    
    var oldTime : NSTimeInterval = 0
    var points: [SKAction]?
    
    // MARK: SKSCENE
    override func didMoveToView(view: SKView) {

        physicsWorld.contactDelegate = self
        
        // Get Object
        let enemy = childNodeWithName(enemyCategoryName) as! SKSpriteNode
        let hero = childNodeWithName(heroCategoryName) as! SKSpriteNode
        let defense = childNodeWithName(defenseCategoryName) as! SKSpriteNode
        
        // Add Categorie
        enemy.physicsBody?.categoryBitMask = UInt32(Category.ENEMY.rawValue)
        hero.physicsBody?.categoryBitMask = UInt32(Category.HERO.rawValue)
        defense.physicsBody?.categoryBitMask = UInt32(Category.BLOCK.rawValue)
        
        // Test Collision
        enemy.physicsBody?.contactTestBitMask = UInt32(Category.HERO.rawValue) | UInt32(Category.BLOCK.rawValue)
        
        // Colission
        enemy.physicsBody?.collisionBitMask = UInt32(Category.HERO.rawValue) | UInt32(Category.BLOCK.rawValue)
        
        
        // Bezier path
        let circle = CGRect(x: hero.position.x - 20 , y: hero.position.y - 20, width: 100, height: 100)
        circlePath = UIBezierPath(ovalInRect: circle)  //UIBezierPath(roundedRect: circle, cornerRadius: 5)
//        circlePath = UIBezierPath(arcCenter: hero.position, radius: 5, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
//        let joint = SKPhysicsJointPin.jointWithBodyA(defense.physicsBody!, bodyB: hero.physicsBody!, anchor: hero.position)
//        self.physicsWorld.addJoint(joint)
//        
        points = Array()
        let point =  hero.position
        for var i = 0; i < 180; i += 10{
            let s = sin(Double(i)) * 130
            let c = cos(Double(i)) * 130
            
            let p = CGPoint(x: CGFloat(c) + point.x, y: point.y + CGFloat(s))
            let action = SKAction.moveTo(p, duration: 1.0)
            self.points?.append(action)
            
//            let node = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 10, height: 10))
//            node.position = p
//            addChild(node)
            
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if currentTime - oldTime > 5 {
            oldTime = currentTime
            let enemy = childNodeWithName(enemyCategoryName) as! SKSpriteNode
            let enemyTemp = enemy.copyWithPhysicsBody()
            enemyTemp.position = CGPoint(x: self.frame.width , y: 50)
            addChild(enemyTemp)
        }
    }
    
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let hero = childNodeWithName(heroCategoryName)
        let defense = childNodeWithName(defenseCategoryName)
        
        let touch = touches.first
        let point = touch!.locationInView(self.view)
        let middle = self.frame.height / 2
        
        defense?.removeAllActions()
        if point.x >= middle{
 //           let action = SKAction.followPath((circlePath?.CGPath)!, duration: 3.0)
 //           rotateNode(defense, nodeB: hero)
//           let action = SKAction.rotateByAngle( CGFloat(180 / M_PI) , duration: 2.5)
           let action = SKAction.sequence(points!)
            defense?.runAction(SKAction.repeatActionForever(action))
        } else {
 //           rotateNode(defense, nodeB: hero)
 //           let action = SKAction.followPath((circlePath?.CGPath)!, duration: 3.0).reversedAction()
//            let action = SKAction.rotateByAngle( CGFloat(180 / M_PI) , duration: 2.5).reversedAction()
            let action = SKAction.sequence(points!)
            defense?.runAction(SKAction.repeatActionForever(action))
        }
    }
    
    
    func rotateNode(nodeA : SKNode, nodeB: SKNode){
        let angle = atan2(nodeB.position.y - nodeA.position.y, nodeB.position.x - nodeA.position.x)
        if (nodeA.zRotation < 0) {
            nodeA.zRotation = nodeA.zRotation + CGFloat(M_PI * 2);
        }
        let a = SKAction.repeatActionForever(SKAction.rotateToAngle(angle, duration: 0))
        nodeA.runAction(a)
//        nodeA.runAction( SKAction.rotateByAngle(angle, duration: 0) )
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
        
        if firstBody.categoryBitMask == UInt32(Category.BLOCK.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.ENEMY.rawValue){
        }
        
        if firstBody.categoryBitMask == UInt32(Category.ENEMY.rawValue) &&
            secondBody.categoryBitMask == UInt32(Category.HERO.rawValue){
                // TODO: Call delegate
                  print("Game Over")
        }
    }
    
    
    
}
