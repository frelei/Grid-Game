//
//  TransitionScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 12/3/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit


class TransitionScene: SKScene {

    var velocity: String?
    var velocityCategoryName = "Velocity"
    var skDelegate: SKViewDelegate?
    
    override func didMoveToView(view: SKView) {
        
        let velocityLabelNode = childNodeWithName(velocityCategoryName) as! SKLabelNode
        velocityLabelNode.text = velocity
        SKAction.playSoundFileNamed("achievement1.mp3", waitForCompletion: false)
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "endTransition:", userInfo: nil, repeats: false)
    }
    
    func endTransition(timer: NSTimer){
        timer.invalidate()
        self.skDelegate?.sceneDidEnd(self)
    }
}