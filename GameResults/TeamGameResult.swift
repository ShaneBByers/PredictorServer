//
//  TeamGameResult.swift
//  Predictor
//
//  Created by Shane Byers on 12/25/21.
//

import Foundation

struct TeamGameResult
{
    var team: Team
    var game: Game
    var decision: Decision
    var goals: Int
    var shots: Int
    var powerplays: Int
    var powerplayGoals: Int
    var penaltyMinutes: Int
    var blockedShots: Int
    var takeaways: Int
    var giveaways: Int
    var hits: Int
}
