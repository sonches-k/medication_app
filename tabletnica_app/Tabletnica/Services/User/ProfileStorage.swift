//
//  ProfileStorage.swift
//  Tabletnica
//

import Foundation

enum ProfileStorage {
    private static let key = "currentUser"

    static func load() -> User? {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let u = try? JSONDecoder().decode(User.self, from: data)
        else { return nil }
        return u
    }

    static func save(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func delete() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
