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
    
    enum CodingKeys: String, CodingKey
    {
        case testColumn = "TEST_COLUMN"
    }
}
