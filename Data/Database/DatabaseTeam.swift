//
//  Team.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/27/22.
//

import Foundation

struct DatabaseTeam : DatabaseTable
{
    typealias ColumnType = TeamColumn
    
    static var tableName = "TEAMS"
    
    var id: Int?
    var divisionId: Int?
    var fullName: String?
    var locationName: String?
    var nickname: String?
    var abbreviation: String?
    var timezone: String?
    
    init() { }
    
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: TeamColumn.self)
        if let idString = try? container?.decode(String.self, forKey: .id)
        {
            id = Int(idString)
        }
        if let divisionIdString = try? container?.decode(String.self, forKey: .divisionId)
        {
            divisionId = Int(divisionIdString)
        }
        fullName = try? container?.decode(String.self, forKey: .fullName)
        locationName = try? container?.decode(String.self, forKey: .locationName)
        nickname = try? container?.decode(String.self, forKey: .nickname)
        abbreviation = try? container?.decode(String.self, forKey: .abbreviation)
        timezone = try? container?.decode(String.self, forKey: .timezone)
    }
    
    init(_ webTeam: WebTeam)
    {
        id = webTeam.id
        divisionId = webTeam.division?.id
        fullName = webTeam.name
        locationName = webTeam.locationName
        nickname = webTeam.teamName
        abbreviation = webTeam.abbreviation
        timezone = webTeam.venue?.timeZone?.tz
    }
    
    func updateValues(_ columns: [TeamColumn]) -> ColumnNameToValueMap
    {
        return DatabaseTeam.getColumnNameToValueMap(self, columns)
    }
    
    static func insertColumns() -> [TeamColumn]
    {
        return TeamColumn.allCases
    }
    
    static func insertValues(_ tables: [DatabaseTeam]) -> [ColumnNameToValueMap]
    {
        var returnList: [ColumnNameToValueMap] = []
        for table in tables
        {
            let map = getColumnNameToValueMap(table, TeamColumn.allCases)
            returnList.append(map)
        }
        return returnList
    }
    
    private static func getColumnNameToValueMap(_ table: DatabaseTeam, _ columns: [TeamColumn]) -> ColumnNameToValueMap
    {
        var map: ColumnNameToValueMap = [:]
        for column in columns {
            switch column
            {
                case .id: map[column.rawValue] = table.id
                case .divisionId: map[column.rawValue] = table.divisionId
                case .fullName: map[column.rawValue] = table.fullName
                case .locationName: map[column.rawValue] = table.locationName
                case .nickname: map[column.rawValue] = table.nickname
                case .abbreviation: map[column.rawValue] = table.abbreviation
                case .timezone: map[column.rawValue] = table.timezone
            }
        }
        return map
    }
    
    enum TeamColumn: String, DatabaseColumn
    {
        case id = "ID"
        case divisionId = "DIVISION_ID"
        case fullName = "FULL_NAME"
        case locationName = "LOCATION_NAME"
        case nickname = "NICKNAME"
        case abbreviation = "ABBREVIATION"
        case timezone = "TIMEZONE"
    }
}
