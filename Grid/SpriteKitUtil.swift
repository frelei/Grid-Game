//
//  SpriteKitUtil.swift
//  Grid
//
//  Created by Rodrigo Leite on 12/1/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import Foundation
import SpriteKit

struct Category: OptionSetType {
    
    internal let rawValue : Int
    internal init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let WORLD        = Category(rawValue: Int(1 << 1))
    static let BALL         = Category(rawValue: Int(1 << 2))
    static let PADDLE       = Category(rawValue: Int(1 << 3))
    static let BLOCK        = Category(rawValue: Int(1 << 4))
    static let ENEMY        = Category(rawValue: Int(1 << 5))
    static let HERO         = Category(rawValue: Int(1 << 6))
    static let WALL_BOTTOM  = Category(rawValue: Int(1 << 7))
    static let WALL_RIGHT   = Category(rawValue: Int(1 << 8))
    static let WALL_LEFT    = Category(rawValue: Int(1 << 9))
    static let WALL_UP      = Category(rawValue: Int(1 << 10))
}

extension SKScene{
    
    
    func borderCollision(){
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = UInt32(Category.WORLD.rawValue)
        
    }
    
}

extension SKSpriteNode
{
    func copyWithPhysicsBody()->SKSpriteNode
    {
        let node = self.copy() as! SKSpriteNode;
        node.physicsBody = self.physicsBody?.copy() as? SKPhysicsBody;
        return node;
    }
}
