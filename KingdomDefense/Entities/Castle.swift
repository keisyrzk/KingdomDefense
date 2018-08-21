//
//  Castle.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class Castle: GKEntity {
        
    init(imageName: String, entityManager: EntityManager) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.zPosition = 5
        addComponent(spriteComponent)
        
        addComponent(TeamComponent(team: .HumanTeam))
        addComponent(CastleComponent())
        
        // let the castle be considered as a non-moving enemy
        if let _texture = spriteComponent.node.texture {
            addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(_texture.size().width/2), entityManager: entityManager))
        }
        
        addComponent(HealthComponent(parentNode: spriteComponent.node,
                                     barWidth: spriteComponent.node.size.width,
                                     barOffset: spriteComponent.node.size.height/2,
                                     health: 500,
                                     entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
