//
//  LoginResponse.swift
//  Tabletnica
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
    let user: User
}
