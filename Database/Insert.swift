//
//  Insert.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

struct Insert
{
    var data: [String:[Encodable]]
    
    init(_ valuesList: [[String:Encodable]])
    {
        data = [:]
        for values in valuesList
        {
            for (colName, colValue) in values
            {
                if var currentValues = data[colName]
                {
                    currentValues.append(colValue)
                }
                else
                {
                    data[colName] = [colValue]
                }
            }
        }
    }
}
