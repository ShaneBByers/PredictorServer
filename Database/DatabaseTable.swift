//
//  DatabaseTable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

protocol DatabaseColumn: Codable, CodingKey, CaseIterable, RawRepresentable, Hashable {}

protocol DatabaseTable: Codable
{
    associatedtype ColumnType: DatabaseColumn where ColumnType.RawValue == String
    
    static var tableName: String { get }
    
    init()
    
    init(from decoder: Decoder)
    
    static func editableColumns() -> [ColumnType]
    
    func values() -> [ColumnType:Encodable]
}

extension DatabaseTable
{
    func decodeString(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType) -> String?
    {
        return try? container?.decode(String.self, forKey: col)
    }
    
    func decodeInt(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType) -> Int?
    {
        var returnInt: Int?
        if let decodedString = try? container?.decode(String.self, forKey: col)
        {
            returnInt = Int(decodedString)
        }
        
        return returnInt
    }
    
    func decodeDate(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType) -> Date?
    {
        var returnDate: Date?
        if let decodedString = try? container?.decode(String.self, forKey: col)
        {
            returnDate = ISO8601DateFormatter().date(from: decodedString)
        }
        
        return returnDate
    }
}
