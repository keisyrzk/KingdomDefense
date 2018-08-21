//
//  TeamComponent.swift
//  KingdomDefense
//
//  Created by Esteban on 10.08.2018.
//  Copyright © 2018 Selfcode. All rights reserved.
//

import SpriteKit
import GameplayKit

//define whether the entity belongs to team_1 or team_2

enum Team: Int {
    case HumanTeam = 1
    case AITeam = 2
    
    static let allValues = [HumanTeam, AITeam]
    
    func oppositeTeam() -> Team {
        switch self {
        case .HumanTeam:
            return .AITeam
        case .AITeam:
            return .HumanTeam
        }
    }
}

class TeamComponent: GKComponent {
    
    let team: Team
    
    init(team: Team) {
        self.team = team
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
