//
//  Hero.swift
//  BoxPusher
//
//  Created by Levi Hand on 7/8/16.
//  Copyright © 2016 Levi Hand. All rights reserved.
//

import SpriteKit

class Hero: SKSpriteNode {

    var upperLeftJoint = SKPhysicsJointPin()
    var upperRightJoint = SKPhysicsJointPin()
    var lowerLeftJoint = SKPhysicsJointPin()
    var lowerRightJoint = SKPhysicsJointPin()
    let heroBody = SKSpriteNode(imageNamed: "heroBody")
    
    init() {
        let texture = SKTexture(imageNamed: "heroBody")
        
        super.init(texture: texture, color: .clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
