//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

let testTable = TestTable()

if let selectResponse = Database.select(from: testTable)
{
//    print(selectResponse.rowCount)
}
