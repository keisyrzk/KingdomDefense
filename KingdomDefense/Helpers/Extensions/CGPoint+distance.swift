//
//  CGPoint+distance.swift
//  KingdomDefense
//
//  Created by Esteban on 13.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(to: CGPoint) -> CGFloat {
        return sqrt((self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y))
    }

    func normalized() -> CGPoint {
        return self / sqrt(x*x + y*y)
    }
    
    var angle: CGFloat {
        return atan2(y, x)
    }
}
