//
//  LoginViewModel.swift
//  Tabletnica
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: AuthServiceProtocol
    private let router = AppRouter.shared
    
    init(service: AuthServiceProtocol = MockAuthService()) {
        self.service = service
    }
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Введите email и пароль"
            return
        }
        isLoading = true
        errorMessage = nil
        
        service.signIn(username: email, password: password) { [weak self] (result: Result<LoginResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let resp):
                    Persistence.shared.saveToken(resp.token)
                    Persistence.shared.saveUser(resp.user)
                    self.router.didAuthenticate()
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
