//
//  NotificationServiceProtocol.swift
//  Tabletnica
//

import Foundation

protocol NotificationServiceProtocol {
    func requestAuthorization(completion: @escaping (Bool)->Void)
    func removeAllPendingNotifications()
    func scheduleNotifications(for course: Course,
                               frequencyPerDay: Int,
                               at timeComponents: DateComponents)

    func scheduleExpiration(for med: Medication)
    func cancelExpiration(for id: Int)
}
