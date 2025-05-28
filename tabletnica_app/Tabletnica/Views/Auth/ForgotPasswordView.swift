//
//  ForgotPasswordView.swift
//  Tabletnica
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var vm = ForgotPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Восстановление пароля") {
                    TextField("Email", text: $vm.email)
                        .keyboardType(.emailAddress)
                }
                
                if let error = vm.errorMessage {
                    Section {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button {
                        vm.sendResetLink()
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            Text("Отправить ссылку")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(vm.isLoading)
                }
            }
            .navigationTitle("Забыли пароль?")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
            }
            .alert("Письмо отправлено", isPresented: $vm.didSendLink) {
                Button("OK") { dismiss() }
            } message: {
                Text("Проверьте ваш email для ссылки на сброс пароля.")
            }
        }
    }
}
