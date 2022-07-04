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
            logger.info("\(webTeams.count)")
            var databaseTeams: [DatabaseTeam] = []
            for webTeam in webTeams
            {
                databaseTeams.append(DatabaseTeam(webTeam))
            }
            if let rowCount = Database.insert(databaseTeams)
            {
                logger.info("\(rowCount)")
            }
        }
    }
}