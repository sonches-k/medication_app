//
//  SignUpViewModel.swift
//  Tabletnica
//

import Foundation

final class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var phone = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: AuthServiceProtocol
    private let onSuccess: () -> Void
    
    init(
        service: AuthServiceProtocol = MockAuthService(),
        onSuccess: @escaping () -> Void
    ) {
        self.service = service
        self.onSuccess = onSuccess
    }
    
    func signUp() {
        guard !name.isEmpty,
              !email.isEmpty,
              !phone.isEmpty,
              !password.isEmpty,
              password == confirmPassword else {
            errorMessage = "Заполните все поля и проверьте, что пароли совпадают"
            return
        }
        isLoading = true
        errorMessage = nil
        
        service.signUp(
            name: name,
            username: email,
            password: password,
            phone: phone
        ) { [weak self] (result: Result<Void, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.onSuccess()
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
