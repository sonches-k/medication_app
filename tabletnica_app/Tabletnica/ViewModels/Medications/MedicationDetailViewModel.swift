//
//  Untitled.swift
//  Tabletnica
//

import Foundation
import Combine

final class MedicationDetailViewModel: ObservableObject {

    @Published var name: String
    @Published var dosageValue: Int
    @Published var dosageUnit: String
    @Published var expirationDate: Date
    @Published var remainingCount: Int?

    @Published var activeCourse: Course?
    @Published var errorMessage: String?
    @Published var isDeleteAlertPresented = false

    
    var expirationDateOpt: Date? { original.expirationDate }
    
    var dosageText: String { "\(dosageValue) \(dosageUnit)" }
    
    var remainingCountOptional: Int? { original.remainingCount }
    
        var activeCourseSummary: String? {
            guard
                let course = MockCourseService.shared.activeCourse(
                    for: original.id,
                    on: Date()
                )
            else { return nil }

            let fmt = DateFormatter(); fmt.timeStyle = .short
            let t = course.times.map { fmt.string(from:$0) }.joined(separator: ", ")

            switch course.recurrenceType {
            case .daily:        return "Каждый день • \(t)"
            case .everyNDays:   return "Каждые \(course.everyNDays ?? 0) дн. • \(t)"
            case .weekly:
                let days = (course.weekDays ?? []).map(\.shortName).joined(separator:", ")
                return "По \(days) • \(t)"
            case .cycle:
                return "Цикл \(course.cycleWorkDays ?? 0)/\(course.cycleRestDays ?? 0) • \(t)"
            case .asNeeded:     return "По необходимости"
            }
        }

    var original: Medication
    private let medService: MedicationServiceProtocol
    private let courseService: CourseServiceProtocol
    private let onSave: () -> Void
    private var bag = Set<AnyCancellable>()

    init(
        medication: Medication,
        medService: MedicationServiceProtocol = MockMedicationService.shared,
        courseService: CourseServiceProtocol  = MockCourseService.shared,
        onSave: @escaping () -> Void
    ) {
        self.original      = medication
        self.medService    = medService
        self.courseService = courseService
        self.onSave        = onSave

        name            = medication.name
        dosageValue     = medication.dosageValue
        dosageUnit      = medication.dosageUnit
        expirationDate  = medication.expirationDate ?? Date()
        remainingCount  = medication.remainingCount 

        loadActiveCourse()
    }

    func deleteMedication() {
        medService.deleteMedication(original.id) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success: self?.onSave()
                case .failure(let err): self?.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func saveChanges() {
        var upd = original
        upd.name           = name
        upd.dosageValue    = dosageValue
        upd.dosageUnit     = dosageUnit
        upd.expirationDate = expirationDate
        upd.remainingCount = remainingCount

        medService.updateMedication(upd) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success: self?.onSave()
                case .failure(let err): self?.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func editViewModel() -> EditMedicationViewModel {
        .init(medication: original) { [weak self] updated in
            self?.apply(updated)
        }
    }

    private func loadActiveCourse() {
        courseService.fetchCourses(for: original.id) { [weak self] res in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch res {
                case .success(let list):
                    let today = Date()
                    self.activeCourse = list
                        .first(where: { c in
                            c.startDate <= today &&
                            (c.endDate == nil || c.endDate! >= today)
                        })
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
}

extension MedicationDetailViewModel {
    
    func apply(_ med: Medication) {
        original         = med
        name             = med.name
        dosageValue      = med.dosageValue
        dosageUnit       = med.dosageUnit
        expirationDate   = med.expirationDate ?? Date()
        remainingCount   = med.remainingCount
        onSave()                           
    }
}
