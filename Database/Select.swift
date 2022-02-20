//
//  Selectable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

protocol Selectable : Codable
{
    var tableName: String { get }
}

struct SelectResponse<T: Selectable>: Decodable
{
    var rowCount: Int
    var filename: String
    var connectionStatus: String
    var results: [T]
}
