//
//  GameScene.swift
//  BoxPusher
//
//  Created by Levi Hand on 6/28/16.
//  Copyright (c) 2016 Levi Hand. All rights reserved.
//  Background sprite credit to Copyright 2013 Jordan Irwin from http://opengameart.org/content/tile

import SpriteKit
import GameKit

class BaseScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    //Allow initialization of Singleton for GameKit utilization
    let sharedInstance = GCSingleton.sharedInstance
    
    // MARK: Variables
    var lastTouch: CGPoint? = nil
    var touchedNode: String!
    var movesCounter: Int = 0
    var scoreCount: Int = 0
    var winCondition: Int = 1000
    var loseCondition: Int = 2000
    var changeScale : CGFloat!
    var lastTime: NSTimeInterval = 0
    
    // MARK: Node variable declaration
    var boundingNodes =     [SKNode()]
    var moveBoxNodes =      [SKNode()]
    var dPadNode =          SKNode()
    var winNodes =          [SKNode()]
    var winBlock =          SKNode()
    var heroNode =          SKSpriteNode()
    var goalMarks:          [SKSpriteNode] = []
    var boxes:              [SKSpriteNode] = []
    var player:             SKSpriteNode?
    var winLoseMessage =    SKLabelNode()
    var movesCounterLabel:  SKLabelNode!
    var labelNodes =        [SKLabelNode()]
    var boxAnimate =        SKSpriteNode()
    var poofAnimation:      SKAction!
    let walkRepeat: Int = 10
    let sheet = poof()
    
    // MARK: Game Center Variables
    var hsNotification:     SKLabelNode!
    var hsButton:           SKLabelNode!
    
    // MARK: Sound initialization
    let boxSound = SKAction.playSoundFileNamed("BoxTouch.wav", waitForCompletion: true)
    let walkSound = SKAction.playSoundFileNamed("Walk.wav", waitForCompletion: true)
    let enterSound = SKAction.playSoundFileNamed("EnterStage.wav", waitForCompletion: false)
    let exitSound = SKAction.playSoundFileNamed("ExitStage.wav", waitForCompletion: true)
    
    
    // MARK: IAD Power-up variables
    var powerUpStart: Bool = false
    let powerUpSel: [String] = ["teleport", "jump"]
    var powerUpNode = SKSpriteNode()
    var power: String!
    
    // Declaration of SKActions for the jump sequence
    let jumpMoveS = SKAction.moveToX(288, duration: 0.25)
    let jumpMoveM = SKAction.moveToX(338, duration: 0.25)
    let jumpMoveF = SKAction.moveToX(350, duration: 0.25)
    let jumpScaleUp = SKAction.scaleTo(2, duration: 0.25)
    let jumpScaleDown = SKAction.scaleTo(1, duration: 0.25)
    var scaleSequence = SKAction()
    
    //Declaration of SKAction for the teleportation powerup
    let teleport = SKAction.moveTo(CGPoint(x: 490, y: 432), duration: 0.1)
    
    //Initializing variable to hold the hole sprite
    var holeBlock = SKSpriteNode()
    
    //Declaration of SKActions to fall down the hole
    let holeMove = SKAction.moveToX(290, duration: 0.25)
    let holeFall = SKAction.scaleBy(0.01, duration: 3)
    var fallSequence = SKAction()
    
    //Set boolean for the fall sequence end
    var fallBool = false
    
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
        sharedInstance.gcLoadAchievements()
        sharedInstance.getPUDefault()
        // Reset score total
        score = 0
        //Initialize an animation for the sprite atlas
        poofAnimation = SKAction.animateWithTextures(sheet.poof(), timePerFrame: 0.15)
        
        //Initializing the scale sequence to allow the hero to jump
        scaleSequence = SKAction.sequence([jumpMoveS, jumpScaleUp, jumpMoveM, jumpScaleDown, jumpMoveF])
        
        //Initializing the sequence to cause the hero to fall down the hole
        fallSequence = SKAction.sequence([holeMove, holeFall])
        /* Changed declaration of node from inside a function to being loaded with the view
         for memory allocation purposes
        Add nodes onscreen to specific arrays for utilization in different code structures */
        enumerateChildNodesWithName("//*", usingBlock: {(node, stop) -> Void in
            if      node.name == "moveBox"      {self.moveBoxNodes.append(node)}
            else if node.name == "mazeBox"      {self.boundingNodes.append(node)}
            else if node.name == "pauseLabel"   {self.labelNodes.append(node as! SKLabelNode)}
            else if node.name == "movesLabel"   {self.labelNodes.append(node as! SKLabelNode)}
            else if node.name == "movesCounter" {self.labelNodes.append(node as! SKLabelNode)}
            else if node.name == "pointBox"     {self.winNodes.append(node)}
        })
        
        //Declaring nodes that don't fit into the previous enumeration
        movesCounterLabel = childNodeWithName("movesCounter") as! SKLabelNode
        heroNode = childNodeWithName("heroBody") as! SKSpriteNode
        winLoseMessage = childNodeWithName("winBlock")?.childNodeWithName("winNotification") as! SKLabelNode
        boxAnimate = childNodeWithName("boxPlace") as! SKSpriteNode
        powerUpNode = childNodeWithName("powerUp") as! SKSpriteNode
        holeBlock = childNodeWithName("holeBlock") as! SKSpriteNode
        
        //Declaring GameCenter nodes
        hsNotification = childNodeWithName("winBlock")?.childNodeWithName("hsNotification") as! SKLabelNode
        hsButton = childNodeWithName("winBlock")?.childNodeWithName("hsButton") as! SKLabelNode
        
        //Add the win block section and set the value to hidden
        if let winScreen = childNodeWithName("winBlock") {
            winBlock = winScreen
            winBlock.hidden = true
        }
        //Removing null nodes
        moveBoxNodes.removeAtIndex(0)
        boundingNodes.removeAtIndex(0)
        labelNodes.removeAtIndex(0)
        winNodes.removeAtIndex(0)
        
        //Set the win condition max number to match the number of win nodes
        winCondition = winNodes.count
        loseCondition = 9
        
        for i in 0..<moveBoxNodes.count {
            moveBoxNodes[i].physicsBody!.mass = 0.00001
        }
        heroNode.physicsBody!.mass = 1
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            changeScale = 1.0
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            changeScale = 1.25
        }
        
        
        
        //Set the scaling of the dPad
        if let nodeName = childNodeWithName("dPadMain") {
            dPadNode = nodeName
            dPadNode.setScale(changeScale)
        }
        
        //Set the scaling of the labels
        for i in 0..<labelNodes.count {
            labelNodes[i].setScale(changeScale)
        }
        
        physicsWorld.contactDelegate = self
        runAction(enterSound)
        
        
        //Set the initial physics for the hole
        holeBlock.physicsBody = SKPhysicsBody(circleOfRadius: holeBlock.size.width / 2)
        holeBlock.physicsBody!.dynamic = true
        holeBlock.physicsBody!.affectedByGravity = false
        
        
    }
    
    
    // MARK: Touch Handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateTouches(touches)
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
                if nodeTouch == "L" {
                    moveAction(DPad.L.move, sprite: heroNode, speed: DPad.L.speed)
                    scoreTrack()
                } else if nodeTouch == "R" {
                    moveAction(DPad.R.move, sprite: heroNode, speed: DPad.L.speed)
                    scoreTrack()
                } else if nodeTouch == "U" {
                    moveAction(DPad.U.move, sprite: heroNode, speed: DPad.L.speed)
                    scoreTrack()
                } else if nodeTouch == "D" {
                    moveAction(DPad.D.move, sprite: heroNode, speed: DPad.L.speed)
                    scoreTrack()
                } else if nodeTouch == "pauseLabel" {
                    childNodeWithName("dPadMain")?.hidden = !(childNodeWithName("dPadMain")?.hidden)!
                    pause()
                    
                    //Allow the user to restart the game or go back to the main menu
                } else if nodeTouch == "replayButton" {if let scene = Level1(fileNamed:"GameScene"){sceneLoad(scene)}
                } else if nodeTouch == "QuitLabel" {if let scene = MenuScene(fileNamed:"MenuScene"){sceneLoad(scene)}
                } else if nodeTouch == "hsButton" {sharedInstance.saveHS(score)}
            }
        }
    }
    
    //MARK: Contact handling
    
    /* We're making certain that there is some user feedback for when the character
     comes into contact with a box that can move. It may not always be extremely
     apparent which sprites are able to move and which aren't, and the feedback
     should be valuable to the user experience. */
    func didBeginContact(contact: SKPhysicsContact) {
        
        guard let firstBody = contact.bodyA.node?.name else {
            return print("FirstBodyFault")
        }
        guard let secondBody = contact.bodyB.node?.name else {
            return print("SecondBodyFault")
        }
        if firstBody == "heroBody" && secondBody == "moveBox" {
            runAction(boxSound)
            
            /* Refining some of the physics of the game. Without pinning the node
             and setting the mass to a higher number, the sprite still has quite a
             bit of "squish" to it. Replacing the sprite texture with the animation
             to provide some extra user feedback for doing the right thing. Also, the
             win condition is called in this block. */
        } else if firstBody == "moveBox" && secondBody == "pointBox" {
            contact.bodyA.node!.physicsBody!.pinned = true
            contact.bodyA.node!.physicsBody!.mass = 1000
            contact.bodyA.node!.runAction(poofAnimation)
            scoreCount+=1
            score+=1
            endLevel(scoreCount, winScore: winCondition, fall: fallBool)
            
            // IAD PowerUp
            powerUpStart = true
            powerBegin()
            
            //Checking to see which powerUp has been hit, then run the appropriate action
        } else if firstBody == "heroBody" && secondBody == "teleport" {
            heroNode.runAction(teleport)
            powerUpNode.removeFromParent()
            powerUpStart = false
        } else if firstBody == "heroBody" && secondBody == "jump" {
            heroNode.runAction(scaleSequence)
            powerUpNode.removeFromParent()
            powerUpStart = false
            //Check to see if the player has fallen into the hole
        } else if firstBody == "heroBody" && secondBody == "holeBlock" {
            holeEnds()
        }
    }
    
    //MARK: Updates
    
    override func update(currentTime: NSTimeInterval) {
        
        //Check the lose condition on update
        if movesCounter >= loseCondition {
            endLevel(scoreCount, winScore: winCondition, fall: fallBool)
        }
    }
    override func didFinishUpdate() {
    }
    
    
    //MARK: User defined functions
    
    /* Create a function that takes distance, which object is moving, and how fast it's moving
     and translates that into an SKAction taken by the sprite */
    func moveAction(distance: CGVector, sprite: SKSpriteNode, speed: NSTimeInterval) {
        let move = SKAction.moveBy(distance, duration: speed)
        sprite.runAction(move)
        for _ in 0..<walkRepeat {
            runAction(walkSound)
        }
    }
    
    /* This function handles the game win condition */
    func endLevel(playerScore: Int, winScore: Int, fall: Bool) {
        if movesCounter >= loseCondition {
            winLoseMessage.text = "Too many moves!"
            winBlock.hidden = false
            hsButton.hidden = true
            hsNotification.hidden = true
            //Negative Achievement
            sharedInstance.reportAchievement("firstLoss")
        } else if playerScore == winScore {
            runAction(exitSound)
            //Completion Achievement
            sharedInstance.reportAchievement("levelOne")
            winBlock.hidden = false
        } else if fall {
            winLoseMessage.text = "You fell down the hole!"
            winBlock.hidden = false
            hsButton.hidden = true
            hsNotification.hidden = true
            //Negative Achievement
            sharedInstance.reportAchievement("firstLoss")
        }
        fallBool = false
    }
    
    /* Make a function that freezes movement, deactivates the D-Pad, allows the user to pick up
     where they left off, and resides above everything else on the HUD. */
    func pause() {
        scene!.view?.paused = !(scene!.view?.paused)!
    }
    
    /* Keep track of the amount of moves to finish per level, and overall */
    func scoreTrack() {
        movesCounter+=1
        movesCounterLabel.text = String(movesCounter)
        
        // Measurement Achievement
        if movesCounter == 5 {
            sharedInstance.reportAchievement("movingAbout")
        }
    }
    
    /* Create a function that will call the game scene again using the same 
     method as the View Controller */
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
    
    // Function to start implementation of power ups
    func powerBegin() {
        if powerUpStart {
            /*Allow for a random selection of the powerups, set the node texture accordingly, apply a physics body for contact,
             apply a name to the node for proper contact handling, and deactivate the holeBlock node*/
            power = powerUpSel[(Int(arc4random_uniform(2)))]
            powerUpNode.texture = SKTexture(imageNamed: power)
            powerUpNode.physicsBody = SKPhysicsBody(circleOfRadius: powerUpNode.size.width / 2)
            powerUpNode.physicsBody!.dynamic = true
            powerUpNode.physicsBody!.affectedByGravity = false
            powerUpNode.name = power
            holeBlock.physicsBody = nil
            //Incremental achievement
            sharedInstance.powerUpCount+=1
            if sharedInstance.powerUpCount == 1 || sharedInstance.powerUpCount == 3 || sharedInstance.powerUpCount == 5{
                sharedInstance.reportAchievement("powerUps")
            }
        }
    }
    // Function to end the game if the user hits the hole
    func holeEnds() {
        /* Deactivate the physics body for the block, so the hero sprite can pass through it, then call the fall sequence to
         cause the hero sprite to advance to the middle of the hole, then vanish, set the fallBool to true, and call the end level
         function. */
        holeBlock.physicsBody = nil
        heroNode.runAction(fallSequence)
        fallBool = true
        endLevel(scoreCount, winScore: winCondition, fall: fallBool)
    }

    
}
    

