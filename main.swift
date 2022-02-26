//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation
import OSLog

let logger = Logger(subsystem: Logger.id, category: Logger.Category.testing.rawValue)

var insert1 = TestTable()
insert1.testInt = 1
insert1.testString = "First"

var insert2 = TestTable()
insert2.testInt = 2
insert2.testString = "Second"

var insertTransaction = TransactionRequest()
insertTransaction.insert(TestTable.name, TestTable.columns(), TestTable.insertValues([insert1, insert2]))

let _ = Database.execute(insertTransaction)

var update1 = TestTable()
update1.testInt = 3

var updateTransaction = TransactionRequest()
updateTransaction.update(TestTable.name, update1.updateValues([.testInt]), [TestTable.where(.testInt, .equals, 1)])

let _ = Database.execute(updateTransaction)

var deleteTransaction = TransactionRequest()
deleteTransaction.delete(TestTable.name, [TestTable.where(.testInt, .equals, 2)])

let _ = Database.execute(deleteTransaction)

if let selectTables: [TestTable] = Database.select(TestTable.where(.testInt, .equals, 3), TestTable.columns([.testString]))
{
    logger.debug("\(selectTables.count)")
}
