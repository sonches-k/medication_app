//
//  AppGroup.swift
//  Tabletnica
//

import Foundation

enum AppGroup {
    static let id = "group.sonya.Tabletnica"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: id)!
    }
}
