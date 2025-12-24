//
//  ActivityView.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//


import SwiftUI
import SwiftData
import FSCalendar

struct ActivityView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = ActivityViewModel()
    @State var showCalendar: Bool = false

    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 15) {
                // Header
                HStack {
                    Text("Activity")
                        .font(Font.largeTitle.bold())
                        .foregroundStyle(.white)

                    Spacer()

                    NavigationLink(destination: CalendarView(vm: vm)) {
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.clear)
                            .glassEffect(.clear)
                            .overlay {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(.white)
                            }
                    }

                    NavigationLink(destination: ChangeGoalView()) {
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.clear)
                            .glassEffect(.clear)
                            .overlay {
                                Image(systemName: "pencil.and.outline")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding()

                ZStack {
                    // Date Area
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.gray.opacity(0.1))
                        .frame(maxWidth: .infinity, minHeight: 254, maxHeight: 254)
                        .padding(.horizontal)
                        .overlay {
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1).frame(maxWidth: .infinity, minHeight: 254, maxHeight: 254)
                                .padding(.horizontal)
                        }
                        .padding(.bottom)

                    VStack(spacing: 20) {
                        HStack {
                            Text("\(vm.monthTitle(for: vm.currentPage))")
                                .font(.headline)
                                .foregroundStyle(.white)

                            if showCalendar {
                                Button {
                                    showCalendar.toggle()
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .bold()
                                        .foregroundStyle(._230)
                                }
                            } else {
                                Button {
                                    showCalendar.toggle()
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .bold()
                                        .foregroundStyle(._230)
                                }
                            }

                            Spacer()

                            Button {
                                vm.stepWeek(-1)
                            } label: {
                                Image(systemName: "chevron.left")
                                    .bold()
                                    .foregroundStyle(._230)
                            }

                            Button {
                                vm.stepWeek(+1)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .bold()
                                    .foregroundStyle(._230)
                            }
                        }
                        .padding(.horizontal)

                        FSCalendarMarkedView(
                            currentPage: Binding(
                                get: { vm.currentPage },
                                set: { vm.currentPage = $0 }
                            ),
                            markedDates: Binding(
                                get: { vm.markedDates },
                                set: { vm.markedDates = $0 }
                            ),
                            freezedDates: Binding(
                                get: { vm.freezedDates },
                                set: { vm.freezedDates = $0 }
                            ),
                            scope: .week,
                            scrollDirection: .horizontal
                        )
                    }
                    .padding()

                    VStack(spacing: 10) {
                        Spacer()

                        Rectangle()
                            .frame(height: 0.8)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 25)
                            .padding(.bottom, 5)

                        Text(vm.store?.goal ?? "Learning Swift")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 320, alignment: .bottomLeading)
                            .foregroundStyle(.white)
                            .padding(.bottom, 5)
                        

                        HStack {
                            RoundedRectangle(cornerRadius: 34)
                                .fill(._230.opacity(0.2))
                                .frame(width: 160, height: 69)
                                .overlay {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(._230)
                                        VStack(alignment: .leading) {
                                            Text("\(vm.store?.logDay ?? 0)")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundStyle(.white)
                                            if vm.store?.logDay == 1 {
                                                Text("Day Learned")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                            } else {
                                                Text("Days Learned")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }

                            RoundedRectangle(cornerRadius: 34)
                                .fill(._2_E_0.opacity(0.2))
                                .frame(width: 160, height: 69)
                                .overlay {
                                    HStack {
                                        Image(systemName: "cube.fill")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(._2_E_0)
                                        VStack(alignment: .leading) {
                                            Text("\(vm.store?.freezDay ?? 0)")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundStyle(.white)
                                            if vm.store?.freezDay == 1 {
                                                Text("Frozen Day")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                            } else {
                                                Text("Frozen Days")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 30)

                    // DatePicker
                    if showCalendar {
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { vm.currentPage },
                                set: { vm.currentPage = $0 }
                            ),
                            displayedComponents: [.date]
                        )
                        .padding(.horizontal)
                        .glassEffect(.clear, in: .rect)
                        .background()
                        .cornerRadius(10)
                        .datePickerStyle(.wheel)
                        .padding(.horizontal)
                        .padding(.top, 45)
                        .colorScheme(.dark)
                    }
                }

                // Activity
                if vm.totalDays >= vm.requiredDays {
                    VStack(spacing: 5) {
                        Spacer()

                        VStack {
                            Image(systemName: "hands.and.sparkles.fill")
                                .font(.system(size: 40, weight: .thin))
                                .foregroundStyle(._230)

                            Text("Will done!")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)

                            Text("Goal completed! start learning again or set new learning goal")
                                .frame(width: 338, height: 56)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                        }
                        .padding(.bottom, 50)
                        .padding(.top, 50)

                        Spacer()

                        Button {
                            vm.setNewLearningGoal()
                        } label: {
                            Text("Set new learning goal")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(width: 274, height: 56)
                                .glassEffect(.clear.tint(._230))
                        }

                        Button("Set same learning goal and duration") {
                            vm.setSameGoalAndDuration()
                        }
                        .foregroundStyle(._230)
                        .padding()
                    }
                } else {
                    Spacer()

                    if let s = vm.store, !s.didLogToday && !s.didFreezeToday {
                        Button {
                            vm.logAsLearned()
                        } label: {
                            Circle()
                                .frame(width: 274, height: 274)
                                .foregroundStyle(.clear)
                                .glassEffect(.clear.tint(._230))
                                .overlay(
                                    Text("Log as Learned")
                                        .font(.system(size: 40, weight: .bold))
                                        .frame(width: 200, height: 274)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                )
                        }
                    }

                    if let s = vm.store, s.didLogToday && !s.didFreezeToday {
                        Circle()
                            .frame(width: 274, height: 274)
                            .glassEffect(.clear.tint(Color._814))
                            .overlay(
                                Text("Learned Today")
                                    .font(.system(size: 40, weight: .bold))
                                    .frame(width: 200, height: 274)
                                    .foregroundStyle(._230)
                                    .multilineTextAlignment(.center)
                            )
                    }

                    if let s = vm.store, !s.didLogToday && s.didFreezeToday {
                        Circle()
                            .frame(width: 274, height: 274)
                            .glassEffect(.clear.tint(Color._2_E_0.opacity(0.4)))
                            .overlay(
                                Text("Frozen Day")
                                    .font(.system(size: 40, weight: .bold))
                                    .frame(width: 200, height: 274)
                                    .foregroundStyle(._2_E_0)
                                    .multilineTextAlignment(.center)
                            )
                    }

                    Spacer()

                    Button {
                        vm.logAsFreezed()
                    } label: {
                        Rectangle()
                            .frame(width: 274, height: 48)
                            .foregroundStyle(.clear)
                            .cornerRadius(25)
                            .glassEffect(
                                .clear.tint(
                                    ._2_E_0.opacity(
                                        (vm.store?.didFreezeToday ?? false) || (vm.store?.didLogToday ?? false) ? 0.2 : 1
                                    )
                                )
                            )
                            .overlay(
                                Text("Log as Frozen")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(.white)
                            )
                    }
                    .disabled(
                        (vm.store?.didLogToday ?? false) ||
                        (vm.store?.didFreezeToday ?? false) ||
                        ((vm.store?.freezDay ?? 0) >= vm.maxFreezes)
                    )

                    Text("\(vm.store?.freezDay ?? 0) out of \(vm.maxFreezes) Freezes used")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $vm.goToOnboarding) {
            OnBoardingView()
        }
        .onAppear {
            vm.setContext(context)
            vm.onAppear()
        }
    }
}

#Preview {
    ActivityView()
}
