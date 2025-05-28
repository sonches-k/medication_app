//
//  NotificationManager.swift
//  Tabletnica
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

    private init() {}

    func configure() {
        requestAuthorization()
        registerCategories()
    }

    private func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification auth error:", error)
            } else {
                print("Notification permission granted:", granted)
            }
        }
    }

    private func registerCategories() {
        let take = UNNotificationAction(
            identifier: "TAKE",
            title: "Принять",
            options: [.authenticationRequired]
        )
        let snooze = UNNotificationAction(
            identifier: "SNOOZE",
            title: "Отложить на 15 мин",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "MED_REMINDER",
            actions: [take, snooze],
            intentIdentifiers: [],
            options: []
        )
        center.setNotificationCategories([category])
    }
}
