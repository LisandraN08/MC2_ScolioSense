//
//  MC2_ScolioSenseApp.swift
//  MC2_ScolioSense
//
//  Created by Lisandra Nicoline on 22/05/24.
//

import SwiftUI
import SwiftData

@main
struct MC2_ScolioSenseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            mainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
