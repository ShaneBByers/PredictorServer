//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

var testTables: [TestTable] = []
for i in 0..<3
{
    let testTable = TestTable()
    testTable.testColumn = i * 10
    testTables.append(testTable)
}

if let insertResponse = Database.insert(values: testTables)
{
    print(insertResponse.rowCount)
}
