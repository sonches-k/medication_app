//
//  MedicationsListView.swift
//  Tabletnica
//

import SwiftUI

struct MedicationsListView: View {
    @ObservedObject var viewModel: MedicationsListViewModel
    @Binding var showingAdd: Bool
    
    private enum ExpStatus { case ok, soon(Int), expired }
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.medications) { med in
                    NavigationLink {
                        MedicationDetailView(
                            viewModel: MedicationDetailViewModel(
                                medication: med,
                                onSave: { viewModel.loadMedications() }
                            )
                        )
                    } label: {
                        medicationRow(med)
                    }
                }
                .onDelete { viewModel.deleteMedication(at: $0) }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Мои препараты")
            .onAppear { viewModel.loadMedications() }
            .alert("Ошибка", isPresented: errorBinding) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: { Text(viewModel.errorMessage ?? "") }
        }
    }

    @ViewBuilder
    private func medicationRow(_ med: Medication) -> some View {
        let expStatus: ExpStatus = {
            guard let exp = med.expirationDate else { return .ok }
            let days = Calendar.current.dateComponents([.day], from: Date(), to: exp).day ?? 999
            if days < 0       { return .expired }
            if days <= 7      { return .soon(days) }
            return .ok
        }()
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(med.name).font(.headline)
                    Text(med.form).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()

                if let cnt = med.remainingCount {
                    Text("\(cnt) шт.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                switch expStatus {
                case .soon(let d):
                    Text("⏰ \(d) дн.")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Capsule())

                case .expired:
                    Text("⚠️ Истёк")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color.red.opacity(0.2))
                        .clipShape(Capsule())

                case .ok: EmptyView()
                }
            }
            if let taken = med.lastTakenDate,
               Calendar.current.isDateInToday(taken) {

                Text("🟢 Принято сегодня")
                    .font(.caption)
                    .foregroundStyle(.green)

            } else if let skipped = med.lastSkippedDate,
                      Calendar.current.isDateInToday(skipped) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("🔴 Пропущено сегодня")
                        .font(.caption)
                        .foregroundStyle(.red)

                    Button("Принято") { viewModel.markAsTaken(med) }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                }

            } else {
                HStack {
                    Button("Пропущено") { viewModel.markAsSkipped(med) }
                        .buttonStyle(.bordered)
                        .controlSize(.small)

                    Button("Принято") { viewModel.markAsTaken(med) }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get:  { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}
