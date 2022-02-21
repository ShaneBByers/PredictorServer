//
//  DatabaseTable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

protocol DatabaseTable: Codable
{
    static var tableName: String { get }
}
