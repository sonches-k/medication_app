//
//  AuthServiceProtocol.swift
//  Tabletnica
//

import Foundation

protocol AuthServiceProtocol {
    func signIn(
        username: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    )
    
    func signUp(
        name: String,
        username: String,
        password: String,
        phone: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func resetPassword(
        username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func updateProfile(
        name: String,
        email: String,
        phone: String,
        age: Int?,
        height: Int?,
        weight: Int?,
        avatarData: Data?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func signOut()
    
    func deleteAccount(
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
