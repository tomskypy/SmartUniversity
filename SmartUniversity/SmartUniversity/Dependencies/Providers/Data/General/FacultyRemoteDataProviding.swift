//
//  FacultyRemoteDataProviding.swift
//  SmartUniversity
//
//  Created by Tomáš Skýpala on 07.04.2021.
//  Copyright © 2021 Tomas Skypala. All rights reserved.
//

protocol FacultyRemoteDataProviding {

    func getAllFaculties(completion: @escaping ([Faculty]?, FacultyDataProvidingError?) -> Void)
}
