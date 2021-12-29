//
//  GoalieGameResult.swift
//  Predictor
//
//  Created by Shane Byers on 12/25/21.
//

import Foundation

struct GoalieGameResult
{
    var game: Game
    var team: Team
    var player: Player
    var decision: Decision
    var timeOnIce: Time
    var totalShotsAgainst: Int
    var evenStrengthShotsAgainst: Int
    var powerplayShotsAgainst: Int
    var shorthandedShotsAgainst: Int
    var totalSaves: Int
    var evenStrengthSaves: Int
    var powerplaySaves: Int
    var shorthandedSaves: Int
}
