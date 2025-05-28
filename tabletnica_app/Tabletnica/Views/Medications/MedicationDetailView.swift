//
//  MedicationDetailView.swift
//  Tabletnica
//

import SwiftUI

struct MedicationDetailView: View {

    @ObservedObject var viewModel: MedicationDetailViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showingCourses   = false
    @State private var showingAddCourse = false

    var body: some View {
        List {
            Section("Информация") {
                labeledRow(title: "Название",  value: viewModel.name)
                labeledRow(title: "Дозировка", value: viewModel.dosageText)
                labeledRow(title: "Форма",     value: viewModel.original.form)

                if let exp = viewModel.expirationDateOpt {
                    labeledRow(
                        title: "Годен до",
                        value: exp.formatted(date: .abbreviated, time: .omitted)
                    )
                }
                if let cnt = viewModel.remainingCountOptional {
                    labeledRow(title: "Остаток", value: "\(cnt) шт.")
                }
            }

            if let summary = viewModel.activeCourseSummary {
                Section("Текущий курс") {
                    Text(summary)
                        .font(.subheadline)
                }
            }

            Section {
                NavigationLink {
                    EditMedicationView(medication: viewModel.original) { updated in
                        viewModel.apply(updated)
                    }
                } label: {
                    Text("Редактировать")
                }

                Button("Курсы приёма") { showingCourses = true }
                Button("Удалить", role: .destructive) {
                    viewModel.isDeleteAlertPresented = true
                }
            }
        }
        .navigationTitle(viewModel.name)
        .alert("Удалить препарат?", isPresented: $viewModel.isDeleteAlertPresented) {
            Button("Отмена", role: .cancel) {}
            Button("Удалить", role: .destructive) {
                viewModel.deleteMedication()
                dismiss()
            }
        }
        .sheet(isPresented: $showingCourses) {
            let coursesVM = CoursesListViewModel(medicationId: viewModel.original.id)
            CoursesListView(
                viewModel: coursesVM,
                showingAddCourse: $showingAddCourse
            )
        }
    }

    private func labeledRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
    }
}
