//
//  WeekdaySelectionView.swift
//  Tabletnica
//

import SwiftUI

struct WeekdaySelectionView: View {
    @Binding var selection: Set<Weekday>

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Weekday.allCases) { day in
                Text(day.shortName)
                    .font(.subheadline.weight(.medium))
                    .padding(8)
                    .background(selection.contains(day) ? .accentColor : Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    .onTapGesture {
                        if selection.contains(day) {
                            selection.remove(day)
                        } else {
                            selection.insert(day)
                        }
                    }
            }
        }
        .padding(.vertical, 4)
    }
}
