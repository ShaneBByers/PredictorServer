//
//  Selectable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

struct TestTable : DatabaseTable
{
    static var tableName = "TEST_TABLE"
    
    var testInt: Int?
    var testString: String?
    
    init() { }
    
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
    
    static func `where`(_ components: [(column: TestTableColumn, operation: WhereOperation, value: Any?)]) -> [WhereClause]
    {
        return components.map { ($0.column.rawValue, $0.operation, $0.value) }
    }
    
    enum TestTableColumn: String, CodingKey, CaseIterable, CustomStringConvertible
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
