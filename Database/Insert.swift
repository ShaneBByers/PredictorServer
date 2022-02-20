//
//  Insert.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/20/22.
//

import Foundation

protocol Insertable: Encodable
{
    var tableName: String { get }
}

struct InsertResponse: Decodable
{
    var rowCount: Int
    var filename: String
    var connectionStatus: String
    var insertSuccess: Bool
}
