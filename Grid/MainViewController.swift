//
//  MainViewController.swift
//  Grid
//
//  Created by Rodrigo Leite on 01/12/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit


protocol SKViewDelegate{
    func playerLoose(skView: SKScene)
    func playerLevelUp(skView: SKScene)
}


class MainViewController: UIViewController, SKViewDelegate {

    
    
    var level: Float = 0
    let paddleSceneName = "PaddleScene"
    let jumpSceneName = "JumpScene"
    
    var paddleScene: PaddleScene!
    var jumpScene: JumpScene!
//    let asteroidScene = AsteroidScene(fileNamed: "AsteroidScene")
    
    var skView: SKView!
    
    // MARK: VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = self.view as? SKView
        // Debug
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        // Load Scenes
        paddleScene = PaddleScene(fileNamed: paddleSceneName)
        jumpScene = JumpScene(fileNamed: jumpSceneName)
    
        jumpScene.skViewDelegate = self
        paddleScene.skViewDelegate = self
        
        // Load paddle
        paddleScene.scaleMode = .AspectFit
        skView.presentScene(paddleScene)
        
        jumpScene.scaleMode = .AspectFit

        // Load Asteroid
//        asteroidScene?.scaleMode = .AspectFill
//        skView!.presentScene(asteroidScene)
    }

    func playerLoose(skView: SKScene){
        print(skView.name)
        if skView.name == paddleSceneName{
              jumpScene = JumpScene(fileNamed: jumpSceneName)
              jumpScene.skViewDelegate =  self
              jumpScene.scaleMode = .AspectFit
            self.skView.presentScene(jumpScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else{
             paddleScene = PaddleScene(fileNamed: paddleSceneName)
             paddleScene.skViewDelegate = self
             paddleScene.scaleMode = .AspectFit
            self.skView.presentScene(paddleScene, transition: SKTransition.doorwayWithDuration(0.5))

        }
        
    }
    
    func playerLevelUp(skView: SKScene){
        print("Level up")

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
