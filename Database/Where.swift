//
//  WhereOperation.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

struct Where
{
    var column: String
    var operation: String
    var value: String
    
    init<EnumT: RawRepresentable, ValueT: Comparable>(_ columnEnum: EnumT, _ whereOperation: WhereOperation, _ comparableValue: ValueT) where EnumT.RawValue == String
    {
        column = columnEnum.rawValue
        operation = whereOperation.rawValue
        switch comparableValue
        {
            case let intValue as Int:
                value = "\(intValue)"
            case let stringValue as String:
                value = "'\(stringValue)'"
            default:
                value = "NULL"
        }
    }
    
    enum WhereOperation: String
    {
        case lessThan = "<"
        case lessThanOrEqual = "<="
        case greaterThan = ">"
        case greaterThanOrEqual = ">="
        case equals = "="
        case notEquals = "!="
    }
}
