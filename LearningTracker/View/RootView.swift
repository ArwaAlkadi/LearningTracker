//
//  RootView.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context
    @Query private var stores: [LearningStore]

    var body: some View {
        NavigationStack {
            if let store = stores.first {
                if store.didBoard {
                    ActivityView()
                } else {
                   OnBoardingView()
                }
            } else {
               OnBoardingView()
            }
        }
       
    }
}
