//
//  ScheduleType.swift
//  Tabletnica
//

import Foundation

enum ScheduleType: String, CaseIterable, Codable {
    case daily
    case weekly
    case cyclic
    case asNeeded

    var displayName: String {
        switch self {
        case .daily:
            return "Каждый день"
        case .weekly:
            return "По дням недели"
        case .cyclic:
            return "Циклически"
        case .asNeeded:
            return "По необходимости"
        }
    }
}
