//
//  Model.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 21/10/2025.
//

import SwiftData
import Foundation

@Model
final class LearningStore {
    var didBoard: Bool
    var goal: String
    var plan: String
    var didLogToday: Bool
    var didFreezeToday: Bool
    var logDay: Int
    var freezDay: Int
    var lastLogDate: Date?
    var lastFreezeDate: Date?
    var lastLogTime: Date?
    var streak: Int
    var selectedDate: Date
    var currentPage: Date

    init(
        goal: String = "",
        plan: String = "year",
        didLogToday: Bool = false,
        didFreezeToday: Bool = false,
        didBoard: Bool = false,
        logDay: Int = 0,
        freezDay: Int = 0,
        lastLogDate: Date? = nil,
        lastFreezeDate: Date? = nil,
        lastLogTime: Date? = nil,
        streak: Int = 0,
        selectedDate: Date = .now,
        currentPage: Date = .now
    ) {
        self.goal = goal
        self.plan = plan
        self.didLogToday = didLogToday
        self.didFreezeToday = didFreezeToday
        self.logDay = logDay
        self.freezDay = freezDay
        self.lastLogDate = lastLogDate
        self.lastFreezeDate = lastFreezeDate
        self.lastLogTime = lastLogTime
        self.streak = streak
        self.selectedDate = selectedDate
        self.currentPage = currentPage
        self.didBoard = didBoard
    }
}

enum Plan: Hashable {
    case week, month, year
}
