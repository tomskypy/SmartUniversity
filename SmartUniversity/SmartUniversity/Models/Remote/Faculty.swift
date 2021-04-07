//
//  Faculty.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

struct Faculty: Decodable {
    let id: Int
    let name: String
    let rooms: [Room]
}

struct Room: Decodable {

    let id: Int

    let capacity: Int
    let isLocked: Bool

    let name: String
    let buildingName: String
    let roomTypeName: String

    let description: String

    private enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case capacity
        case isLocked = "is_locked"
        case name
        case buildingName = "building"
        case roomTypeName = "type"
        case description
    }
}
