//
//  SkaterGameResult.swift
//  Predictor
//
//  Created by Shane Byers on 12/25/21.
//

import Foundation

struct SkaterGameResult
{
    var game: Game
    var team: Team
    var player: Player
    var goals: Int
    var assists: Int
    var shots: Int
    var powerplayGoals: Int
    var powerplayAssists: Int
    var shorthandedGoals: Int
    var shorthandedAssists: Int
    var penaltyMinuts: Int
    var faceoffsTaken: Int
    var faceoffsWon: Int
    var hits: Int
    var plusMinus: Int
    var blockedShots: Int
    var takeaways: Int
    var giveaways: Int
    var timeOnIce: Time
    var powerplayTimeOnIce: Time
    var shorthandedTimeOnIce: Time
    var evenStrengthTimeOnIce: Time
}
