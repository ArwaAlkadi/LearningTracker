//
//  OnBoardingView.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import SwiftData

struct OnBoardingView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = OnBoardingViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 50) {
                    VStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(._230)
                            .frame(width: 109, height: 109)
                            .glassEffect(.clear.tint(._814.opacity(0.6)))
                            .padding(.top, 25)
                    }

                    VStack(alignment: .leading, spacing: 9) {
                        Text("Hello Learner")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)

                        Text("This app will help you learn everyday!")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)

                        Text("I want to learn")
                            .font(.system(size: 22))
                            .padding(.top, 25)
                            .foregroundStyle(.white)

                        TextField("Write your goal here", text: Binding(
                            get: { vm.goal },
                            set: { vm.goal = $0 }
                        ))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .overlay(Rectangle().frame(height: 0.8).foregroundColor(.gray.opacity(0.5)),
                                 alignment: .bottom)

                        Text("\(vm.goal.count)/25")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)

                        Text("I want to learn it in a")
                            .font(.system(size: 22))
                            .padding(.top, 15)
                            .foregroundStyle(.white)

                        HStack(spacing: 10) {
                            GlassButton(
                                title: "Week",
                                isSelected: vm.selectedPlan == .week,
                                width: 97, height: 48,
                                selectedTint: ._230,
                                normalTint: .gray.opacity(0.2)
                            ) { vm.selectPlan(.week) }

                            GlassButton(
                                title: "Month",
                                isSelected: vm.selectedPlan == .month,
                                width: 97, height: 48,
                                selectedTint: ._230,
                                normalTint: .gray.opacity(0.2)
                            ) { vm.selectPlan(.month) }

                            GlassButton(
                                title: "Year",
                                isSelected: vm.selectedPlan == .year,
                                width: 97, height: 48,
                                selectedTint: ._230,
                                normalTint: .gray.opacity(0.2)
                            ) { vm.selectPlan(.year) }
                        }
                        .padding(.top, 5)
                    }

                    Spacer()

                    if let plan = vm.selectedPlan, vm.hasGoal {
                        GlassButton(
                            title: "Start learning",
                            isSelected: true,
                            width: 182, height: 48,
                            selectedTint: ._230,
                            normalTint: .gray.opacity(0.2)
                        ) {
                            vm.startLearning(with: plan)
                            path.append(plan)
                        }
                    } else {
                        GlassButton(
                            title: "Start learning",
                            isSelected: false,
                            width: 182, height: 48,
                            selectedTint: .gray.opacity(0.1),
                            normalTint: .gray.opacity(0.1)
                        ) { }
                        .disabled(true)
                    }
                }
                .padding()
            }
            .navigationDestination(for: Plan.self) { _ in
                ActivityView()
            }
        }
        .onAppear {
            vm.setContext(context)
        }
        .toolbarVisibility(.hidden)
        
    }
    
}

#Preview {
    OnBoardingView()
}

struct GlassButton: View {
    var title: String
    var isSelected: Bool
    var width: CGFloat
    var height: CGFloat
    var selectedTint: Color
    var normalTint: Color
    var action: () -> Void

   
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: width, height: height)
                .glassEffect(.clear.tint(isSelected ? selectedTint : normalTint))
               
        }
    }
}

