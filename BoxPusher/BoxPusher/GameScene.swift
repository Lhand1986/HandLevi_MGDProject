//
//  GameScene.swift
//  BoxPusher
//
//  Created by Levi Hand on 6/28/16.
//  Copyright (c) 2016 Levi Hand. All rights reserved.
//  Background sprite credit to Copyright 2013 Jordan Irwin from http://opengameart.org/content/tile

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Variables
    var goalMarks: [SKSpriteNode] = []
    var boxes: [SKSpriteNode] = []
    var player: SKSpriteNode?
    var lastTouch: CGPoint? = nil
    var touchedNode: String!
    let walkRepeat: Int = 10
    
    // DPad enumeration which handles the different movement cases
    enum DPad: Int {
        case U,D,L,R
        var direction: String {
            switch self {
            case U:
                return "U"
            case D:
                return "D"
            case L:
                return "L"
            case R:
                return "R"
            }
        }
        // Determine the necessary vector of movement for linear interpolation
        var move: (CGVector) {
            switch self {
            case U: return CGVectorMake(0, 80)
            case D: return CGVectorMake(0, -80)
            case L: return CGVectorMake(-80, 0)
            case R: return CGVectorMake(80, 0)
            }
        }
        //Add a constant for the speed, which can be modified here if changes need to be made
        var speed: NSTimeInterval {
            switch self {
            case U: return NSTimeInterval(1)
            case D: return NSTimeInterval(1)
            case L: return NSTimeInterval(1)
            case R: return NSTimeInterval(1)
            }
        }
    }
    
    
    // MARK: SKScene
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //Initialize the background sprite node and set the height and width to equal the screen
        
        let enterSound = SKAction.playSoundFileNamed("EnterStage.wav", waitForCompletion: false)
        physicsWorld.contactDelegate = self
        runAction(enterSound)
    }
    
    
    // MARK: Touch Handling
    
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
            lastTouch = touch.locationInNode(self)
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if let nodeTouch = node.name {
                touchedNode = nodeTouch
                let heroNode = childNodeWithName("heroBody") as! SKSpriteNode
                if nodeTouch == "L" {
                    moveAction(DPad.L.move, sprite: heroNode, speed: DPad.L.speed)
                } else if nodeTouch == "R" {
                    moveAction(DPad.R.move, sprite: heroNode, speed: DPad.L.speed)
                } else if nodeTouch == "U" {
                    moveAction(DPad.U.move, sprite: heroNode, speed: DPad.L.speed)
                } else if nodeTouch == "D" {
                    moveAction(DPad.D.move, sprite: heroNode, speed: DPad.L.speed)
                }
            }
        }
    }
    
    //MARK: Contact handling
    
    /* We're making certain that there is some user feedback for when the character
     comes into contact with a box that can move. It may not always be extremely
     apparent which sprites are able to move and which aren't, and the feedback
     should be valuable to the user experience. */
    func didBeginContact(contact: SKPhysicsContact) {
        let boxSound = SKAction.playSoundFileNamed("BoxTouch.wav", waitForCompletion: true)
        
        guard let firstBody = contact.bodyA.node?.name else {
            return print("FirstBodyFault")
        }
        guard let secondBody = contact.bodyB.node?.name else {
            return print("SecondBodyFault")
        }
        if firstBody == "heroBody" && secondBody == "moveBox" {
            runAction(boxSound)
        }
    }
    //MARK: User defined functions
    
    /* Create a function that takes distance, which object is moving, and how fast it's moving
     and translates that into an SKAction taken by the sprite */
    func moveAction(distance: CGVector, sprite: SKSpriteNode, speed: NSTimeInterval) {
        let move = SKAction.moveBy(distance, duration: speed)
        let walkSound = SKAction.playSoundFileNamed("Walk.wav", waitForCompletion: true)
        sprite.runAction(move)
        for _ in 0..<walkRepeat {
            runAction(walkSound)
        }
    }
}
