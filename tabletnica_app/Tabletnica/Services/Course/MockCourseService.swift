//
//  MockCourseService.swift
//  Tabletnica
//

import Foundation

final class MockCourseService: CourseServiceProtocol {
    static let shared = MockCourseService()
    private init() {}

    private let queue = DispatchQueue(label: "mock.course.service")

    func fetchCourses(
        for medicationId: Int,
        completion: @escaping (Result<[Course], Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            completion(.success(SharedStorage.loadCourses(for: medicationId)))
        }
    }

    func addCourse(
        _ course: Course,
        to medicationId: Int,
        completion: @escaping (Result<Course, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            var arr = SharedStorage.loadCourses(for: medicationId)
            var c = course; c.medicationId = medicationId
            arr.append(c)
            SharedStorage.saveCourses(arr, for: medicationId)
            completion(.success(c))
        }
    }

    func updateCourse(
        _ course: Course,
        for medicationId: Int,
        completion: @escaping (Result<Course, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            var arr = SharedStorage.loadCourses(for: medicationId)
            if let idx = arr.firstIndex(where: { $0.id == course.id }) {
                arr[idx] = course
                SharedStorage.saveCourses(arr, for: medicationId)
                completion(.success(course))
            } else {
                completion(.failure(NSError(
                    domain: "", code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Not found"]
                )))
            }
        }
    }

    func deleteCourse(
        _ id: Int,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            for med in SharedStorage.loadMeds() {
                var arr = SharedStorage.loadCourses(for: med.id)
                if let idx = arr.firstIndex(where: { $0.id == id }) {
                    arr.remove(at: idx)
                    SharedStorage.saveCourses(arr, for: med.id)
                    completion(.success(()))
                    return
                }
            }
            completion(.failure(NSError(
                domain: "", code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Not found"]
            )))
        }
    }

    func activeCourse(for medicationId: Int, on date: Date) -> Course? {
        SharedStorage.loadCourses(for: medicationId)
            .first { c in
                if let end = c.endDate { return c.startDate ... end ~= date }
                return c.startDate <= date
            }
    }

    func fetchSync(for medicationId: Int) -> Result<[Course], Error> {
        var result: Result<[Course], Error>!
        let sem = DispatchSemaphore(value: 0)
        fetchCourses(for: medicationId) { res in
            result = res; sem.signal()
        }
        sem.wait()
        return result
    }
}
