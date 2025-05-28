//
//  Course.swift
//  Tabletnica
//

import Foundation

enum RecurrenceType: String, CaseIterable, Codable, Identifiable {
    case daily            = "Каждый день"
    case weekly           = "По выбранным дням"
    case cycle            = "Циклически"
    case everyNDays       = "Каждые N дней"
    case asNeeded         = "По необходимости"

    var id: String { rawValue }
}
enum Weekday: Int, CaseIterable, Codable, Identifiable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Int { rawValue }

    static let ordered: [Weekday] = [.monday, .tuesday, .wednesday,
                                     .thursday, .friday, .saturday, .sunday]

    var shortName: String {
        switch self {
        case .monday:    return "Пн"
        case .tuesday:   return "Вт"
        case .wednesday: return "Ср"
        case .thursday:  return "Чт"
        case .friday:    return "Пт"
        case .saturday:  return "Сб"
        case .sunday:    return "Вс"
        }
    }
}

struct Course: Identifiable, Codable {
    var id: Int
    var medicationId: Int
    var recurrenceType: RecurrenceType
    var weekDays: [Weekday]?
    var cycleWorkDays: Int?
    var cycleRestDays: Int?
    var everyNDays: Int?
    var times: [Date]
    var startDate: Date
    var endDate: Date?
    var notes: String?
}
