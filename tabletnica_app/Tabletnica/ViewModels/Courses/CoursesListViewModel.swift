//
//  CoursesListViewModel.swift
//  Tabletnica
//

import Foundation

final class CoursesListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var errorMessage: String?

    let medicationId: Int
    private let service: CourseServiceProtocol

    init(
        medicationId: Int,
        service: CourseServiceProtocol = MockCourseService.shared
    ) {
        self.medicationId = medicationId
        self.service = service
    }

    func loadCourses() {
        service.fetchCourses(for: medicationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.courses = list
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func deleteCourse(at offsets: IndexSet) {
        offsets.forEach { index in
            let c = courses[index]
            service.deleteCourse(c.id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.courses.remove(at: index)
                    case .failure(let err):
                        self?.errorMessage = err.localizedDescription
                    }
                }
            }
        }
    }
}
