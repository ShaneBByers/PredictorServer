//
//  ModelData.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/11/22.
//

import Foundation
import CreateML

struct SkaterModelData
{
    var previousGamesSkaterData: [ModelSkaterStatsGame]
    var seasonAverageSkaterData: ModelSkaterStatsGame
    
    var previousGamesTeamData: [ModelTeamStatsGame]
    var seasonAverageTeamData: ModelTeamStatsGame
    
    init(forGame gameId: Int,
         seasonSkaterStats seasonSkaterStatsList: [DatabaseSkaterStats],
         seasonTeamStats seasonTeamStatsList: [DatabaseTeamStats])
    {
        previousGamesSkaterData = []
        var gamesAgo = 1
        let previousSkaterStatsList = seasonSkaterStatsList.filter({ $0.gameId ?? 0 < gameId }).prefix(10)
        for previousSkaterStats in previousSkaterStatsList
        {
            previousGamesSkaterData.append(ModelSkaterStatsGame(usingSkaterStats: previousSkaterStats, fromGamesAgo: gamesAgo))
            gamesAgo += 1
        }
        seasonAverageSkaterData = ModelSkaterStatsGame(averagingFromSkaterStats: seasonSkaterStatsList)
        
        previousGamesTeamData = []
        gamesAgo = 1
        let previousTeamStatsList = seasonTeamStatsList.filter({ $0.gameId ?? 0 < gameId }).prefix(10)
        for previousTeamStats in previousTeamStatsList
        {
            previousGamesTeamData.append(ModelTeamStatsGame(usingTeamStats: previousTeamStats, fromGamesAgo: gamesAgo))
            gamesAgo += 1
        }
        seasonAverageTeamData = ModelTeamStatsGame(averagingFromTeamStats: seasonTeamStatsList)
    }
}
