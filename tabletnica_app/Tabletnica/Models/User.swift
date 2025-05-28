//
//  User.swift
//  Tabletnica
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var phone: String
    var age: Int?
    var height: Int?
    var weight: Int?
    var avatarData: Data?
}
