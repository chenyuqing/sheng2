//
//  sheng2App.swift
//  sheng2
//
//  Created by Tim on 11/6/25.
//

import SwiftUI
import SwiftData

@main
struct sheng2App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            VoiceSample.self,
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
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}