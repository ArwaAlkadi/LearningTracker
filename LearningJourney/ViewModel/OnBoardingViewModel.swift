//
//  OnBoardingViewModel.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import SwiftData
import Combine

final class OnBoardingViewModel: ObservableObject {
    @Published var store: LearningStore? = nil
    @Published var selectedPlan: Plan? = nil

    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        ensureStore()
    }

    var goal: String {
        get { store?.goal ?? "" }
        set {
            guard context != nil else { return }
            let limited = String(newValue.prefix(25))
            store?.goal = limited
        }
    }
    
    var hasGoal: Bool {
        !goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func selectPlan(_ p: Plan) {
        selectedPlan = p
    }

    func startLearning(with plan: Plan) {
        guard let context else { return }
        store?.didBoard = true
        try? context.save()
        ensureStore()
        guard let store else { return }
        store.plan = planString(plan)
        try? context.save()
    }

    private func planString(_ p: Plan) -> String {
        switch p { case .week: "week"; case .month: "month"; case .year: "year" }
    }

    private func ensureStore() {
        guard store == nil, let context else { return }
        if let first = try? context.fetch(FetchDescriptor<LearningStore>()).first {
            store = first
        } else {
            let s = LearningStore()
            context.insert(s)
            store = s
        }
    }
}
