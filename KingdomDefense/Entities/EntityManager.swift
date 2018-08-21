//
//  EntityManager.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    let scene: GameScene
    
    // store a collection of components
    lazy var componentSystems: [GKComponentSystem] = {
        let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        let healthSystem = GKComponentSystem(componentClass: HealthComponent.self)
        let fireSystem = GKComponentSystem(componentClass: FireComponent.self)
        let meleeSystem = GKComponentSystem(componentClass: MeleeComponent.self)
        
        return [castleSystem, moveSystem, healthSystem, fireSystem, meleeSystem]
    }()
    
    var toRemove = Set<GKEntity>()
    
    
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity, scale: CGFloat? = 1) {
        entities.insert(entity)
        
        //check if this entity has a SpriteComponent
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            if let _scale = scale {
                spriteNode.setScale(_scale)
            }
            scene.addChild(spriteNode)
        }
        
        //add it to each of the component systems
        componentSystems.forEach { (system) in
            system.addComponent(foundIn: entity)
        }
    }
    
    func remove(entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        toRemove.insert(entity) //store entities set that should be removed later
        entities.remove(entity)
    }
    
    
    func update(_ deltaTime: CFTimeInterval) {

        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }
    
    // get
    
    func getCastle() -> CastleComponent? {
        guard let castle = (entities.filter{ $0.component(ofType: TeamComponent.self) != nil && $0.component(ofType: CastleComponent.self) != nil }).first else {return nil}
        return castle.component(ofType: CastleComponent.self)
    }
    
    func getCastleHealth() -> HealthComponent? {
        guard let castle = (entities.filter{ $0.component(ofType: TeamComponent.self) != nil && $0.component(ofType: CastleComponent.self) != nil }).first else {return nil}
        return castle.component(ofType: HealthComponent.self)
    }
    
    func getFireComponent(at position: CGPoint) -> FireComponent? {
        
        let towers = getEntities(for: .HumanTeam).filter{ $0.component(ofType: CastleComponent.self) == nil }
        guard let tower = (towers.filter{ $0.component(ofType: SpriteComponent.self)?.node.position == position }).first else { return nil }
        guard let fireComponent = tower.component(ofType: FireComponent.self) else { return nil }
        return fireComponent        
    }
    
    func updateTower(at position: CGPoint) {
        
        let towers = getEntities(for: .HumanTeam).filter{ $0.component(ofType: CastleComponent.self) == nil }
        if let tower = (towers.filter{ $0.component(ofType: SpriteComponent.self)?.node.position == position }).first {
            if let fireComponent = tower.component(ofType: FireComponent.self) {
                if let humanCastle = getCastle() {
                    let updateCost = getCost(for: fireComponent)
                    if humanCastle.coins >= updateCost {
                        humanCastle.coins -= updateCost
                        fireComponent.updateTower()
                        if let spriteComponent = tower.component(ofType: SpriteComponent.self) {
                            spriteComponent.updateTexture(texture: SKTexture(imageNamed: "Tower\(fireComponent.towerType.rawValue)_\(fireComponent.towerLevel)"))
                        }
                    }
                }
            }
        }
    }
    
    func getCost(for fireComponent: FireComponent) -> Int {
        return fireComponent.towerType.cost() + 50 + Int(fireComponent.towerLevel) * 20
    }
    
    // get all entities for a given team
    func getEntities(for team: Team) -> [GKEntity] {
        
        return entities.filter{ $0.component(ofType: TeamComponent.self)?.team == team }
    }
    
    // get all movement components for a given team
    func getMoveComponents(for team: Team) -> [MoveComponent] {
        
        let entitiesToMove = getEntities(for: .AITeam)
        var moveComponents: [MoveComponent] = []
        
        entitiesToMove.forEach { (entity) in
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        
        return moveComponents
    }
    
    
    // spawn
    
    func spawnKnight() {
        let knight = Knight(team: .AITeam, entityManager: self)
        if let spriteComponent = knight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = scene.level.getStartPoint()
        }
        add(entity: knight)
    }
    
    func spawnDwarf() {
        let dwarf = Dwarf(team: .AITeam, entityManager: self)
        if let spriteComponent = dwarf.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = scene.level.getStartPoint()
        }
        add(entity: dwarf)
    }
    
    func spawnUndead() {
        let undead = Undead(team: .AITeam, entityManager: self)
        if let spriteComponent = undead.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = scene.level.getStartPoint()
        }
        add(entity: undead)
    }
}
