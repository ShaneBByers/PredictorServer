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
    var testString: String?
    
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
        testString = try? container?.decode(String.self, forKey: .testString)
    }
    
    static func columns(_ columns: [TestTableColumn] = TestTableColumn.allCases) -> ColumnsMap
    {
        return columns.map { (String(describing: $0), $0.rawValue) }
    }
    
    enum TestTableColumn: String, CodingKey, CaseIterable, Encodable, CustomStringConvertible
    {
        case testInt = "TEST_INT"
        case testString = "TEST_STRING"
        
        var description: String
        {
            switch self
            {
                case .testInt:
                    return "testInt"
                case .testString:
                    return "testString"
            }
        }
    }
}
