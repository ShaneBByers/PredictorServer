//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation
import OSLog

let logger = Logger(subsystem: Logger.id, category: Logger.Category.testing.rawValue)

//if let webTeamList = WebRequest.getData(WebTeamList.self)
//{
//    if let webTeams = webTeamList.teams
//    {
//        var databaseTeams: [DatabaseTeam] = []
//        for webTeam in webTeams
//        {
//            databaseTeams.append(DatabaseTeam(webTeam))
//        }
//        var transaction = TransactionRequest()
//        transaction.insert(DatabaseTeam.tableName, DatabaseTeam.columns(), DatabaseTeam.insertValues(databaseTeams))
//        if let rowCount = Database.execute(transaction)
//        {
//            logger.info("\(rowCount)")
//        }
//    }
//}

if let teams = Database.select(DatabaseTeam.self)
{
    logger.info("\(teams[0].fullName!)")
}
