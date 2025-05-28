//
//  AppRouter.swift
//  Tabletnica
//

import Foundation
import Combine

final class AppRouter: ObservableObject {
    static let shared = AppRouter()
    @Published var isAuthenticated = false
    private init() {}
    
    func didAuthenticate() {
        isAuthenticated = true
    }
        func signOut() {
        isAuthenticated = false
    }
}


