//
//  MedicationServiceProtocol.swift
//  Tabletnica
//

import Foundation

protocol MedicationServiceProtocol {
    func fetchMedications(
        completion: @escaping (Result<[Medication], Error>) -> Void
    )
    func addMedication(
        _ medication: Medication,
        completion: @escaping (Result<Medication, Error>) -> Void
    )
    func updateMedication(
        _ medication: Medication,
        completion: @escaping (Result<Medication, Error>) -> Void
    )
    func deleteMedication(
        _ id: Int,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
