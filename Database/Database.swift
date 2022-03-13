//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation
import OSLog

typealias ColumnNames = [String]
typealias ColumnNameToValueMap = [String:Encodable?]

struct Database
{
    private static let baseUrl = "http://www.nhl-predictor.com/"
    private static let transactionPHP = "transaction.php"
    private static let selectPHP = "select.php"
    
    private static let logger = Logger(subsystem: Logger.id, category: Logger.Category.database.rawValue)
    
    static func execute(_ transactionRequest: TransactionRequest) -> Int?
    {
        return getResponse(from: transactionPHP, using: DatabaseRequest(transactionRequest.queryList))
    }
    
    static func select<T: DatabaseTable>(_ table: T.Type) -> [T]?
    {
        return getResponse(from: selectPHP, using: DatabaseRequest(SelectRequest(T.tableName).query))
    }
    
    static func select<T: DatabaseTable>(_ whereClause: Where, _ columns: ColumnNames? = nil) -> [T]?
    {
        return select([whereClause], columns)
    }
    
    static func select<T: DatabaseTable>(_ whereClauses: [Where]? = nil, _ columns: ColumnNames? = nil) -> [T]?
    {
        return getResponse(from: selectPHP, using: DatabaseRequest(SelectRequest(T.tableName, whereClauses, columns).query))
    }
    
    private static func getResponse<T: Decodable>(from filename: String, using request: DatabaseRequest) -> T?
    {
        if let url = URL(string: baseUrl + filename)
        {
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(request)
            {
                if let jsonResponse = executePostRequest(url, with: body)
                {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(T.self, from: jsonResponse)
                    {
                        return decoded
                    }
                }
            }
        }
        return nil
    }
    
    private static func executePostRequest(_ url: URL, with body: Data) -> Data?
    {
        var jsonResponse: Data? = nil
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request)
        { data, response, error in
            jsonResponse = data
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return jsonResponse
    }
    
    private struct DatabaseRequest : Encodable
    {
        let databaseLogin = DatabaseLogin()
        var queryList: [String]?
        var query: String?
        
        init (_ queries: [String])
        {
            logger.debug("START TRANSACTION")
            for query in queries
            {
                logger.debug("\(query)")
            }
            logger.debug("COMMIT")
            queryList = queries
        }
        
        init (_ q: String)
        {
            logger.debug("\(q)")
            query = q
        }
        
        struct DatabaseLogin : Encodable
        {
            let serverName = ConstantStrings.DB_SERVER_NAME.rawValue
            let username = ConstantStrings.DB_USERNAME.rawValue
            let password = ConstantStrings.DB_PASSWORD.rawValue
            let databaseName = ConstantStrings.DB_DATABASE_NAME.rawValue
        }
    }
    
    private struct SelectRequest : Encodable
    {
        var query: String
        
        init(_ tableName: String, _ whereClauses: [Where]? = nil, _ columns: ColumnNames? = nil)
        {
            query = "SELECT "
            if let columns = columns
            {
                query += "("
                for column in columns
                {
                    query += "\(column), "
                }
                query.removeLast(2)
                query += ")"
            }
            else
            {
                query += "*"
            }
            query += " FROM \(tableName)"
            if let whereClauses = whereClauses {
                query += " WHERE "
                for whereClause in whereClauses {
                    query += "\(whereClause.column) \(whereClause.operation) \(whereClause.value) AND "
                }
                query.removeLast(5);
            }
            query += ";"
        }
    }
}
