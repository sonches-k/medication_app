//
//  CoursesListView.swift
//  Tabletnica
//

import SwiftUI

struct CoursesListView: View {

    @StateObject private var viewModel: CoursesListViewModel
    @Binding var showingAddCourse: Bool

    init(medicationId: Int, showingAddCourse: Binding<Bool>) {
        _viewModel        = StateObject(wrappedValue: CoursesListViewModel(medicationId: medicationId))
        _showingAddCourse = showingAddCourse
    }

    init(viewModel: CoursesListViewModel, showingAddCourse: Binding<Bool>) {
        _viewModel        = StateObject(wrappedValue: viewModel)
        _showingAddCourse = showingAddCourse
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.courses) { course in
                    NavigationLink {
                        EditCourseView(
                            viewModel: EditCourseViewModel(
                                course: course,
                                medicationId: viewModel.medicationId,
                                onSave: { viewModel.loadCourses() }
                            )
                        )
                    } label: {
                        courseRow(course)
                    }
                }
                .onDelete(perform: viewModel.deleteCourse)
            }
            .navigationTitle("Курсы")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddCourse = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear { viewModel.loadCourses() }
            .sheet(isPresented: $showingAddCourse) {
                EditCourseView(
                    viewModel: EditCourseViewModel(
                        medicationId: viewModel.medicationId
                    ) {
                        viewModel.loadCourses()
                        showingAddCourse = false
                    }
                )
            }
        }
    }

    @ViewBuilder
    private func courseRow(_ course: Course) -> some View {
        let medName = MockMedicationService.shared
            .medications                      
            .first { $0.id == course.medicationId }?
            .name ?? "Неизвестно"

        VStack(alignment: .leading, spacing: 2) {
            Text(medName)
                .font(.subheadline)

            Text(course.recurrenceType.rawValue)
                .font(.headline)

            Text("С \(course.startDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
