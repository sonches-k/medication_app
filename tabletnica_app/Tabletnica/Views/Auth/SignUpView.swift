//
//  SignUpView.swift
//  Tabletnica
//
  
import SwiftUI

struct SignUpView: View {
    @StateObject private var vm: SignUpViewModel
    @Environment(\.dismiss) private var dismiss

    init(onSuccess: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: SignUpViewModel(onSuccess: onSuccess))
    }

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
                        Group {
                            FloatingLabelTextField(
                                label: "Имя",
                                text: $vm.name,
                                systemIcon: "person"
                            )
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
                            FloatingLabelSecureField(
                                label: "Повторите пароль",
                                text: $vm.confirmPassword,
                                systemIcon: "lock.rotation"
                            )
                            FloatingLabelTextField(
                                label: "Телефон",
                                text: $vm.phone,
                                systemIcon: "phone",
                                keyboard: .phonePad
                            )
                        }
                        .padding(.horizontal)
                    }

                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Button {
                        vm.signUp()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accentColor)
                                .frame(height: 48)
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Зарегистрироваться")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .disabled(vm.isLoading)
                }
                .padding(.bottom, 40)
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


struct FloatingLabelTextField: View {
    let label: String
    @Binding var text: String
    var systemIcon: String
    var keyboard: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: systemIcon)
                .foregroundColor(.secondary)
            ZStack(alignment: .leading) {
                Text(label)
                    .foregroundColor(isFocused || !text.isEmpty
                                     ? .accentColor
                                     : .secondary)
                    .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                    .offset(y: isFocused || !text.isEmpty ? -26 : 0)
                    .animation(.easeOut(duration: 0.2), value: isFocused || !text.isEmpty)
                TextField("", text: $text)
                    .keyboardType(keyboard)
                    .focused($isFocused)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(RoundedRectangle(cornerRadius: 8).stroke(isFocused ? Color.accentColor : Color.gray.opacity(0.4)))
    }
}

struct FloatingLabelSecureField: View {
    let label: String
    @Binding var text: String
    var systemIcon: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: systemIcon)
                .foregroundColor(.secondary)
            ZStack(alignment: .leading) {
                Text(label)
                    .foregroundColor(isFocused || !text.isEmpty
                                     ? .accentColor
                                     : .secondary)
                    .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                    .offset(y: isFocused || !text.isEmpty ? -26 : 0)
                    .animation(.easeOut(duration: 0.2), value: isFocused || !text.isEmpty)
                SecureField("", text: $text)
                    .focused($isFocused)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(RoundedRectangle(cornerRadius: 8).stroke(isFocused ? Color.accentColor : Color.gray.opacity(0.4)))
    }
}
