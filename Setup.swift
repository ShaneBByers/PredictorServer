//
//  Initialization.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

struct Setup
{
    func setupAllData()
    {
        logger.info("Setting up: All Data")
        setupConferences()
        setupDivisions()
        setupTeams()
        setupSeasons()
        logger.info("Finished setting up: All Data")
    }
    
    func setupConferences()
    {
        logger.info("Setting up: Conferences")
        if let webConferenceList = WebRequest.getData(WebConferenceList.self)
        {
            if let webConferences = webConferenceList.conferences
            {
                logger.info("Read \(webConferences.count) conferences from web.")
                var databaseConferences: [DatabaseConference] = []
                for webConference in webConferences {
                    databaseConferences.append(DatabaseConference(from: webConference))
                }
                logger.info("Inserting \(databaseConferences.count) conferences to database.")
                if let inserted = Database.insert(values: databaseConferences)
                {
                    logger.info("Inserted \(inserted) conferences to database.")
                }
            }
        }
        logger.info("Finished setting up: Conferences")
    }
    
    func setupDivisions()
    {
        logger.info("Setting up: Divisions")
        if let webDivisionList = WebRequest.getData(WebDivisionList.self)
        {
            if let webDivisions = webDivisionList.divisions
            {
                logger.info("Red \(webDivisions.count) divisions from web.")
                var databaseDivisions: [DatabaseDivision] = []
                for webDivision in webDivisions {
                    databaseDivisions.append(DatabaseDivision(from: webDivision))
                }
                logger.info("Inserting \(databaseDivisions.count) divisions to database.")
                if let inserted = Database.insert(values: databaseDivisions)
                {
                    logger.info("Inserted \(inserted) divisions to database.")
                }
            }
        }
        logger.info("Finished setting up: Divisions")
    }
    
    func setupTeams()
    {
        logger.info("Setting up: Teams")
        if let webTeamList = WebRequest.getData(WebTeamList.self)
        {
            if let webTeams = webTeamList.teams
            {
                logger.info("Read \(webTeams.count) teams from web.")
                var databaseTeams: [DatabaseTeam] = []
                for webTeam in webTeams
                {
                    databaseTeams.append(DatabaseTeam(from: webTeam))
                }
                logger.info("Inserting \(databaseTeams.count) teams to database.")
                if let inserted = Database.insert(values: databaseTeams)
                {
                    logger.info("Inserted \(inserted) teams to database.")
                }
            }
        }
        logger.info("Finished setting up: Teams")
    }
    
    func setupSeasons()
    {
        logger.info("Setting up: Seasons")
        if let webSeasonList = WebRequest.getData(WebSeasonList.self)
        {
            if let webSeasons = webSeasonList.seasons
            {
                logger.info("Read \(webSeasons.count) seasons from web.")
                var databaseSeasons: [DatabaseSeason] = []
                for webSeason in webSeasons
                {
                    databaseSeasons.append(DatabaseSeason(from: webSeason))
                }
                logger.info("Inserting \(databaseSeasons.count) seasons to database.")
                if let inserted = Database.insert(values: databaseSeasons)
                {
                    logger.info("Inserted \(inserted) seasons to database.")
                }
            }
        }
        logger.info("Finished setting up: Seasons")
    }
}
