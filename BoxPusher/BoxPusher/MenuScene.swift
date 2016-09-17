//
//  MenuScene.swift
//  BoxPusher
//
//  Created by Levi Hand on 7/27/16.
//  Copyright © 2016 Levi Hand. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene, GKGameCenterControllerDelegate {
    
    
    //MARK: Scene
    override func didMoveToView(view: SKView) {
        
    }
    
    //MARK: Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateTouches(touches)
    }
    
    /* Utilizing the updateTouches function to select and load menu items */
    func updateTouches(touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if let nodeTouch = node.name {
                userSelect(String(nodeTouch))
            }
        }
    }
    
    //MARK: User Defined Functions
    
    /* This function determines which scene to pass through to the sceneLoad function */
    func userSelect(name: String) {
        if name == "GameStart" {if let scene = Level1(fileNamed:"GameScene"){sceneLoad(scene)}}
            else if name == "GameInstructions" {if let scene = InstructionsScene(fileNamed:"InstructionsScene"){sceneLoad(scene)}}
            else if name == "GameCredits" {if let scene = CreditsScene(fileNamed:"CreditsScene"){sceneLoad(scene)}}
            else if name == "Leaderboard" {showLeaderboard()}
        
    }
    
    //Rebuild the load function so it takes in the scene as a parameter
    func sceneLoad(scene: SKScene) {
        let skView = self.scene!.view! as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    //MARK: Game Center functionality 
    
    //This function is necessary for the GC Delegate parameters. Tells the app when the user has closed the Game Center.
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Function to bring up the leaderboard in the appropriate variety of View Controller.
    func showLeaderboard() {
        let vc = self.view?.window?.rootViewController
        let gKVC = GKGameCenterViewController()
        gKVC.gameCenterDelegate = self
        vc?.presentViewController(gKVC, animated: true, completion: nil)
    }
    
}
