//
//  CalendarViewModel .swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 24/10/2025.
//

import SwiftUI
import FSCalendar

struct FSCalendarMarkedView: UIViewRepresentable {
    @Binding var currentPage: Date
    @Binding var markedDates: Set<String>
    @Binding var freezedDates: Set<String>
    
    var scope: FSCalendarScope = .week
    var scrollDirection: FSCalendarScrollDirection = .horizontal
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> FSCalendar {
        let cal = FSCalendar()
        cal.delegate = context.coordinator
        cal.dataSource = context.coordinator
        cal.scope = scope
        cal.scrollDirection = scrollDirection
        cal.placeholderType = .none
        cal.headerHeight = 0
        cal.scrollEnabled = false
        cal.backgroundColor = .clear
        cal.setCurrentPage(currentPage, animated: false)
        cal.allowsSelection = false
        
        cal.appearance.weekdayTextColor = .lightGray
        cal.appearance.titleDefaultColor = .white
        cal.appearance.headerTitleColor = .white
        cal.appearance.headerTitleFont = .systemFont(ofSize: 17, weight: .semibold)
        cal.appearance.headerTitleAlignment = .center
        cal.appearance.headerMinimumDissolvedAlpha = 0.0
        cal.appearance.titleFont = .systemFont(ofSize: 24, weight: .semibold)
        cal.appearance.todayColor = ._230

        return cal
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        if uiView.currentPage != currentPage {
            uiView.setCurrentPage(currentPage, animated: true)
        }
        uiView.reloadData()
    }
    
    final class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarMarkedView
        init(_ parent: FSCalendarMarkedView) { self.parent = parent }
        
        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      fillDefaultColorFor date: Date) -> UIColor? {
            let key = dayKey(date)
            if parent.markedDates.contains(key) {
                return UIColor._230.withAlphaComponent(0.3)
            } else if parent.freezedDates.contains(key) {
                return UIColor._2_E_0.withAlphaComponent(0.3)
            }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      titleDefaultColorFor date: Date) -> UIColor? {
            
            let key = dayKey(date)
            
            if parent.markedDates.contains(key) {
                return UIColor._230
            } else if parent.freezedDates.contains(key) {
                return UIColor._2_E_0
            } else {
                return UIColor.white
            }
        }
    }
}

func dayKey(_ date: Date) -> String {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f.string(from: Calendar.current.startOfDay(for: date))
}

func scrollToCurrentMonth(proxy: ScrollViewProxy, start: Date) {
    let cal = Calendar.current
    let todayMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: Date()))!
    let startMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: start))!
    let diff = cal.dateComponents([.month], from: startMonthStart, to: todayMonthStart).month ?? 0
    let target = max(0, min(89, diff))
    withAnimation {
        proxy.scrollTo(target, anchor: .top)
    }
}
