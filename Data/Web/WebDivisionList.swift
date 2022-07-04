//
//  WebDivisionList.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebDivisionList: WebData
{
    static var path = "divisions"
    
    var divisions: [WebDivision]?
}
