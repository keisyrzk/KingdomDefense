//
//  TowerType+getCost.swift
//  KingdomDefense
//
//  Created by Esteban on 17.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import UIKit

extension Tower.TowerType {
    
    func cost() -> Int {
        return Tower.towerCost[self] ?? 0
    }
    
    func damage() -> CGFloat {
        return Tower.towerDamage[self] ?? 0
    }
    
    func range() -> CGFloat {
        return Tower.towerRange[self] ?? 0
    }
    
    func speed() -> CGFloat {
        return Tower.towerSpeed[self] ?? 0
    }
}
