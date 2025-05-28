//
//  CourseServiceProtocol.swift
//  Tabletnica
//

import Foundation

protocol CourseServiceProtocol {

    func fetchCourses(
        for medicationId: Int,
        completion: @escaping (Result<[Course], Error>) -> Void
    )

    func addCourse(
        _ course: Course,
        to medicationId: Int,
        completion: @escaping (Result<Course, Error>) -> Void
    )

    func updateCourse(
        _ course: Course,
        for medicationId: Int,
        completion: @escaping (Result<Course, Error>) -> Void
    )

    func deleteCourse(
        _ id: Int,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
