//
//  Request.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

protocol DatabaseRequest : Encodable
{
    var query: String { get }
}

extension DatabaseRequest
{
    func dbString(_ value: Any?) -> String
    {
        switch value
        {
            case let intValue as Int:
                return "\(intValue)"
            case let stringValue as String:
                return "'\(stringValue)'"
            default:
                return "NULL"
        }
    }
}
