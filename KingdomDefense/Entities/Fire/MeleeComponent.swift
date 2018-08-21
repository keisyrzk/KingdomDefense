//
//  MeleeComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 16.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class MeleeComponent: GKComponent {
    
    let damage: CGFloat
    let destroySelf: Bool
    let damageSpeed: CGFloat             //how often should the damge be taken
    var lastDamageTime: TimeInterval
    let aoe: Bool
    let entityManager: EntityManager
    
    init(damage: CGFloat, destroySelf: Bool, damageSpeed: CGFloat, aoe: Bool, entityManager: EntityManager) {
        self.damage = damage
        self.destroySelf = destroySelf
        self.damageSpeed = damageSpeed
        self.aoe = aoe
        self.lastDamageTime = 0
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        // Get required components
        guard let teamComponent = entity?.component(ofType: TeamComponent.self),
            let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
                return
        }
        
        // Loop through enemy entities
        var aoeDamageCaused = false
        let enemyEntities = entityManager.getEntities(for: teamComponent.team.oppositeTeam())
        for enemyEntity in enemyEntities {
            
            // Get required components
            guard let enemySpriteComponent = enemyEntity.component(ofType: SpriteComponent.self),
                let enemyHealthComponent = enemyEntity.component(ofType: HealthComponent.self) else {
                    continue
            }
            
            // Check for intersection
            if (spriteComponent.node.calculateAccumulatedFrame().intersects(enemySpriteComponent.node.calculateAccumulatedFrame())) {
                
                // Check damage rate
                if (CGFloat(CACurrentMediaTime() - lastDamageTime) > damageSpeed) {
                    
                    // Cause damage
                    if (aoe) {
                        aoeDamageCaused = true
                    } else {
                        lastDamageTime = CACurrentMediaTime()
                    }
                    
                    // Subtract health
                    enemyHealthComponent.takeDamage(damage)
                    
                    // Destroy self
                    if destroySelf {
                        entityManager.remove(entity: entity!)
                    }
                }
            }
        }
        
        if (aoeDamageCaused) {
            lastDamageTime = CACurrentMediaTime()
        }
    }
}
