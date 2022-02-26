//
//  Selectable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

struct TestTable : DatabaseTable
{
    static var name = "TEST_TABLE"
    
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
    
    func updateValues(_ columns: [TestTableColumn]) -> ColumnNameToValueMap
    {
        return TestTable.getColumnNameToValueMap(self, columns)
    }
    
    static func insertValues(_ tables: [TestTable]) -> [ColumnNameToValueMap]
    {
        var returnList: [ColumnNameToValueMap] = []
        for table in tables
        {
            let map = getColumnNameToValueMap(table, TestTableColumn.allCases)
            returnList.append(map)
        }
        return returnList
    }
    
    private static func getColumnNameToValueMap(_ table: TestTable, _ columns: [TestTableColumn]) -> ColumnNameToValueMap
    {
        var map: ColumnNameToValueMap = [:]
        for column in TestTableColumn.allCases {
            switch column
            {
                case .testInt: map[column.rawValue] = table.testInt
                case .testString: map[column.rawValue] = table.testString
            }
        }
        return map
    }
    
    static func columns(_ columns: [TestTableColumn] = TestTableColumn.allCases) -> ColumnNames
    {
        return columns.map { $0.rawValue }
    }
    
    static func `where`<T: Comparable>(_ column: TestTableColumn, _ operation: Where.WhereOperation, _ value: T) -> Where
    {
        return Where(column.rawValue, operation, value)
    }
    
    enum TestTableColumn: String, CodingKey, CaseIterable
    {
        case testInt = "TEST_INT"
        case testString = "TEST_STRING"
    }
}
