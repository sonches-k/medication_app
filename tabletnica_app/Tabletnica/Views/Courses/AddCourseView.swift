//
//  AddCourseView.swift
//  Tabletnica
//

import SwiftUI

struct AddCourseView: View {
    @ObservedObject var viewModel: AddCourseViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Тип расписания")) {
                    Picker("Тип", selection: $viewModel.recurrenceType) {
                        ForEach(RecurrenceType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

                if viewModel.recurrenceType == .weekly {
                    Section(header: Text("Дни недели")) {
                        HStack {
                            ForEach(Weekday.allCases) { day in
                                Button(day.shortName) {
                                    toggleDay(day)
                                }
                                .font(.caption)
                                .padding(6)
                                .background(viewModel.weekDays.contains(day) ? Color.accentColor.opacity(0.7) : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }

                if viewModel.recurrenceType == .cycle {
                    Section(header: Text("Цикл")) {
                        Stepper("Приём: \(viewModel.cycleWorkDays) дн.", value: $viewModel.cycleWorkDays, in: 1...99)
                        Stepper("Перерыв: \(viewModel.cycleRestDays) дн.", value: $viewModel.cycleRestDays, in: 1...99)
                    }
                }

                if viewModel.recurrenceType == .everyNDays {
                    Section(header: Text("Частота")) {
                        Stepper("Каждые \(viewModel.everyNDays) дней", value: $viewModel.everyNDays, in: 1...30)
                    }
                }

                if viewModel.recurrenceType == .asNeeded {
                    Section(header: Text("Комментарий")) {
                        TextField("Когда принимать", text: $viewModel.notes)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section(header: Text("Время приёма")) {
                    ForEach($viewModel.times.indices, id: \.self) { index in
                        DatePicker("Приём \(index + 1)", selection: $viewModel.times[index], displayedComponents: .hourAndMinute)
                    }
                    Button("Добавить время") {
                        viewModel.times.append(Date())
                    }
                    .foregroundColor(.blue)
                }

                Section(header: Text("Период")) {
                    DatePicker("Начало", selection: $viewModel.startDate, displayedComponents: .date)
                    DatePicker("Конец", selection: $viewModel.endDate.replacingNil(with: Date()), displayedComponents: .date)
                }
            }
            .navigationTitle("Добавить курс")
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

    private func toggleDay(_ day: Weekday) {
        if let index = viewModel.weekDays.firstIndex(of: day) {
            viewModel.weekDays.remove(at: index)
        } else {
            viewModel.weekDays.append(day)
        }
    }
}


