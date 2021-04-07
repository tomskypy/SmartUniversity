//
//  FacultyRemoteDataArray.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

enum FacultyDataProvidingError {
    case fetch(error: DataFetchError)
}

struct FacultyRemoteDataArray: Decodable {
    let faculties: [Faculty]
}
