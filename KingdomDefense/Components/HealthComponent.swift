//
//  HealthComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 16.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    
    let fullHealth: CGFloat
    var health: CGFloat
    let healthBarFullWidth: CGFloat
    let healthBar: SKShapeNode
    let entityManager: EntityManager
    let unit: Level.Unit
    
    init(parentNode: SKNode, barWidth: CGFloat, barOffset: CGFloat, health: CGFloat, unit: Level.Unit = .None, entityManager: EntityManager) {
        
        self.unit = unit
        self.fullHealth = health
        self.health = health
        self.entityManager = entityManager
        
        healthBarFullWidth = barWidth
        healthBar = SKShapeNode(rectOf:
            CGSize(width: healthBarFullWidth, height: 5), cornerRadius: 1)
        healthBar.fillColor = UIColor.green
        healthBar.strokeColor = UIColor.green
        healthBar.position = CGPoint(x: 0, y: barOffset)
        parentNode.addChild(healthBar)
        
        healthBar.isHidden = true
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult func takeDamage(_ damage: CGFloat) -> Bool {
        health = max(health - damage, 0)
        
        healthBar.isHidden = false
        let healthScale = health/fullHealth
        let scaleAction = SKAction.scaleX(to: healthScale, duration: 0.5)
        healthBar.run(SKAction.group([scaleAction]))
        
        if health == 0 {
            if let entity = entity {
                // Never remove the castle
                let castleComponent = entity.component(ofType: CastleComponent.self)
                if castleComponent == nil {
                    entityManager.remove(entity: entity)
                }
            }
            
            if let humanCastle = entityManager.getCastle() {
                switch unit {
                case .Knight:
                    humanCastle.coins += 30
                case .Dwarf:
                    humanCastle.coins += 50
                case .Undead:
                    humanCastle.coins += 70
                    
                default:
                    break
                }
            }

        }
        
        return health == 0
    }
    
}
