//
//  NotificationService.swift
//  Tabletnica
//

import Foundation
import UserNotifications

final class NotificationService: NotificationServiceProtocol {
    static let shared = NotificationService()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }

    func removeAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    func scheduleNotifications(
        for course: Course,
        frequencyPerDay: Int,
        at timeComponents: DateComponents
    ) {
        removeAllPendingNotifications()

        let totalDoses = max(frequencyPerDay, 1)
        var delay: TimeInterval = 5

        for doseIndex in 0..<totalDoses {
            let content = UNMutableNotificationContent()
            content.title = "⏰ Напоминание о приёме"
            content.body  = "Курс Аспирин: пора принять препарат"
            content.sound = .default
            content.categoryIdentifier = "MED_REMINDER"

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            let request = UNNotificationRequest(
                identifier: "mock-course-\(course.id)-\(doseIndex)",
                content: content,
                trigger: trigger
            )
            center.add(request, withCompletionHandler: nil)
            delay += 5
        }

        center.getPendingNotificationRequests { requests in
            let ids = requests.map(\.identifier)
            print("⏰ [Course DEBUG] ", ids)
        }
    }

    func scheduleExpiration(for med: Medication) {
        guard let exp = med.expirationDate else { return }

        if let trigger = calendarTrigger(exp, offsetDays: -7) {
            let content = UNMutableNotificationContent()
            content.title = "Срок годности скоро истечёт"
            content.body  = "До окончания «Аспирин» осталось 7 дней."
            content.sound = .default
            center.add(.init(identifier: warnID(med.id),
                             content: content,
                             trigger: trigger))
        }

        if let trigger = calendarTrigger(exp, offsetDays: 0) {
            let content = UNMutableNotificationContent()
            content.title = "Срок годности истёк"
            content.body  = "Препарат «Аспирин» просрочен."
            content.sound = .defaultCritical
            center.add(.init(identifier: dueID(med.id),
                             content: content,
                             trigger: trigger))
        }

        center.getPendingNotificationRequests { requests in
            let ids = requests.map(\.identifier)
            print("⏰ [Expiration DEBUG] Pending:", ids)
        }
    }

    func cancelExpiration(for id: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [warnID(id), dueID(id)])
    }

    private func calendarTrigger(_ date: Date, offsetDays: Int) -> UNCalendarNotificationTrigger? {
        guard let tgt = Calendar.current.date(byAdding: .day, value: offsetDays, to: date) else { return nil }
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: tgt)
        comps.hour   = 9
        comps.minute = 0
        return UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
    }

    private func warnID(_ id: Int) -> String { "exp-warn-\(id)" }
    private func dueID (_ id: Int) -> String { "exp-due-\(id)" }
}
