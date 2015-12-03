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
    let shotterSceneName = "ShotterScene"
    
    var paddleScene: PaddleScene!
    var jumpScene: JumpScene!
    var shotterScene: ShotterScene!
    
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
        paddleScene.skViewDelegate = self
        paddleScene.scaleMode = .AspectFit
        skView.presentScene(paddleScene)
        
        // Test
//        shotterScene = ShotterScene(fileNamed: shotterSceneName)
//        shotterScene.skDelegate = self
//        shotterScene.scaleMode = .AspectFill
//        skView.presentScene(shotterScene)

    }

    func playerLoose(skView: SKScene){
        self.changeScene(skView.name!)
        
    }
    
    func playerLevelUp(skView: SKScene){
        self.changeScene(skView.name!)

    }

    func changeScene(sceneName: String){
        if sceneName == paddleSceneName{
            jumpScene = JumpScene(fileNamed: jumpSceneName)
            jumpScene.skViewDelegate =  self
            jumpScene.scaleMode = .AspectFit
            self.skView.presentScene(jumpScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else if sceneName == jumpScene{
            shotterScene = ShotterScene(fileNamed: shotterSceneName)
            shotterScene.skDelegate = self
            shotterScene.scaleMode = .AspectFill
            self.skView.presentScene(shotterScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else {
            paddleScene = PaddleScene(fileNamed: paddleSceneName)
            paddleScene.skViewDelegate = self
            paddleScene.scaleMode = .AspectFit
            self.skView.presentScene(paddleScene, transition: SKTransition.doorwayWithDuration(0.5))
        }
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
