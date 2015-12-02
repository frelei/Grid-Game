//
//  MainViewController.swift
//  Grid
//
//  Created by Rodrigo Leite on 01/12/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {

    
    let paddleScene = PaddleScene(fileNamed: "PaddleScene")
    let jumpScene = JumpScene(fileNamed: "JumpScene")
    
    
    // MARK: VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        
        // Load paddle
//        paddleScene!.scaleMode = .Fill
//        skView.presentScene(paddleScene)
        
        // Load jump
        jumpScene?.scaleMode = .AspectFit
        skView.presentScene(jumpScene)
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
