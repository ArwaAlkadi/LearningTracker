//
//  ChangeGoalViewModel.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import SwiftData
import Combine

final class ChangeGoalViewModel: ObservableObject {
    @Published var store: LearningStore? = nil
    @Published var selectedPlan: Plan? = nil
    @Published var goToNext = false
    @Published var confirmUpdateAlert = false
    @Published var noChangeAlert = false
    @Published var goal: String = "" {
        didSet {
            if goal.count > 25 {
                goal = String(goal.prefix(25))
            }
        }
    }

    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
    }

    func onAppear() {
        ensureStore()
        if let s = store {
            if goal.isEmpty { goal = s.goal }
            if selectedPlan == nil { selectedPlan = planFromString(s.plan) }
        }
    }

    func back() {
        goToNext = true
    }

    func confirmUpdate() {
            guard let s = store, let plan = selectedPlan else { return }

            let newGoal = goal
            let newPlan = planString(plan)

        let changed = (newPlan != s.plan || newGoal != s.goal)
        
            if changed {
                confirmUpdateAlert = true
            } else {
                noChangeAlert = true
            }
        } 

    func dismissAlert() {
        confirmUpdateAlert = false
        noChangeAlert = false
    }

    func applyUpdate() {
        guard let plan = selectedPlan, !goal.isEmpty else { return }
        ensureStore()
        guard let s = store, let context else { return }
        let newPlanStr = planString(plan)
        if s.goal != goal || s.plan != newPlanStr {
            s.didLogToday = false
            s.didFreezeToday = false
            s.logDay = 0
            s.freezDay = 0
            s.streak = 0
            s.lastLogTime = nil
            s.lastLogDate = nil
            s.lastFreezeDate = nil
            s.selectedDate = Date()
            s.currentPage = Date()
        }
        s.goal = goal
        s.plan = newPlanStr
        try? context.save()
        goToNext = true
    }

    private func ensureStore() {
        guard store == nil else { return }
        guard let context else { return }
        if let first = try? context.fetch(FetchDescriptor<LearningStore>()).first {
            store = first
        } else {
            let s = LearningStore()
            context.insert(s)
            store = s
            try? context.save()
        }
    }

    private func planString(_ p: Plan) -> String {
        switch p { case .week: "week"; case .month: "month"; case .year: "year" }
    }

    private func planFromString(_ s: String) -> Plan? {
        switch s { case "week": .week; case "month": .month; case "year": .year; default: nil }
    }
}
