//
//  TeamWeb.swift
//  PredictorServer
//
//  Created by Shane Byers on 3/13/22.
//

import Foundation

struct WebTeam: WebData
{
    static var path = "team"
    
    var id: Int?
    var division: Division?
    var venue: TeamVenue?
    var name: String?
    var locationName: String?
    var teamName: String?
    var abbreviation: String?
    
    struct Division: Decodable
    {
        var id: Int?
    }
    
    struct TeamVenue: Decodable
    {
        var timeZone: TeamTimeZone?
        
        struct TeamTimeZone: Decodable
        {
            var tz: String?
        }
    }
}
