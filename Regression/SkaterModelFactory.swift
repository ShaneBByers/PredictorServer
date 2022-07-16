//
//  CreateModel.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/10/22.
//

import Foundation
import CreateML

struct SkaterModelFactory
{
    static func createModel() -> MLDataTable
    {
        let skaterModelList = SkaterModelFactory.getSkaterModels()
        
        let skaterDataTable = SkaterModelFactory.getSkaterDataTable(using: skaterModelList)
        
        return skaterDataTable
    }
    
    private static func getSkaterModels() -> [SkaterModelData]
    {
        var allSkatersModelData: [SkaterModelData] = []
        
        let skaterStatsWhereClause = [
            Where(DatabaseSkaterStats.self, .gameId, >=, 2005000000),
            Where(DatabaseSkaterStats.self, .gameId, <=, 2006000000)
        ]
        let teamStatsWhereClause = [
            Where(DatabaseTeamStats.self, .gameId, >=, 2005000000),
            Where(DatabaseTeamStats.self, .gameId, >=, 2006000000)
        ]
        
        logger.log("Attempting to get all Skater and Team Stats data from database.")
        if var skaterStatsList = Database.select(DatabaseSkaterStats.self,
                                                 where: skaterStatsWhereClause),
           var teamStatsList = Database.select(DatabaseTeamStats.self,
                                               where: teamStatsWhereClause)
        {
            logger.log("Successfully read \(skaterStatsList.count) skater stats and \(teamStatsList.count) team stats from database.")
            skaterStatsList.sort(by: { $0.gameId ?? 0 > $1.gameId ?? 0 })
            teamStatsList.sort(by: { $0.gameId ?? 0 > $1.gameId ?? 0})
            var playerIdToSkaterStatsDict: [Int:[DatabaseSkaterStats]] = [:]
            var playerIdToTeamStatsDict: [Int:[DatabaseTeamStats]] = [:]
            for skaterStats in skaterStatsList
            {
                if let playerId = skaterStats.playerId
                {
                    if var currentList = playerIdToSkaterStatsDict[playerId]
                    {
                        currentList.append(skaterStats)
                        playerIdToSkaterStatsDict[playerId] = currentList
                    }
                    else
                    {
                        playerIdToSkaterStatsDict[playerId] = [skaterStats]
                    }
                }
            }
            for teamStats in teamStatsList
            {
                if let teamId = teamStats.teamId
                {
                    if var currentList = playerIdToTeamStatsDict[teamId]
                    {
                        currentList.append(teamStats)
                    }
                    else
                    {
                        playerIdToTeamStatsDict[teamId] = [teamStats]
                    }
                }
            }
            logger.log("Successfully sorted skater stats and team stats into appropriate dictionaries.")
            for skaterStats in skaterStatsList
            {
                if let gameId = skaterStats.gameId,
                   let teamId = skaterStats.teamId,
                   let playerId = skaterStats.playerId,
                   let seasonSkaterStats = playerIdToSkaterStatsDict[playerId],
                   let seasonTeamStats = playerIdToTeamStatsDict[teamId]
                {
                    let skaterModelData = SkaterModelData(forGame: gameId,
                                                          seasonSkaterStats: seasonSkaterStats,
                                                          seasonTeamStats: seasonTeamStats)
//                    logger.log("Succesfully converted skater stats with Game ID: \(skaterStats.gameId!) and Team ID: \(teamId) and Player ID: \(playerId)")
                    allSkatersModelData.append(skaterModelData)
                }
            }
        }
        
        return allSkatersModelData
    }
    
    private static func getSkaterDataTable(using skaterModels: [SkaterModelData]) -> MLDataTable
    {
        var dataTable = MLDataTable()
        
        let testColumn = MLDataColumn(skaterModels.map({ $0.seasonAverageSkaterData.goals }))
        
        dataTable.addColumn(testColumn, named: "Test Column")
        
        return dataTable
    }
}
