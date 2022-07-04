//
//  WebSeason.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebSeason: WebData
{
    static var path = ""
    
    var seasonId: String?
    var regularSeasonStartDate: String?
    var regularSeasonEndDate: String?
    var seasonEndDate: String?
    var numberOfGames: Int?
}
