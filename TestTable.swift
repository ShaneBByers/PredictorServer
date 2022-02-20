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
    
    var testInt: Int?
    
    init()
    {
        
    }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: TestTableColumn.self)
        if let testIntString = try? container?.decode(String.self, forKey: .testInt)
        {
            testInt = Int(testIntString)
        }
    }
    
    static func columns(_ columns: [TestTableColumn]) -> [String]
    {
        return columns.map { $0.rawValue }
    }
    
    func allColumns() -> [String]
    {
        return TestTableColumn.allCases.map { $0.rawValue }
    }
    
    enum TestTableColumn: String, CodingKey, CaseIterable
    {
        case testInt = "TEST_INT"
    }
}
