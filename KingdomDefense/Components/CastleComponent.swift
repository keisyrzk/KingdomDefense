//
//  CastleComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class CastleComponent: GKComponent {
    
    var coins = 200
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
