//
//  ProfileView.swift
//  Tabletnica
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var vm: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var photoItem: PhotosPickerItem?
    
    init(user: User, onSignOut: @escaping () -> Void) {
        _vm = StateObject(
            wrappedValue: ProfileViewModel(user: user, onSignOut: onSignOut)
        )
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        PhotosPicker(
                            selection: $photoItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let data = vm.avatarData,
                               let ui = UIImage(data: data) {
                                Image(uiImage: ui)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person.crop.circle")
                                            .font(.system(size: 50))
                                            .foregroundStyle(.white.opacity(0.7))
                                    )
                            }
                        }
                        .onChange(of: photoItem) { oldItem, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.avatarData = data
                                }
                            }
                        }
                        Spacer()
                    }
                }
                
                Section("Личные данные") {
                    TextField("Имя", text: $vm.name)
                    TextField("Email", text: $vm.email)
                        .keyboardType(.emailAddress)
                    TextField("Телефон", text: $vm.phone)
                        .keyboardType(.phonePad)
                    TextField("Возраст", text: $vm.ageString)
                        .keyboardType(.numberPad)
                    TextField("Рост (см)", text: $vm.heightString)
                        .keyboardType(.numberPad)
                    TextField("Вес (кг)",  text: $vm.weightString)
                        .keyboardType(.numberPad)
                }
                
                if let error = vm.errorMessage {
                    Section {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button("Сохранить") {
                        vm.saveProfile()
                    }
                    .disabled(vm.isLoading)
                }
                Section {
                    Button("Выйти") { vm.signOut() }
                        .tint(.red)
                    Button("Удалить аккаунт") { vm.deleteAccount() }
                        .tint(.red)
                }
            }
            .navigationTitle("Профиль")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}
