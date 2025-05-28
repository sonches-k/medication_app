//
//  Extensions.swift
//  Tabletnica
//

import Foundation
import Combine
import SwiftUI

extension Binding where Value == Date? {
    func replacingNil(with defaultValue: Date) -> Binding<Date> {
        Binding<Date>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
