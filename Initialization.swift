//
//  Initialization.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

func getTeams()
{
    if let webTeamList = WebRequest.getData(WebTeamList())
    {
        if let webTeams = webTeamList.teams
        {
            var databaseTeams: [DatabaseTeam] = []
            for webTeam in webTeams
            {
                databaseTeams.append(DatabaseTeam(webTeam))
            }
            var transaction = Transaction()
            transaction.insert(databaseTeams)
            if let rowCount = Database.execute(transaction)
            {
                logger.info("\(rowCount)")
            }
        }
    }
}
