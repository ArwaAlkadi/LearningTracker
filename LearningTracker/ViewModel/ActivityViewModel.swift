//
//  ActivityViewModel.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import SwiftData
import Combine
import UserNotifications

final class ActivityViewModel: ObservableObject {
    @Published var store: LearningStore? = nil
    @Published var selectedDate = Date()
    @Published var currentPage = Date()
    @Published var goToOnboarding = false
    @Published var markedDates: Set<String> = {
        let saved = UserDefaults.standard.array(forKey: "markedDates") as? [String] ?? []
        return Set(saved)
    }()
    @Published var freezedDates: Set<String> = {
            let saved = UserDefaults.standard.array(forKey: "freezedDates") as? [String] ?? []
            return Set(saved)
        }()
    
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        ensureStore()
    }

    var currentPlan: Plan {
        switch store?.plan {
        case "week": .week
        case "month": .month
        case "year": .year
        default: .year
        }
    }

    var requiredDays: Int {
        switch currentPlan {
        case .week: 7
        case .month: 30
        case .year: 365
        }
    }

    var maxFreezes: Int {
        switch currentPlan {
        case .week: 2
        case .month: 8
        case .year: 96
        }
    }

    var totalDays: Int {
        (store?.logDay ?? 0) + (store?.freezDay ?? 0)
    }

    func onAppear() {
        checkResetIfNeeded()
        
        if let s = store {
            if isNewDay(since: s.lastLogDate) {
                s.didLogToday = false
                s.lastLogDate = Date()
            }
            if isNewDay(since: s.lastFreezeDate) {
                s.didFreezeToday = false
                s.lastFreezeDate = Date()
            }
            try? context?.save()
        }
        requestNotificationPermission()
    }

    func isNewDay(since lastDate: Date?) -> Bool {
        guard let last = lastDate else { return true }
        return !Calendar.current.isDateInToday(last)
    }

    func checkResetIfNeeded() {
        if let last = store?.lastLogTime {
            let hoursPassed = Date().timeIntervalSince(last) / 3600
            if hoursPassed > 32 {
                store?.logDay = 0
                store?.freezDay = 0
            }
        }
    }

    func stepWeek(_ n: Int) {
        currentPage = Calendar.current.date(byAdding: .weekOfMonth, value: n, to: currentPage) ?? currentPage
    }

    func monthTitle(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f.string(from: date)
    }

    func logAsLearned() {
        guard let store else { return }
        store.didLogToday = true
        store.logDay += 1
        store.lastLogDate = Date()
        store.lastFreezeDate = Date()
        try? context?.save()
        
        if totalDays < requiredDays {
            rescheduleStreakWarning(from: store.lastLogDate!)
        }
        let key = dayKey(Date())
        markedDates.insert(key)
        UserDefaults.standard.set(Array(markedDates), forKey: "markedDates")
    }

    func logAsFreezed() {
        guard let store else { return }
        guard !store.didLogToday && !store.didFreezeToday && store.freezDay < maxFreezes else { return }
        store.didFreezeToday = true
        store.freezDay += 1
        store.lastFreezeDate = Date()
        store.lastLogTime = Date()
        try? context?.save()
        
        if totalDays < requiredDays {
            rescheduleStreakWarning(from: store.lastFreezeDate!)
        }
        let key = dayKey(Date())
        freezedDates.insert(key)
        UserDefaults.standard.set(
            Array(freezedDates),
            forKey: "freezedDates"
        )
    }

    func setNewLearningGoal() {
        guard let s = store else { return }
        goToOnboarding = true
        s.plan = ""
        s.goal = ""
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
        try? context?.save()
    }

    func setSameGoalAndDuration() {
        guard let s = store else { return }
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
        try? context?.save()
    }

    private func ensureStore() {
        guard store == nil, let context else { return }
        if let first = try? context.fetch(FetchDescriptor<LearningStore>()).first {
            store = first
        } else {
            let s = LearningStore()
            context.insert(s)
            store = s
            try? context.save()
        }
    }
}

private let streakWarningId = "streakWarning"

func rescheduleStreakWarning(from lastLog: Date) {

    let warningAfter: TimeInterval = 22 * 3600
    let elapsed = Date().timeIntervalSince(lastLog)
    var secondsUntilWarning = warningAfter - elapsed

    if secondsUntilWarning < 0 {
        secondsUntilWarning = 0
    }

    guard secondsUntilWarning > 60 else { return }

    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [streakWarningId])

    let content = UNMutableNotificationContent()
    content.title = "Don't lose your streak!"
    content.body = "Only 10 hours left to log in and keep your progress going"
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsUntilWarning, repeats: false)

    let request = UNNotificationRequest(identifier: streakWarningId, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
}
