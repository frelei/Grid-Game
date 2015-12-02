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
    
    var oldTime : NSTimeInterval = 0
    
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
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        if currentTime - oldTime > 5 {
            oldTime = currentTime
            let enemy = childNodeWithName(enemyCategoryName) as! SKSpriteNode
            let enemyTemp = enemy.copyWithPhysicsBody()
            addChild(enemyTemp)
        }
    }
    
    
    
    
    
}
