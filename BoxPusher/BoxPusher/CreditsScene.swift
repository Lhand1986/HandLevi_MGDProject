//
//  CreditsScene.swift
//  BoxPusher
//
//  Created by Levi Hand on 7/27/16.
//  Copyright © 2016 Levi Hand. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {
    
    
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
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    /* This function will handle the actual body of the work behind user touches
     applies the case to the DPad enumeration and calls the appropriate movement
     function. */
    func updateTouches(touches: Set<UITouch>) {
        for touch in touches {
            //            lastTouch = touch.locationInNode(self)
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if let nodeTouch = node.name {
                print(nodeTouch)
                userSelect(String(nodeTouch))
                //                touchedNode = nodeTouch
                //                if nodeTouch == "L" {
                //                    moveAction(DPad.L.move, sprite: heroNode, speed: DPad.L.speed)
                //                    scoreTrack()
                //                } else if nodeTouch == "R" {
                //                    moveAction(DPad.R.move, sprite: heroNode, speed: DPad.L.speed)
                //                    scoreTrack()
                //                } else if nodeTouch == "U" {
                //                    moveAction(DPad.U.move, sprite: heroNode, speed: DPad.L.speed)
                //                    scoreTrack()
                //                } else if nodeTouch == "D" {
                //                    moveAction(DPad.D.move, sprite: heroNode, speed: DPad.L.speed)
                //                    scoreTrack()
                //                } else if nodeTouch == "pauseLabel" {
                //                    pause()
                //                    childNodeWithName("dPadMain")?.hidden = !(childNodeWithName("dPadMain")?.hidden)!
                //                } else if nodeTouch == "replayButton" {
                //                    restartGame()
                //                }
            }
        }
    }
    
    //MARK: User Defined Functions
    
    /* Create a function that will call the game scene again using the same
     method as the View Controller */
    func userSelect(name: String) {
        if name == "BackButton" {
            if let scene = MenuScene(fileNamed:"MenuScene")     {sceneLoad(scene)}
        }
    }
    func sceneLoad(scene: SKScene) {
        let skView = self.scene!.view! as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
}
