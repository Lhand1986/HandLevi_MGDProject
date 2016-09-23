//
//  GameViewController.swift
//  BoxPusher
//
//  Created by Levi Hand on 6/28/16.
//  Copyright (c) 2016 Levi Hand. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController {
    //Allow initialization of Singleton for GameKit utilization
    let sharedInstance = GCSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePlayer()

        //Changed the boilerplate to load the menu scene instead of going straight into the game
        if let scene = MenuScene(fileNamed:"MenuScene") {
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return .Landscape

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*Function that allows the app to check if the player is already logged into Game Center, and if not, provide a 
     way for them to do so. */
    func authenticatePlayer() {
        GKLocalPlayer.localPlayer().authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.presentViewController(ViewController!, animated: true, completion: nil)
            } else if (GKLocalPlayer.localPlayer().authenticated) {
                self.sharedInstance.enabled = true
                GKLocalPlayer.localPlayer().setDefaultLeaderboardIdentifier("BoxPusherHighScores", completionHandler: { (error) in
                    if error != nil {
                        print(error)
                    } else {
                        //Setting this so the save function knows where to save the high scores to
                        self.sharedInstance.leaderBoard = "BoxPusherHighScores"
                    }
                })
            } else {
                self.sharedInstance.enabled = false
                print(error)
            }
        }
    }
    
}
