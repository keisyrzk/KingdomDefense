//
//  TowerPicker.swift
//  KingdomDefense
//
//  Created by Esteban on 17.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class TowerPicker {
    
    let entityManager: EntityManager
    
    var pickerTowers: [GKEntity] = []
    var isVisible: Bool = false
    
    let shape = CustomShape(imageName: "towerPickerBackground")
    
    init(entityManager: EntityManager) {

        self.entityManager = entityManager
    }
    
    func show(location: CGPoint, tile: TileModel) {
        
        isVisible = true
        
        if let spriteComponent = shape.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = location
            spriteComponent.node.zPosition = 9
            spriteComponent.node.size = CGSize(width: 400, height: 400)
        }
        entityManager.add(entity: shape)
        
        let p1 = location - CGPoint(x: -100, y: 0)
        let p2 = location - CGPoint(x: 100, y: 0)
        let p3 = location - CGPoint(x: -50, y: 120)
        let p4 = location - CGPoint(x: -50, y: -120)
        let p5 = location - CGPoint(x: 50, y: 120)
        let p6 = location - CGPoint(x: 50, y: -120)
        
        let positions: [CGPoint] = [p1,
                                    p2,
                                    p3,
                                    p4,
                                    p5,
                                    p6]
        
        if tile.type == .Constructed {
            
                if let fireComponent = entityManager.getFireComponent(at: location), let humanCastle = entityManager.getCastle() {
                    
                    if fireComponent.towerLevel + 1 <= 4 && humanCastle.coins >= fireComponent.towerType.cost() {
                        let tower = Tower(towerType: fireComponent.towerType,
                                          towerLevel: fireComponent.towerLevel + 1,
                                          entityManager: entityManager,
                                          isFireEnabled: false)
                        if let spriteComponent = tower.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.position = positions[0]
                            spriteComponent.node.zPosition = 10
                        }
                        entityManager.add(entity: tower, scale: 0.5)
                        pickerTowers.append(tower)
                    }
            }
        }
        else if tile.type == .ConstructionField {
            
            for idx in 1 ... 6 {
                
                if let towerType = Tower.TowerType(rawValue: idx), let humanCastle = entityManager.getCastle() {
                    if humanCastle.coins >= towerType.cost() {
                        
                        let tower = Tower(towerType: towerType,
                                          entityManager: entityManager,
                                          isFireEnabled: false)
                        if let spriteComponent = tower.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.position = positions[idx - 1]
                            spriteComponent.node.zPosition = 10
                        }
                        entityManager.add(entity: tower, scale: 0.5)
                        pickerTowers.append(tower)
                    }
                }
            }
        }
    }
    
    func hide() {
        pickerTowers.forEach { (tower) in
            entityManager.remove(entity: tower)
        }
        pickerTowers = []
        entityManager.remove(entity: shape)
        isVisible = false
    }
    
    func doAction(point: CGPoint, selected: (FireComponent) -> Void, dismiss: () -> Void) {
        
        let spriteComponents = pickerTowers.compactMap{ $0.component(ofType: SpriteComponent.self) }
        if let spriteWithPoint = (spriteComponents.filter{ $0.node.frame.contains(point) }).first {
            if let fireComponent = spriteWithPoint.entity?.component(ofType: FireComponent.self) {
                selected(fireComponent)
            }
        }
        else {
            dismiss()
        }
    }
}
