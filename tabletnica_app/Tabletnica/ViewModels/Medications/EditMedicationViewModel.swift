//
//  EditMedicationViewModel.swift
//  Tabletnica
//

import Foundation

final class EditMedicationViewModel: ObservableObject {

    @Published var name: String
    @Published var dosageValue: Int
    @Published var dosageUnit: String
    @Published var expirationDate: Date
    @Published var remainingCountString: String

    @Published var errorMessage: String?
    @Published var isLoading = false

    var dosageValueString: String {
        get { String(dosageValue) }
        set { dosageValue = Int(newValue) ?? 0 }
    }
    var remainingCountValue: Int? {
        let n = Int(remainingCountString) ?? 0
        return n == 0 ? nil : n
    }

    var dosageText: String { "\(dosageValue) \(dosageUnit)" }

    private let original: Medication
    private let service: MedicationServiceProtocol
    private let onSave: (Medication) -> Void

    init(
        medication: Medication,
        service: MedicationServiceProtocol = MockMedicationService.shared,
        onSave: @escaping (Medication) -> Void
    ) {
        self.original   = medication
        self.service    = service
        self.onSave     = onSave

        name            = medication.name
        dosageValue     = medication.dosageValue
        dosageUnit      = medication.dosageUnit
        expirationDate  = medication.expirationDate ?? Date()
        remainingCountString = medication.remainingCount.map { String($0) } ?? ""
    }

    func save() {
        guard dosageValue > 0 else {
            errorMessage = "Введите корректную дозировку"
            return
        }

        if let txt = Int(remainingCountString), txt < 0 {
            errorMessage = "Остаток не может быть отрицательным"
            return
        }

        isLoading = true
        errorMessage = nil

        var updated = original
        updated.name           = name
        updated.dosageValue    = dosageValue
        updated.dosageUnit     = dosageUnit
        updated.expirationDate = expirationDate
        updated.remainingCount = remainingCountValue
        
        
        NotificationService.shared.cancelExpiration(for: original.id)

        service.updateMedication(updated) { [weak self] res in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch res {
                case .success(let saved):
                    NotificationService.shared.scheduleExpiration(for: saved)
                    self.onSave(saved)                       
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
