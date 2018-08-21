//
//  FireComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 16.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class FireComponent: GKComponent {
    
    let isFireEnabled: Bool
    
    let towerType: Tower.TowerType
    var towerLevel: CGFloat
    
    var range: CGFloat
    var damage: CGFloat
    var damageSpeed: CGFloat    //the less value the fastest is speed of firing
    var lastDamageTime: TimeInterval
    let entityManager: EntityManager
    
    init(towerType: Tower.TowerType, entityManager: EntityManager, isFireEnabled: Bool) {
        
        self.isFireEnabled = isFireEnabled
        self.towerLevel = 1
        self.range = 300 * (towerLevel + 1) / 2
        self.damage = 10.0 * towerLevel
        self.damageSpeed = 1.6 / towerLevel
        
        self.towerType = towerType
        self.lastDamageTime = 0
        self.entityManager = entityManager
        super.init()
    }
    
    init(towerType: Tower.TowerType, towerLevel: CGFloat, entityManager: EntityManager, isFireEnabled: Bool) {
        
        self.isFireEnabled = isFireEnabled
        self.towerLevel = towerLevel
        self.range = towerType.range() * (towerLevel + 1) / 2
        self.damage = towerType.damage() * towerLevel
        self.damageSpeed = towerType.speed() / towerLevel
        
        self.towerType = towerType
        self.lastDamageTime = 0
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTower() {
        
        towerLevel += 1
        self.range = towerType.range() * (towerLevel + 1) / 2
        self.damage = towerType.damage() * towerLevel
        self.damageSpeed = towerType.speed() / towerLevel
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        if isFireEnabled {
            
            // Get required components
            guard let teamComponent = entity?.component(ofType: TeamComponent.self),
                let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
                    return
            }
            
            // Loop through enemy entities
            let enemyEntities = entityManager.getEntities(for: teamComponent.team.oppositeTeam())
            for enemyEntity in enemyEntities {
                
                // Get required components
                guard let enemySpriteComponent = enemyEntity.component(ofType: SpriteComponent.self) else {
                    continue
                }
                
                let distance = spriteComponent.node.position.distance(to: enemySpriteComponent.node.position)
                if (CGFloat(abs(distance)) <= range && CGFloat(CACurrentMediaTime() - lastDamageTime) > damageSpeed) {
                    
                    lastDamageTime = CACurrentMediaTime()
                    
                    var fire: GKEntity!
                    
                    switch towerType {
                        
                    case .Simple:
                        fire = Arrow(team: teamComponent.team, damage: damage, entityManager: entityManager)
                    case .Cannon:
                        fire = CannonFire(team: teamComponent.team, damage: damage, entityManager: entityManager)
                    case .MagmaCannon:
                        fire = MagmaCannonFire(team: teamComponent.team, damage: damage, entityManager: entityManager)
                    case .Ballistic:
                        fire = BallisticFire(team: teamComponent.team, damage: damage, entityManager: entityManager)
                    case .Plasma:
                        fire = PlasmaFire(team: teamComponent.team, damage: damage, entityManager: entityManager)
                    case .Toxic:
                        fire = ToxicFire(team: teamComponent.team, damage: damage, entityManager: entityManager)
                    }
                    
                    
                    guard let fireSpriteComponent = fire.component(ofType: SpriteComponent.self) else {
                        continue
                    }
                    
                    fireSpriteComponent.node.position = spriteComponent.node.position
                    let direction = (enemySpriteComponent.node.position - spriteComponent.node.position).normalized()
                    let firePointsPerSecond = CGFloat(300)
                    let fireDistance = range
                    
                    let target = direction * fireDistance
                    let duration = fireDistance / firePointsPerSecond
                    
                    fireSpriteComponent.node.zRotation = direction.angle
                    fireSpriteComponent.node.zPosition = 5
                    
                    fireSpriteComponent.node.run(SKAction.sequence([
                        SKAction.moveBy(x: target.x, y: target.y, duration: TimeInterval(duration)),
                        SKAction.run() {
                            self.entityManager.remove(entity: fire)
                        }
                        ]))
                    
                    
                    switch towerType {
                        
                    case .Simple:
                        entityManager.add(entity: fire)
                    case .Cannon:
                        entityManager.add(entity: fire, scale: 0.3)
                    case .MagmaCannon:
                        entityManager.add(entity: fire, scale: 0.3)
                    case .Ballistic:
                        entityManager.add(entity: fire, scale: 0.3)
                    case .Plasma:
                        entityManager.add(entity: fire, scale: 0.3)
                    case .Toxic:
                        entityManager.add(entity: fire, scale: 0.3)
                    }
                }
                
            }
        }
    }
}
