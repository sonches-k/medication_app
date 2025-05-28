//
//  LoginView.swift
//  Tabletnica
//

import SwiftUI
import PhotosUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Image(systemName: "pills.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.accentColor)
                        Text("Tabletnica")
                            .font(.largeTitle.weight(.bold))
                    }
                    .padding(.top, 40)
                    VStack(spacing: 24) {
                        FloatingLabelTextField(
                            label: "Email",
                            text: $vm.email,
                            systemIcon: "envelope",
                            keyboard: .emailAddress
                        )
                        FloatingLabelSecureField(
                            label: "Пароль",
                            text: $vm.password,
                            systemIcon: "lock"
                        )
                    }
                    .padding(.horizontal)

                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Button {
                        vm.signIn()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accentColor)
                                .frame(height: 48)
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Text("Войти")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .disabled(vm.isLoading)

                    HStack {
                        Button("Забыли пароль?") {
                        }
                        Spacer()
                        NavigationLink("Регистрация") {
                            SignUpView {
                                AppRouter.shared.didAuthenticate()
                            }
                        }
                    }
                    .font(.footnote)
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                        .foregroundColor(.primary)
                }
            }
        }
    }
}





