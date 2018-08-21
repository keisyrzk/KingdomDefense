//
//  Arrow.swift
//  KingdomDefense
//
//  Created by Esteban on 16.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Arrow: GKEntity {
    
    init(team: Team, damage: CGFloat, entityManager: EntityManager) {
        
        super.init()
        
        let texture = SKTexture(imageNamed: "arrow")
        let spriteComponent = SpriteComponent(texture: texture)
        spriteComponent.node.zPosition = 5
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        addComponent(MeleeComponent(damage: damage, destroySelf: true, damageSpeed: 1.0, aoe: false, entityManager: entityManager))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
