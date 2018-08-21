//
//  SpriteComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {

    let node: SKSpriteNode
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }
    
    func updateTexture(texture: SKTexture) {
        node.texture = texture
        node.size = texture.size()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
