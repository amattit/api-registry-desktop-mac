//
//  api_registry_descktopApp.swift
//  api-registry-descktop
//
//  Created by seregin-ma on 01.12.2025.
//

import SwiftUI
import SwiftData
import ar_services

@main
struct api_registry_descktopApp: App {
    let factory = ARServicesFactory()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            factory.makeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
