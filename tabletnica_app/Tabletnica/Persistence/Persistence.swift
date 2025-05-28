//
//  Persistence.swift
//  Tabletnica
//
//  Created by Соня on 21.05.2025.
//

import Foundation

final class Persistence {
    static let shared = Persistence()
    private let tokenKey = "jwtToken"
    private let userKey = "currentUser"

    private init() {}

    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set {
            if let v = newValue {
                UserDefaults.standard.set(v, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }

    var hasValidToken: Bool {
        token != nil
    }

    func saveToken(_ t: String) {
        token = t
    }
    func clearToken() {
        token = nil
    }

    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
    func getUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }
    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    func clearAll() {
        clearToken()
        clearUser()
    }
}
