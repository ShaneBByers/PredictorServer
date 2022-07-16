//
//  ModelTeamStatsGame.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/12/22.
//

import Foundation

struct ModelTeamStatsGame
{
    var gamesAgo: Int?
    var goals: Double
    var shots: Double
    var ppGoals: Double
    var ppOpportunities: Double
    var blockedShots: Double
    var pim: Double
    var takeaways: Double
    var giveaways: Double
    var hits: Double
    
    init(usingTeamStats teamStats: DatabaseTeamStats, fromGamesAgo ago: Int?)
    {
        gamesAgo = ago
        goals = Double(teamStats.goals ?? 0)
        shots = Double(teamStats.shots ?? 0)
        ppGoals = Double(teamStats.ppGoals ?? 0)
        ppOpportunities = Double(teamStats.ppOpportunities ?? 0)
        blockedShots = Double(teamStats.blockedShots ?? 0)
        pim = Double(teamStats.pim ?? 0)
        takeaways = Double(teamStats.takeaways ?? 0)
        giveaways = Double(teamStats.giveaways ?? 0)
        hits = Double(teamStats.hits ?? 0)
    }
    
    init(averagingFromTeamStats teamStatsList: [DatabaseTeamStats])
    {
        let empty = teamStatsList.isEmpty
        let count = Double(teamStatsList.count)
        goals = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.goals ?? 0)})) / count
        shots = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.shots ?? 0)})) / count
        ppGoals = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.ppGoals ?? 0)})) / count
        ppOpportunities = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.ppOpportunities ?? 0)})) / count
        blockedShots = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.blockedShots ?? 0)})) / count
        pim = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.pim ?? 0)})) / count
        takeaways = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.takeaways ?? 0)})) / count
        giveaways = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.giveaways ?? 0)})) / count
        hits = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.hits ?? 0)})) / count
    }
}
