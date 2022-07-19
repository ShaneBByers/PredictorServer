//
//  CreateModel.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/10/22.
//

import Foundation
import CreateML

struct SkaterModel
{
    var dataTable: MLDataTable
    
    mutating func create()
    {
        let skaterModelDataList = getSkaterModelDataList()
        
        dataTable = getSkaterDataTable(using: skaterModelDataList)
    }
    
    private func getSkaterModelDataList() -> [SkaterModelData]
    {
        var skaterModelDataList: [SkaterModelData] = []
        
        logger.log("Attempting to get all Skater and Team Stats data from database.")
        let skaterStatsWhereClause = [
            Where(DatabaseSkaterStats.self, .gameId, >=, 2005000000),
            Where(DatabaseSkaterStats.self, .gameId, <=, 2006000000)
        ]
        let teamStatsWhereClause = [
            Where(DatabaseTeamStats.self, .gameId, >=, 2005000000),
            Where(DatabaseTeamStats.self, .gameId, >=, 2006000000)
        ]
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
                                                          seasonTeamStats: seasonTeamStats,
                                                          expected: skaterStats)
                    skaterModelDataList.append(skaterModelData)
                }
            }
            logger.log("Successfully created model data objects.")
        }
        
        return skaterModelDataList
    }
    
    private func getSkaterDataTable(using skaterModelDataList: [SkaterModelData]) -> MLDataTable
    {
        var dataTable = MLDataTable()
        
        SkaterModelGameStats.addColumns(to: &dataTable,
                                        using: skaterModelDataList.map { $0.seasonAverageSkaterData },
                                        prefix: "Season Average ")
        
        SkaterModelExpectedStats.addColumns(to: &dataTable,
                                            using: skaterModelDataList.map { $0.expectedStats })
        
        logger.log("Successfully create model data table.")
        
        return dataTable
    }
}
