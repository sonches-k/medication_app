//
//  AddMedicationViewModel.swift
//  Tabletnica
//

import Foundation

final class AddMedicationViewModel: ObservableObject {

    @Published var name: String = ""

    @Published var dosageValueString: String = ""
    @Published var dosageUnit: String = "мг"

    @Published var hasExpirationDate: Bool = false
    @Published var expirationDate: Date = Date()

    @Published var form: String = "Таблетка"
    @Published var remainingCountString: String = ""

    @Published var isLoading  = false
    @Published var errorMessage: String?

    let medicationForms = [
        "Таблетка","Капсула","Спрей","Капли",
        "Сироп","Мазь","Пластырь","Ингалятор"
    ]

    private let service : MedicationServiceProtocol
    private let onSave  : () -> Void

    init(
        service: MedicationServiceProtocol = MockMedicationService.shared,
        onSave : @escaping () -> Void
    ) {
        self.service = service
        self.onSave  = onSave
    }

    func save() {
        guard
            !name.isEmpty,
            let value = Int(dosageValueString), value > 0
        else {
            errorMessage = "Заполните обязательные поля корректно"
            return
        }

        let count = Int(remainingCountString) ?? 0
        let remainingOpt = count == 0 ? nil : count

        let expOpt: Date? = hasExpirationDate ? expirationDate : nil

        let newMed = Medication(
            id: Int(Date().timeIntervalSince1970),
            name: name,
            dosageValue: value,
            dosageUnit: dosageUnit,
            expirationDate: expOpt,
            remainingCount: remainingOpt,
            form: form,
            lastTakenDate: nil,
            lastSkippedDate: nil
        )

        isLoading   = true
        errorMessage = nil

        service.addMedication(newMed) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success:
                    if expOpt != nil {
                        print("🔔 [AddMed] scheduling expiration for med \(newMed.id) – expDate = \(newMed.expirationDate?.description ?? "nil")")
                        NotificationService.shared.scheduleExpiration(for: newMed)
                    }
                    self.onSave()
                    self.reset()
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func reset() {
        name                = ""
        dosageValueString   = ""
        dosageUnit          = "мг"
        hasExpirationDate   = false
        expirationDate      = Date()
        form                = "Таблетка"
        remainingCountString = ""
        errorMessage        = nil
    }
}
