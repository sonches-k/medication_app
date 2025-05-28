//
//  MainView.swift
//  Tabletnica
//

import SwiftUI

struct MainView: View {
    @StateObject private var medsVM = MedicationsListViewModel(
        service: MockMedicationService.shared
    )
    @State private var showingAdd = false
    @State private var showingProfile = false

    var body: some View {
        NavigationStack {
            TabView {
                MedicationsListView(
                    viewModel: medsVM,
                    showingAdd: $showingAdd
                )
                .tag(0)
                .tabItem {
                    Label("Трекер", systemImage: "pills")
                }
                CalendarView()
                    .tabItem {
                        Label("Календарь", systemImage: "calendar")
                    }
            }
            .navigationTitle("Tabletnica")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddMedicationView(
                    viewModel: AddMedicationViewModel(
                        service: MockMedicationService.shared,
                        onSave: {
                            medsVM.loadMedications()
                            showingAdd = false
                        }
                    )
                )
            }
            .sheet(isPresented: $showingProfile) {
                let user = Persistence.shared.getUser() ??
                           User(
                               id: UUID(),
                               name: "",
                               email: "",
                               phone: "",
                               age: 0,
                               height: 0,
                               weight: 0,
                               avatarData: nil
                           )
                ProfileView(user: user) {
                    Persistence.shared.clearAll()
                    AppRouter.shared.signOut()
                    showingProfile = false
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
