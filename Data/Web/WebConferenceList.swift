//
//  WebConferenceList.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebConferenceList: WebData
{
    static var path = "conferences"
    
    var conferences: [WebConference]?
}
