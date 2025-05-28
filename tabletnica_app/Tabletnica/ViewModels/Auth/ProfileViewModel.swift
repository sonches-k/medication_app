//
//  ProfileViewModel.swift
//  Tabletnica
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
   
    @Published var avatarData: Data?
    @Published var name: String
    @Published var email: String
    @Published var phone: String

    @Published var ageString: String
    @Published var heightString: String
    @Published var weightString: String

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let originalId: UUID
    private let onSignOut: () -> Void

    init(user: User, onSignOut: @escaping () -> Void) {
        self.originalId    = user.id
        self.avatarData    = user.avatarData
        self.name          = user.name
        self.email         = user.email
        self.phone         = user.phone
        self.ageString     = user.age.map(String.init) ?? ""
        self.heightString  = user.height.map(String.init) ?? ""
        self.weightString  = user.weight.map(String.init) ?? ""
        self.onSignOut     = onSignOut
    }

    func saveProfile() {
        guard !name.isEmpty, !email.isEmpty else {
            errorMessage = "Имя и Email обязательны"
            return
        }

        let ageInt    = Int(ageString)
        let heightInt = Int(heightString)
        let weightInt = Int(weightString)

        isLoading    = true
        errorMessage = nil

        let updatedUser = User(
            id:          originalId,
            name:        name,
            email:       email,
            phone:       phone,
            age:         ageInt,
            height:      heightInt,
            weight:      weightInt,
            avatarData:  avatarData
        )

        ProfileStorage.save(updatedUser)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isLoading = false
        }
    }

    func signOut() {
        onSignOut()
    }

    func deleteAccount() {
        ProfileStorage.delete()
        onSignOut()
    }
}
