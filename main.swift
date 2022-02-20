//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

if let testRows: [TestTable] = Database.select()
{
    for testRow in testRows
    {
        if let testColumn = testRow.testColumn
        {
            print(testColumn)
        }
    }
}
