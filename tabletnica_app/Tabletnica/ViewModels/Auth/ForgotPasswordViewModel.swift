//
//  ForgotPasswordViewModel.swift
//  Tabletnica
//

import Foundation

final class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSendLink = false
    
    private let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol = MockAuthService()) {
        self.service = service
    }
    
    func sendResetLink() {
        guard !email.isEmpty else {
            errorMessage = "Введите email"
            return
        }
        isLoading = true
        errorMessage = nil
        
        service.resetPassword(
            username: email
        ) { [weak self] (result: Result<Void, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.didSendLink = true
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
