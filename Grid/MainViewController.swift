//
//  MainViewController.swift
//  Grid
//
//  Created by Rodrigo Leite on 01/12/15.
//  Copyright © 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

protocol SKViewDelegate{
    func playerLoose(skView: SKScene)
    func playerLevelUp(skView: SKScene)
    func sceneDidEnd(skView: SKScene)
}


class MainViewController: UIViewController, SKViewDelegate {

    // Game variables
    var level: Float = 150
    var currentScene: String? = "StartScene"// Just Hold the name of the last game
    var lives = 3
    var audioPlayer: AVAudioPlayer?
    
    // Scenes names
    let paddleSceneName = "PaddleScene"
    let jumpSceneName = "JumpScene"
    let shotterSceneName = "ShotterScene"
    let startSceneName = "StartScene"
    let transitionSceneName = "TransitionScene"
    
    // Scenes
    var paddleScene: PaddleScene!
    var jumpScene: JumpScene!
    var shotterScene: ShotterScene!
    var startScene: StartScene!
    var transitionScene: TransitionScene!
    
    // Game View
    var skView: SKView!
    
    // MARK: VC LIFE CYCLE
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        skView = self.view as? SKView
        skView.bounds = self.view.bounds
        // Debug
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        // Performance
        skView.ignoresSiblingOrder = true
        
        // Load Main Screen
        startScene = StartScene(fileNamed: startSceneName)
        startScene.skDelegate = self
        startScene.scaleMode = .Fill
        skView.presentScene(startScene)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Load Sound
        let url = NSURL(string: NSBundle.mainBundle().pathForResource("songback", ofType: "mp3")!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: url!)
        audioPlayer?.numberOfLoops = -1
        
        
        // Test
//        shotterScene = ShotterScene(fileNamed: shotterSceneName)
//        shotterScene.skDelegate = self
//        shotterScene.scaleMode = .AspectFill
//        skView.presentScene(shotterScene)

    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // MARK: DELEGATE LOGIC
    func playerLoose(skView: SKScene){
        self.currentScene = skView.name
        self.level *= 1.05
        lives -= 1
        if lives <= 0{
            lives = 3
            currentScene = "StartScene"// Just Hold the name of the last game

            audioPlayer?.stop()
            self.level = 150
            self.startScene = StartScene(fileNamed: startSceneName)
            self.startScene.skDelegate = self
            self.startScene.scaleMode = .Fill
            self.skView.presentScene(startScene)
        }else{
            self.transitionScene = TransitionScene(fileNamed: transitionSceneName)
            self.transitionScene.size = self.skView.bounds.size
            self.startScene.scaleMode = .Fill
            self.transitionScene.skDelegate = self
            self.transitionScene.velocity = "\(self.level)"
            self.skView.presentScene(self.transitionScene, transition: SKTransition.crossFadeWithDuration(0.5))
        }
    }
    
    func playerLevelUp(skView: SKScene){
        self.currentScene = skView.name
        self.level *= 1.05
        self.transitionScene = TransitionScene(fileNamed: transitionSceneName)
        self.transitionScene.size = self.skView.bounds.size
        self.startScene.scaleMode = .Fill
        self.transitionScene.skDelegate = self
        self.transitionScene.velocity = "\(self.level)"
        self.skView.presentScene(self.transitionScene, transition: SKTransition.crossFadeWithDuration(0.5))
    }

    
    func sceneDidEnd(skView: SKScene){
        self.changeScene(self.currentScene!)
    }
    
    
    // Logic to change scenes
    func changeScene(sceneName: String){
        if sceneName == startSceneName{
            audioPlayer?.play()
            jumpScene = JumpScene(fileNamed: jumpSceneName)
            jumpScene.view?.bounds = self.view.bounds
            jumpScene.level = Int(self.level)
            jumpScene.skViewDelegate =  self
            jumpScene.scaleMode = .Fill
            self.skView.presentScene(jumpScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else if sceneName == paddleSceneName{
            jumpScene = JumpScene(fileNamed: jumpSceneName)
            jumpScene.view?.bounds = self.view.bounds
            jumpScene.level = Int(self.level)
            jumpScene.skViewDelegate =  self
            jumpScene.scaleMode = .Fill
            self.skView.presentScene(jumpScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else if sceneName == jumpSceneName{
            shotterScene = ShotterScene(fileNamed: shotterSceneName)
            shotterScene.view?.bounds = self.view.bounds
            shotterScene.level = Int(self.level)
            shotterScene.skDelegate = self
            shotterScene.scaleMode = .Fill
            self.skView.presentScene(shotterScene, transition: SKTransition.doorwayWithDuration(0.5))
        }else {
            paddleScene = PaddleScene(fileNamed: paddleSceneName)
            paddleScene.view?.bounds = self.view.bounds
            paddleScene.level = Int(self.level)
            paddleScene.skViewDelegate = self
            paddleScene.scaleMode = .Fill
            self.skView.presentScene(paddleScene, transition: SKTransition.doorwayWithDuration(0.5))
        }
    }
}
