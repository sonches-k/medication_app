//
//  Medication.swift
//  Tabletnica
//

import Foundation

struct Medication: Identifiable, Codable {
    let id: Int
    var name: String
    var dosageValue: Int
    var dosageUnit: String
    var expirationDate: Date?          
    var remainingCount: Int?
    var form: String
    
    var lastTakenDate: Date? = nil
    var lastSkippedDate: Date? = nil
    
}

