//
//  MockAuthService.swift
//  Tabletnica
//

import Foundation

enum MockAuthError: Error {
    case invalidCredentials
    case userNotFound
}

final class MockAuthService: AuthServiceProtocol {
    private var currentUser: User?
    private let queue = DispatchQueue(label: "mock.auth.service")
    
    func signIn(
        username: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.3) {
            if let u = self.currentUser,
               u.email.lowercased() == username.lowercased() {
                let resp = LoginResponse(token: "mock_jwt_token_123", user: u)
                completion(.success(resp))
            } else {
                completion(.failure(MockAuthError.invalidCredentials))
            }
        }
    }
    
    func signUp(
        name: String,
        username: String,
        password: String,
        phone: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.5) {
            let user = User(
                id: UUID(),
                name: name,
                email: username,
                phone: phone,
                age: nil,
                height: nil,
                weight: nil,
                avatarData: nil
            )
            self.currentUser = user
            completion(.success(()))
        }
    }
    
    func resetPassword(
        username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(()))
        }
    }
    
    func updateProfile(
        name: String,
        email: String,
        phone: String,
        age: Int?,
        height: Int?,
        weight: Int?,
        avatarData: Data?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.3) {
            guard var user = self.currentUser else {
                completion(.failure(MockAuthError.userNotFound))
                return
            }
            user.name       = name
            user.email      = email
            user.phone      = phone
            user.age        = age
            user.height     = height
            user.weight     = weight
            user.avatarData = avatarData
            self.currentUser = user
            completion(.success(()))
        }
    }
    
    func signOut() {
        currentUser = nil
    }
    
    func deleteAccount(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.4) {
            if self.currentUser != nil {
                self.currentUser = nil
                completion(.success(()))
            } else {
                completion(.failure(MockAuthError.userNotFound))
            }
        }
    }
}
