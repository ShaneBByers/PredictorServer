//
//  WebDivision.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebDivision: WebData
{
    static var path = ""
    
    var id: Int?
    var conference: Conference?
    var name: String?
    var abbreviation: String?
    
    struct Conference: Decodable
    {
        var id: Int?
    }
}
