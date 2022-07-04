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
        id = decodeInt(container, for: .id)
        divisionId = decodeInt(container, for: .divisionId)
        fullName = decodeString(container, for: .fullName)
        locationName = decodeString(container, for: .locationName)
        nickname = decodeString(container, for: .nickname)
        abbreviation = decodeString(container, for: .abbreviation)
        timezone = decodeString(container, for: .timezone)
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
    
    static func editableColumns() -> [TeamColumn]
    {
        return TeamColumn.allCases
    }
    
    func values() -> [TeamColumn:Encodable]
    {
        return [.id: id,
                .divisionId: divisionId,
                .fullName: fullName,
                .locationName: locationName,
                .nickname: nickname,
                .abbreviation: abbreviation,
                .timezone: timezone]
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
