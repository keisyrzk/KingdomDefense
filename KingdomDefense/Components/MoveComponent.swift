//
//  MoveComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 13.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class MoveComponent: GKAgent2D, GKAgentDelegate {
    
    let entityManager: EntityManager
    let path: GKPath
    
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
        
        self.entityManager = entityManager
        path = entityManager.scene.level.getRandomPath()
        super.init()
        delegate = self
        
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // update the agents position
    func agentWillUpdate(_ agent: GKAgent) {
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2(Float(spriteComponent.node.position.x),
                          Float(spriteComponent.node.position.y))
    }
    
    // update the sprites position to follow the agent
    func agentDidUpdate(_ agent: GKAgent) {
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(x: CGFloat(position.x),
                                                y: CGFloat(position.y))
    }
    
    // find the closest move component (closest enemy)
    func closestMoveComponent(for team: Team) -> GKAgent2D? {
        
        var closestMoveComponent: MoveComponent? = nil
        var closestDistance = CGFloat(0)
        
        let enemyMoveComponents = entityManager.getMoveComponents(for: team)
        for enemyMoveComponent in enemyMoveComponents {
            
            let distance = CGPoint(x: CGFloat(enemyMoveComponent.position.x), y: CGFloat(enemyMoveComponent.position.y)).distance(to: CGPoint(x: CGFloat(position.x), y: CGFloat(position.y)))
            if closestMoveComponent == nil || distance < closestDistance {
                closestMoveComponent = enemyMoveComponent
                closestDistance = distance
            }
        }
        return closestMoveComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let entity = entity,
            let teamComponent = entity.component(ofType: TeamComponent.self) else {
                return
        }
        
        guard let enemyMoveComponent = closestMoveComponent(for: teamComponent.team.oppositeTeam()) else {
            return
        }
        
        behavior = MoveBehavior(path: path, targetSpeed: maxSpeed, seek: enemyMoveComponent)
    }
}
