//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

var testRows: [TestTable] = []

for i in 0..<3
{
    let testRow = TestTable()
    testRow.testInt = i * 10
    testRow.testString = String(i)
    testRows.append(testRow)
}

if let rowCount = Database.insert(testRows, columns: TestTable.columns())
{
    print(rowCount)
}
else
{
    print("Error")
}
