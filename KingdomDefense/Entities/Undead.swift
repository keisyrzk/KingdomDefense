//
//  Undead.swift
//  KingdomDefense
//
//  Created by Esteban on 20.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class Undead: GKEntity {
    
    init(team: Team, entityManager: EntityManager) {
        super.init()
        
        let texture = SKTexture(imageNamed: "undead")
        let spriteComponent = SpriteComponent(texture: texture)
        spriteComponent.node.size = CGSize(width: TileModel.width/4, height: TileModel.height/4)
        spriteComponent.node.zPosition = 5
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        
        if let _texture = spriteComponent.node.texture {
            addComponent(MoveComponent(maxSpeed: 40,
                                       maxAcceleration: 20,
                                       radius: Float(_texture.size().width * 0.3),
                                       entityManager: entityManager))
        }
        
        addComponent(HealthComponent(parentNode: spriteComponent.node,
                                     barWidth: spriteComponent.node.size.width,
                                     barOffset: spriteComponent.node.size.height/2,
                                     health: 500,
                                     unit: .Undead,
                                     entityManager: entityManager))
        addComponent(MeleeComponent(damage: 15.0,
                                    destroySelf: true,
                                    damageSpeed: 0.2,
                                    aoe: false,
                                    entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
