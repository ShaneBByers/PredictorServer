//
//  DatabaseTable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

protocol DatabaseColumn: Codable, CodingKey, CaseIterable, RawRepresentable {}

protocol DatabaseTable: Codable
{
    associatedtype ColumnType: DatabaseColumn where ColumnType.RawValue == String
    
    static var tableName: String { get }
    
    static func insertColumns() -> [ColumnType]
    
    init()
    
    init(from decoder: Decoder)
}
