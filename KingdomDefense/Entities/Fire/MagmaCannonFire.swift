//
//  MagmaCannonFire.swift
//  KingdomDefense
//
//  Created by Esteban on 20.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MagmaCannonFire: GKEntity {
    
    init(team: Team, damage: CGFloat, entityManager: EntityManager) {
        
        super.init()
        
        let texture = SKTexture(imageNamed: "magma1")
        let spriteComponent = SpriteComponent(texture: texture)
        spriteComponent.node.zPosition = 5
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        addComponent(MeleeComponent(damage: damage, destroySelf: true, damageSpeed: 1.5, aoe: false, entityManager: entityManager))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
