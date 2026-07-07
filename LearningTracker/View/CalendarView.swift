//
//  CalendarView.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @ObservedObject var vm: ActivityViewModel
    let start = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<90, id: \.self) { offset in
                        let date = Calendar.current.date(byAdding: .month, value: offset, to: start)!

                        Text(vm.monthTitle(for: date))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading)

                        FSCalendarMarkedView(
                            currentPage: .constant(date),
                            markedDates: $vm.markedDates,
                            freezedDates: $vm.freezedDates,
                            scope: .month,
                            scrollDirection: .vertical
                        )
                        .frame(height: 260)
                        .id(offset)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray.opacity(0.3))
                            .padding(.bottom, 30)
                    }
                    
                   
                    
                }
                .padding(.vertical)
                .padding(.horizontal)
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("All activities")
                }
            }
            .onAppear {
                scrollToCurrentMonth(proxy: proxy, start: start)
            }
        }
    }

    
}

#Preview {
    CalendarView(vm: .init())
}
