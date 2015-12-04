//
//  StartScene.swift
//  Grid
//
//  Created by Rodrigo Leite on 12/3/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit

class StartScene: SKScene {

    var skDelegate: SKViewDelegate?
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if touchedNode.name == "StartLabel" ||
            touchedNode.name  == "StartBackground"{
                skDelegate?.sceneDidEnd(self)
        }
    }
    
}
