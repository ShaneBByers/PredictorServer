//
//  WebTeamList.swift
//  PredictorServer
//
//  Created by Shane Byers on 3/13/22.
//

import Foundation

struct WebTeamList: WebData
{
    static var path = "teams"
    
    var teams: [WebTeam]?
}
