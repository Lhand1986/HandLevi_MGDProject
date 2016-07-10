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
    
    
    // MARK: SKScene
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //Initialize the background sprite node and set the height and width to equal the screen
        let background = SKSpriteNode(imageNamed: "tile_aqua")
        background.size.height = frame.size.height
        background.size.width = frame.size.width
        
        physicsWorld.contactDelegate = self
        
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //Set the box sprites. The scaling has been turned off for this initial demonstration
//        let box1Sprite = SKSpriteNode(imageNamed: "box1")
//        box1Sprite.xScale = 0.5
//        box1Sprite.yScale = 0.5
//        let box2Sprite = SKSpriteNode(imageNamed: "box2")
//        box2Sprite.xScale = 0.5
//        box2Sprite.yScale = 0.5
//        let box3Sprite = SKSpriteNode(imageNamed: "box3")
//        box3Sprite.xScale = 0.5
//        box3Sprite.yScale = 0.5
    
        /*The hero's sprites are initialized here. We are going to use the sprite body and add the limbs on with 
         physics joints to allow movement of the joints contextually. */
//        let heroSprite = SKSpriteNode(imageNamed: "heroBody")
//        heroSprite.name = "heroBody"
//        heroSprite.physicsBody = SKPhysicsBody(rectangleOfSize: heroSprite.frame.size)
//        heroSprite.physicsBody!.dynamic = false
//        heroSprite.anchorPoint = CGPointMake(0,0)
//        let heroArmLegSprite = SKSpriteNode(imageNamed: "heroLimbs")
//        heroArmLegSprite.name = "heroLimbs"
//        heroArmLegSprite.physicsBody = SKPhysicsBody(rectangleOfSize: heroArmLegSprite.frame.size)
//        heroArmLegSprite.physicsBody!.dynamic = false
        
//        var joint = SKPhysicsJointPin.jointWithBodyA(heroSprite.physicsBody, bodyB: heroArmLegSprite.physicsBody, anchor: CGPoint(x: CGRectGetMaxX(self.heroSprite.frame), y: CGRectGetMinY(self.heroArmLegSprite.frame)))
//        let joint = SKPhysicsJointPin.jointWithBodyA(heroSprite.physicsBody!, bodyB: heroArmLegSprite.physicsBody!, anchor: CGPoint(x: 10, y: 10))
//        
//        //Setting the positions for all of the sprites for the purposes of this demonstration
//        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
//        box1Sprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
//        box2Sprite.position = CGPoint(x: (box1Sprite.position.x), y: (box1Sprite.position.y + 100))
//        box3Sprite.position = CGPoint(x: (box1Sprite.position.x), y: (box1Sprite.position.y - 100))
//        heroSprite.position = CGPoint(x: (box1Sprite.position.x + 100), y: (box1Sprite.position.y))
//        heroArmLegSprite.position = CGPoint(x: (box1Sprite.position.x - 100), y: (box1Sprite.position.y))
//        
//        self.addChild(background)
//        self.addChild(box1Sprite)
//        self.addChild(box2Sprite)
//        self.addChild(box3Sprite)
//        self.addChild(heroSprite)
//        self.addChild(heroArmLegSprite)
        
//        let joint = SKPhysicsJointPin.jointWithBodyA(heroSprite.physicsBody!, bodyB: heroArmLegSprite.physicsBody!, anchor: CGPoint(x: CGRectGetMaxX(heroSprite.frame), y: CGRectGetMinY(heroArmLegSprite.frame)))
        
//        self.physicsWorld.addJoint(joint)
        
    }
    
    // MARK: Touch Handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            //Setting the ability to denote what object is being touched
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            let enterAction = SKAction.playSoundFileNamed("EnterStage.wav", waitForCompletion: true)
            let exitAction = SKAction.playSoundFileNamed("ExitStage.wav", waitForCompletion: true)
            if let name = node.name {
                if name == "heroBody" {
                    runAction(enterAction)
                }
                if name == "heroLimbs" {
                    runAction(exitAction)
                }
            }
        }
    }
    
    //MARK: Updates
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //MARK: SKPhysicsContactDelegate
    
    //MARK: User defined functions
    
    
    
    
    
    
    
    
}
