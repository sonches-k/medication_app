//
//  BarcodeServiceProtocol.swift
//  Tabletnica
//

import Foundation

protocol BarcodeServiceProtocol {
    func lookupMedication(barcode: String,
                          completion: @escaping (Result<Medication, Error>) -> Void)
}
