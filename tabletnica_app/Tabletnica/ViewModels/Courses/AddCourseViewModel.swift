//
//  AddCourseViewModel.swift
//  Tabletnica
//

import Foundation
import UserNotifications

final class AddCourseViewModel: ObservableObject {
    @Published var recurrenceType: RecurrenceType = .daily
    @Published var weekDays: [Weekday] = []
    @Published var cycleWorkDays: Int = 21
    @Published var cycleRestDays: Int = 7
    @Published var everyNDays: Int = 1
    @Published var times: [Date] = [Date()]
    @Published var startDate: Date = Date()
    @Published var endDate: Date? = nil
    @Published var notes: String = ""
    
    let medicationId: Int
    private let onSaveCallback: () -> Void
    
    init(medicationId: Int, onSave: @escaping () -> Void) {
        self.medicationId = medicationId
        self.onSaveCallback = onSave
    }
    
    func save() {
        let newCourse = Course(
            id: Int(Date().timeIntervalSince1970),
            medicationId: medicationId,
            recurrenceType: recurrenceType,
            weekDays: weekDays.isEmpty ? nil : weekDays,
            cycleWorkDays: recurrenceType == .cycle ? cycleWorkDays : nil,
            cycleRestDays: recurrenceType == .cycle ? cycleRestDays : nil,
            everyNDays: recurrenceType == .everyNDays ? everyNDays : nil,
            times: times,
            startDate: startDate,
            endDate: endDate
        )
        
        MockCourseService.shared.addCourse(newCourse, to: medicationId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.onSaveCallback()
                    
                    let freq = newCourse.times.count
                    let comps = Calendar.current.dateComponents([.hour, .minute], from: newCourse.times.first!)
                    NotificationService.shared.scheduleNotifications(
                        for: newCourse,
                        frequencyPerDay: freq,
                        at: comps
                    )
                    
                    NotificationService.shared.removeAllPendingNotifications()
                    UNUserNotificationCenter.current().getPendingNotificationRequests { reqs in
                        print("⏰ [DEBUG] course notifications:", reqs.map(\.identifier))
                    }
                    
                case .failure(let error):
                    print("Ошибка добавления курса: \(error)")
                }
            }
        }
    }
}
