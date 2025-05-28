//
//  MockBarcodeService.swift
//  Tabletnica
//

import Foundation

final class MockBarcodeService: BarcodeServiceProtocol {
    func lookupMedication(barcode: String,
                          completion: @escaping (Result<Medication, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
            if barcode == "1234567890123" {
                let med = Medication(
                    id: Int(Date().timeIntervalSince1970),
                    name: "Аспирин (по коду)",
                    dosageValue: 100,
                    dosageUnit: "мг",
                    expirationDate: nil,
                    remainingCount: 0,
                    form: ""
                )
                completion(.success(med))
            } else {
                completion(.failure(NSError(
                    domain: "MockBarcode",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Не найдено по коду"]
                )))
            }
        }
    }
}
