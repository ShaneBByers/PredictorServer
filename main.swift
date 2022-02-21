//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

//var testRows: [TestTable] = []
//
//for i in 0..<3
//{
//    let testRow = TestTable()
//    testRow.testInt = i * 10
//    testRow.testString = String(i)
//    testRows.append(testRow)
//}
//
//if let rowCount = Database.insert(testRows, columns: TestTable.columns())
//{
//    print(rowCount)
//}
//else
//{
//    print("Error")
//}

//var selectRows: [TestTable]? = Database.select(TestTable.where([(.testInt, .gt, 2), (.testInt, .lte, 10)]), TestTable.columns([.testInt]))
//
//if let selectRows = selectRows
//{
//    for selectRow in selectRows
//    {
//        print(selectRow)
//    }
//}

//var testTable = TestTable()
//testTable.testString = "TESTING"
//
//if let rowCount = Database.update(testTable, TestTable.columns([.testString]), TestTable.where([(.testInt, .gt, 5)]))
//{
//    print(rowCount)
//}

let returnCount = Database.delete(from: TestTable.tableName, TestTable.where([(.testInt, .lt, 5)]))

if let rowCount = returnCount
{
    print(rowCount)
}
