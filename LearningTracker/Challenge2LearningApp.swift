//
//  Challenge2LearningApp.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 16/10/2025.
//

import SwiftUI
import SwiftData

@main
struct Challenge2LearningApp: App {
    var body: some Scene {
        WindowGroup {
            
           RootView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: LearningStore.self)
    }
}
