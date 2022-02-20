//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

struct Database
{
    static let baseUrl = "http://www.nhl-predictor.com/"
    
    static func select<T: Selectable>(from selectable: T) -> String?
    {
        var returnString: String? = nil
        if let url = URL(string: baseUrl + "select.php")
        {
            let selectRequest = SelectRequest(selectable: selectable)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(selectRequest)
            {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = body
                let semaphore = DispatchSemaphore(value: 0)
                URLSession.shared.dataTask(with: request)
                { data, response, error in
                    if let jsonResponse = data
                    {
//                        let decoder = JSONDecoder()
//                        returnObject = try? decoder.decode(selectable.self as! T.Type, from: jsonResponse)
                        returnString = String(data: jsonResponse, encoding: .utf8)
                    }
                    semaphore.signal()
                }.resume()
                semaphore.wait()
            }
        }
        return returnString
    }
}

struct SelectRequest: Encodable
{
    var databaseLogin = DatabaseLogin()
    var tableName: String

    init(selectable: Selectable)
    {
        tableName = selectable.tableName
    }
}

struct DatabaseLogin : Encodable
{
    let serverName = ConstantStrings.DB_SERVER_NAME.rawValue
    let username = ConstantStrings.DB_USERNAME.rawValue
    let password = ConstantStrings.DB_PASSWORD.rawValue
    let databaseName = ConstantStrings.DB_DATABASE_NAME.rawValue
}
