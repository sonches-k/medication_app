//
//  MedicationsListViewModel.swift
//  Tabletnica
//

import Foundation

final class MedicationsListViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var errorMessage: String?

    private let service: MedicationServiceProtocol

    init(service: MedicationServiceProtocol = MockMedicationService.shared) {
        self.service = service
    }

    func loadMedications() {
        service.fetchMedications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.medications = list
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func deleteMedication(at offsets: IndexSet) {
        offsets.forEach { idx in
            let med = medications[idx]
            service.deleteMedication(med.id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.medications.remove(at: idx)
                    case .failure(let err):
                        self?.errorMessage = err.localizedDescription
                    }
                }
            }
        }
    }
    
    func markAsTaken(_ med: Medication) {
        MockMedicationService.shared.markAsTaken(med.id)
        loadMedications()
    }

    func markAsSkipped(_ med: Medication) {
        MockMedicationService.shared.markAsSkipped(med.id)
        loadMedications()
    }
}
