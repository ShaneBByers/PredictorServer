//
//  Selectable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

final class TestTable : Selectable, Insertable
{
    var tableName = "TEST_TABLE"
    
    var testColumn: Int?
    
    init()
    {
        
    }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        if let testColumnString = try? container?.decode(String.self, forKey: .testColumn)
        {
            testColumn = Int(testColumnString)
        }
    }
    
    static func columns(_ columns: [TestTableColumn]) -> [String]
    {
        return columns.map { $0.rawValue }
    }
    
    enum TestTableColumn: String, CodingKey
    {
        case testColumn = "TEST_COLUMN"
    }
}

