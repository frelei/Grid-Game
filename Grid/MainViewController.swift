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
    func sceneDidEnd(skView: SKScene)
}


class MainViewController: UIViewController, SKViewDelegate {

    var level: Float = 150
    let paddleSceneName = "PaddleScene"
    let jumpSceneName = "JumpScene"
    let shotterSceneName = "ShotterScene"
    let startSceneName = "StartScene"
    let transitionSceneName = "TransitionSceneName"
    
    var paddleScene: PaddleScene!
    var jumpScene: JumpScene!
    var shotterScene: ShotterScene!
    var startScene: StartScene!
    var transitionScene: TransitionScene!
    
    var currentScene: String?
    
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
        paddleScene.level = 200
        paddleScene.skViewDelegate = self
        paddleScene.scaleMode = .AspectFit
        skView.presentScene(paddleScene)
        
        
        
        
        // Test
//        shotterScene = ShotterScene(fileNamed: shotterSceneName)
//        shotterScene.skDelegate = self
//        shotterScene.scaleMode = .AspectFill
//        skView.presentScene(shotterScene)

    }

    // MARK: DELEGATE LOGIC
    func playerLoose(skView: SKScene){
        self.currentScene = skView.name
        self.level *= 1.05
        // TODO: Check Lives
        self.transitionScene = TransitionScene(fileNamed: transitionSceneName)
        self.transitionScene.velocity = "\(self.level)"
        self.skView.presentScene(self.transitionScene, transition: SKTransition.crossFadeWithDuration(0.5))
        
    }
    
    func playerLevelUp(skView: SKScene){
        self.currentScene = skView.name
        self.level *= 1.05
        self.transitionScene = TransitionScene(fileNamed: transitionSceneName)
        self.transitionScene.velocity = "\(self.level)"
        self.skView.presentScene(self.transitionScene, transition: SKTransition.crossFadeWithDuration(0.5))    }

    
    func sceneDidEnd(skView: SKScene){
        self.changeScene(self.currentScene!)
    }
    
    
    // Logic to change scenes
    func changeScene(sceneName: String){
        if sceneName == paddleSceneName{
            jumpScene = JumpScene(fileNamed: jumpSceneName)
            jumpScene.level = Int(self.level)
            jumpScene.skViewDelegate =  self
            jumpScene.scaleMode = .AspectFit
            self.skView.presentScene(jumpScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else if sceneName == jumpSceneName{
            shotterScene = ShotterScene(fileNamed: shotterSceneName)
            shotterScene.level = Int(self.level)
            shotterScene.skDelegate = self
            shotterScene.scaleMode = .AspectFill
            self.skView.presentScene(shotterScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else {
            paddleScene = PaddleScene(fileNamed: paddleSceneName)
            paddleScene.level = Int(self.level)
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
