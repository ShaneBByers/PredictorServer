//
//  Delete.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/20/22.
//

import Foundation

protocol Deletable: Encodable
{
    var tableName: String { get }
}

struct DeleteResponse: Decodable
{
    var rowCount: Int
    var filename: String
    var connectionStatus: String
}
