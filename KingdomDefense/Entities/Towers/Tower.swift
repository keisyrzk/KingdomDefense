//
//  Tower.swift
//  KingdomDefense
//
//  Created by Esteban on 16.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class Tower: GKEntity {
    
    static let towerCost: [TowerType : Int] = [.Simple: 50,
                                                .Toxic: 80,
                                                .Cannon: 100,
                                                .Plasma: 120,
                                                .Ballistic: 150,
                                                .MagmaCannon: 200]
    
    static let towerDamage: [TowerType : CGFloat] = [.Simple: 10,
                                                     .Toxic: 30,
                                                     .Cannon: 20,
                                                     .Plasma: 40,
                                                     .Ballistic: 50,
                                                     .MagmaCannon: 60]
    
    static let towerSpeed: [TowerType : CGFloat] = [.Simple: 1.6,
                                                    .Toxic: 1.6,
                                                    .Cannon: 2.0,
                                                    .Plasma: 2.0,
                                                    .Ballistic: 1.8,
                                                    .MagmaCannon: 2.2]
    
    static let towerRange: [TowerType : CGFloat] = [.Simple: 400,
                                                     .Toxic: 350,
                                                     .Cannon: 300,
                                                     .Plasma: 300,
                                                     .Ballistic: 280,
                                                     .MagmaCannon: 280]
    
    enum TowerType: Int {
        case Simple = 1
        case Cannon = 2
        case Plasma = 3
        case Toxic = 4
        case Ballistic = 5
        case MagmaCannon = 6
    }
    
    init(towerType: TowerType, entityManager: EntityManager, isFireEnabled: Bool = true) {
        super.init()
        
        let texture = SKTexture(imageNamed: "Tower\(towerType.rawValue)_1")
        let spriteComponent = SpriteComponent(texture: texture)
        spriteComponent.node.zPosition = 5
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: .HumanTeam))
        addComponent(FireComponent(towerType: towerType,
                                   entityManager: entityManager,
                                   isFireEnabled: isFireEnabled))
    }
    
    init(towerType: TowerType, towerLevel: CGFloat, entityManager: EntityManager, isFireEnabled: Bool = true) {
        super.init()
        
        let texture = SKTexture(imageNamed: "Tower\(towerType.rawValue)_\(towerLevel)")
        let spriteComponent = SpriteComponent(texture: texture)
        spriteComponent.node.zPosition = 5
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: .HumanTeam))
        addComponent(FireComponent(towerType: towerType,
                                    towerLevel: towerLevel,
                                    entityManager: entityManager,
                                    isFireEnabled: isFireEnabled))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
