//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

let databaseLogin = DatabaseLogin()
let webServerConnector = WebServerConnector()
let returnString = webServerConnector.getData(from: "test.php", with: databaseLogin)

if let printString = returnString
{
    print(printString)
}
