//
//  DatabaseTest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/26/22.
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
    
    static func RunTest()
    {
        var insert1 = TestTable()
        insert1.testInt = 1
        insert1.testString = "First"
        
        var insert2 = TestTable()
        insert2.testInt = 2
        insert2.testString = "Second"
        
        var insertTransaction = TransactionRequest()
        insertTransaction.insert(TestTable.tableName, TestTable.columns(), TestTable.insertValues([insert1, insert2]))
        
        let _ = Database.execute(insertTransaction)
        
        var update1 = TestTable()
        update1.testInt = 3
        
//        var updateTransaction = TransactionRequest()
//        updateTransaction.update(TestTable.tableName, update1.updateValues([.testInt]), [TestTable.where(.testInt, .equals, 1)])
//
//        let _ = Database.execute(updateTransaction)
//
//        var deleteTransaction = TransactionRequest()
//        deleteTransaction.delete(TestTable.tableName, [TestTable.where(.testInt, .equals, 2)])
//
//        let _ = Database.execute(deleteTransaction)
//
//        if let selectTables: [TestTable] = Database.select(TestTable.where(.testInt, .equals, 3), TestTable.columns([.testString]))
//        {
//            print("\(selectTables.count)")
//        }
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
    
    enum TestTableColumn: String, CodingKey, CaseIterable
    {
        case testInt = "TEST_INT"
        case testString = "TEST_STRING"
    }
}
