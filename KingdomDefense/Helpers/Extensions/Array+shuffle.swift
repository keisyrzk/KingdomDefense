//
//  Array+shuffle.swift
//  KingdomDefense
//
//  Created by Esteban on 20.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}
