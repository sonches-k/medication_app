//
//  MockMedicationService.swift
//  Tabletnica
//

import Foundation

final class MockMedicationService: MedicationServiceProtocol {
    static let shared = MockMedicationService()
    private init() {}

    private let queue = DispatchQueue(label: "mock.medication.service")

    var medications: [Medication] {
        queue.sync { SharedStorage.loadMeds() }
    }

    private var meds: [Medication] {
        get { SharedStorage.loadMeds() }
        set { SharedStorage.saveMeds(newValue) }
    }

    func fetchMedications(
        completion: @escaping (Result<[Medication], Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            completion(.success(self.meds))
        }
    }

    func addMedication(
        _ medication: Medication,
        completion: @escaping (Result<Medication, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            var arr = self.meds
            arr.append(medication)
            self.meds = arr
            completion(.success(medication))
        }
    }

    func updateMedication(
        _ medication: Medication,
        completion: @escaping (Result<Medication, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            var arr = self.meds
            if let idx = arr.firstIndex(where: { $0.id == medication.id }) {
                arr[idx] = medication
                self.meds = arr
                completion(.success(medication))
            } else {
                completion(.failure(NSError(
                    domain: "", code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Not found"]
                )))
            }
        }
    }

    func deleteMedication(
        _ id: Int,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        queue.asyncAfter(deadline: .now() + 0.2) {
            var arr = self.meds
            if let idx = arr.firstIndex(where: { $0.id == id }) {
                arr.remove(at: idx)
                self.meds = arr
                completion(.success(()))
            } else {
                completion(.failure(NSError(
                    domain: "", code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Not found"]
                )))
            }
        }
    }

    func markAsTaken(_ id: Int) {
        queue.async {
            var arr = self.meds
            guard let idx = arr.firstIndex(where: { $0.id == id }) else { return }
            var updated = arr[idx]
            updated.lastTakenDate = Date()
            if let cnt = updated.remainingCount, cnt > 0 {
                updated.remainingCount = cnt - 1
            }
            arr[idx] = updated
            self.meds = arr
        }
    }

    func markAsSkipped(_ id: Int) {
        queue.async {
            var arr = self.meds
            guard let idx = arr.firstIndex(where: { $0.id == id }) else { return }
            var updated = arr[idx]
            updated.lastSkippedDate = Date()
            updated.lastTakenDate = nil
            arr[idx] = updated
            self.meds = arr
        }
    }

    func fetchSync() -> Result<[Medication], Error> {
        var result: Result<[Medication], Error>!
        let sem = DispatchSemaphore(value: 0)
        fetchMedications { res in
            result = res
            sem.signal()
        }
        sem.wait()
        return result
    }

    func mark(from url: URL) {
        guard
            url.scheme == "tabletnica",
            let action = url.host,
            ["taken","skipped"].contains(action),
            let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
            let id   = items.first(where: { $0.name == "id" })?.value.flatMap(Int.init),
            let ts   = items.first(where: { $0.name == "ts" })?.value.flatMap(Double.init)
        else { return }

        queue.async {
            var arr = self.meds
            guard let idx = arr.firstIndex(where: { $0.id == id }) else { return }
            var updated = arr[idx]
            if action == "taken" {
                updated.lastTakenDate = Date(timeIntervalSince1970: ts)
            } else {
                updated.lastSkippedDate = Date(timeIntervalSince1970: ts)
            }
            arr[idx] = updated
            self.meds = arr
        }
    }
}
