//
//  AddMedicationView.swift
//  Tabletnica
//

import SwiftUI

struct AddMedicationView: View {
    @StateObject var viewModel: AddMedicationViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: AddMedicationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Название препарата") {
                    TextField("Аспирин", text: $viewModel.name)
                }
                Section("Дозировка") {
                    HStack {
                        TextField("500", text: $viewModel.dosageValueString)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 80)
                        Picker("", selection: $viewModel.dosageUnit) {
                            ForEach(["мг", "мл", "таб.", "кап.", "доза"], id: \.self) {
                                Text($0)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                }
                Picker("Форма", selection: $viewModel.form) {
                        ForEach(viewModel.medicationForms, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                
                Section("Срок годности") {
                    Toggle("Указать срок годности", isOn: $viewModel.hasExpirationDate)
                    if viewModel.hasExpirationDate {
                        DatePicker(
                            "Дата",
                            selection: $viewModel.expirationDate,
                            displayedComponents: .date
                        )
                    }
                }
                
                Section("Количество в упаковке (опц.)") {
                    TextField("Напр. 30", text: $viewModel.remainingCountString)
                        .keyboardType(.numberPad)
                }
                
                if let err = viewModel.errorMessage {
                    Section {
                        Text(err)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Новый препарат")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        viewModel.reset()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        viewModel.save()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}

struct AddMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicationView(
            viewModel: AddMedicationViewModel(onSave: {})
        )
    }
}
