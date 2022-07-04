//
//  WebSeasonList.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebSeasonList: WebData
{
    static var path = "seasons"
    
    var seasons: [WebSeason]?
}
