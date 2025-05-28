//
//  EditMedicationView.swift
//  Tabletnica
//

import SwiftUI

struct EditMedicationView: View {
    @StateObject private var viewModel: EditMedicationViewModel
    @Environment(\.dismiss) private var dismiss

    init(medication: Medication,
             onSave: @escaping (Medication) -> Void) {
            _viewModel = StateObject(
                wrappedValue: EditMedicationViewModel(
                    medication: medication,
                    onSave: { med in
                        onSave(med)
                    }
                )
            )
        }

    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Аспирин", text: $viewModel.name)
                }

                Section("Дозировка") {
                    HStack {
                        TextField("500", text: $viewModel.dosageValueString)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 80)

                        Picker("", selection: $viewModel.dosageUnit) {
                            ForEach(["мг","мл","таб.","кап.","доза"], id: \.self) { Text($0) }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                }

                Section("Срок годности") {
                    DatePicker("Дата", selection: $viewModel.expirationDate, displayedComponents: .date)
                }

                Section("Осталось шт.") {
                    TextField("Остаток", text: $viewModel.remainingCountString)
                        .keyboardType(.numberPad)
                }

                if let err = viewModel.errorMessage {
                    Section { Text(err).foregroundColor(.red).font(.caption) }
                }
            }
            .navigationTitle("Редактировать")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        viewModel.save();
                        dismiss()
                    }
                        .disabled(viewModel.isLoading)
                }
            }
        }
    }
}
