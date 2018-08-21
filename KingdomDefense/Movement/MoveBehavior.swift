//
//  MoveBehavior.swift
//  KingdomDefense
//
//  Created by Esteban on 13.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class MoveBehavior: GKBehavior {
    
    init(path: GKPath, targetSpeed: Float, seek: GKAgent) {
        super.init()
        
        if targetSpeed > 0 {
            
            setWeight(1.0, for: GKGoal(toFollow: path, maxPredictionTime: 0.5, forward: true))
//            setWeight(0.5, for: GKGoal(toSeekAgent: seek))
            setWeight(0.9, for: GKGoal(toReachTargetSpeed: targetSpeed))
        }
    }
}
