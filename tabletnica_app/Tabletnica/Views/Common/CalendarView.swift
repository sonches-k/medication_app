//
//  Untitled.swift
//  Tabletnica
//
//  Created by Соня on 25.05.2025.
//
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var vm = CalendarViewModel()

    private var ruCal: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 2
        return c
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                DatePicker(
                    "Дата",
                    selection: $vm.selectedDate,
                    displayedComponents: .date
                )
                .environment(\.locale, .init(identifier: "ru_RU"))
                .environment(\.calendar, ruCal)
                .datePickerStyle(.graphical)
                .padding(.horizontal)

                if vm.entriesForSelected.isEmpty {
                    ContentUnavailableView("Записей нет", systemImage: "checkmark.circle")
                        .padding(.top, 32)
                } else {
                    List(vm.entriesForSelected, rowContent: entryRow)
                }
            }
            .navigationTitle(
                vm.selectedDate.formatted(
                    .dateTime.day().month(.wide).year()
                )
            )
            .task { vm.load() }
        }
    }

    @ViewBuilder
    private func entryRow(_ e: CalendarEntry) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(e.name)
                Text(e.id, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            switch e.taken {
            case .some(true):  Text("✅").font(.title3)
            case .some(false): Text("❌").font(.title3)
            case .none:        Text("⏳").font(.title3)
            }
        }
    }
}
