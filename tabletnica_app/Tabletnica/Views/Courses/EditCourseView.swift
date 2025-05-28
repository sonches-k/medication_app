//
//  EditCourseView.swift
//  Tabletnica
//

import SwiftUI

struct EditCourseView: View {
    @ObservedObject var viewModel: EditCourseViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var hasEndDate: Bool

    init(viewModel: EditCourseViewModel) {
        _viewModel   = ObservedObject(wrappedValue: viewModel)
        _hasEndDate  = State(initialValue: viewModel.endDate != nil)
    }

    var body: some View {
        NavigationStack {
            Form {
                recurrenceTypeSection()
                weeklyDaysSection()
                cycleSection()
                everyNDaysSection()
                asNeededNotesSection()
                timePickersSection()
                datePeriodSection()
            }
            .navigationTitle("Курс приёма")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func recurrenceTypeSection() -> some View {
        Section("Тип расписания") {
            Picker("Тип", selection: $viewModel.recurrenceType) {
                ForEach(RecurrenceType.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.menu)
        }
    }

    @ViewBuilder
    private func weeklyDaysSection() -> some View {
        if viewModel.recurrenceType == .weekly {
            Section(header: Text("Дни недели")) {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                    ForEach(Weekday.ordered) { day in
                        Button {
                            toggleDay(day)
                        } label: {
                            Text(day.shortName)
                                .frame(maxWidth: .infinity)
                                .padding(6)
                                .background(
                                    viewModel.weekDays.contains(day)
                                    ? Color.accentColor.opacity(0.8)
                                    : Color.gray.opacity(0.25)
                                )
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    @ViewBuilder
    private func cycleSection() -> some View {
        if viewModel.recurrenceType == .cycle {
            Section("Цикл") {
                HStack {
                    Text("Приём")
                    Spacer()
                    Picker("", selection: $viewModel.cycleWorkDays) {
                        ForEach(1...99, id:\.self) { Text("\($0)") }
                    }
                    .labelsHidden()
                    Text("дн.")
                }

                HStack {
                    Text("Перерыв")
                    Spacer()
                    Picker("", selection: $viewModel.cycleRestDays) {
                        ForEach(1...99, id:\.self) { Text("\($0)") }
                    }
                    .labelsHidden()
                    Text("дн.")
                }
            }
        }
    }

    @ViewBuilder
    private func everyNDaysSection() -> some View {
        if viewModel.recurrenceType == .everyNDays {
            Section("Частота") {
                Picker("Каждые … дней", selection: $viewModel.everyNDays) {
                    ForEach(1...30, id: \.self) { Text("\($0)") }
                }
                .pickerStyle(.wheel)
            }
        }
    }

    @ViewBuilder
    private func asNeededNotesSection() -> some View {
        if viewModel.recurrenceType == .asNeeded {
            Section("Комментарий") {
                TextField("Когда принимать", text: $viewModel.notes)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    @ViewBuilder
    private func timePickersSection() -> some View {
        Section("Время приёма") {
            ForEach($viewModel.times.indices, id: \.self) { idx in
                HStack {
                    DatePicker("Приём \(idx + 1)",
                               selection: $viewModel.times[idx],
                               displayedComponents: .hourAndMinute)
                    Spacer()
                    Button {
                        viewModel.times.remove(at: idx)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            Button {
                viewModel.times.append(Date())
            } label: {
                Label("Добавить время", systemImage: "plus.circle.fill")
            }
            .tint(.blue)
        }
    }

    @ViewBuilder
    private func datePeriodSection() -> some View {
        Section("Период") {
            DatePicker("Начало",
                       selection: $viewModel.startDate,
                       displayedComponents: .date)

            Toggle("Задать дату окончания", isOn: $hasEndDate.animation())

            if hasEndDate {
                DatePicker("Конец",
                           selection: Binding(
                               get: { viewModel.endDate ?? viewModel.startDate },
                               set: { viewModel.endDate = $0 }
                           ),
                           displayedComponents: .date)
            } else {
                EmptyView()
                    .onAppear {
                        viewModel.endDate = nil
                    }
            }
        }
    }

    private func toggleDay(_ day: Weekday) {
        if let idx = viewModel.weekDays.firstIndex(of: day) {
            viewModel.weekDays.remove(at: idx)
        } else {
            viewModel.weekDays.append(day)
        }
    }
}
