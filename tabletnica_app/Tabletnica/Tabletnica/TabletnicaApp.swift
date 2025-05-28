//
//  TabletnicaApp.swift
//  Tabletnica
//

import SwiftUI

@main
struct TabletnicaApp: App {
    @StateObject private var router = AppRouter.shared

    init() {
        NotificationManager.shared.configure()
        if Persistence.shared.hasValidToken {
            router.didAuthenticate()
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if router.isAuthenticated {
                    MainView()
                } else {
                    LoginView()
                }
            }
            .onOpenURL { url in
                MockMedicationService.shared.mark(from: url)
            }
        }
    }
}

