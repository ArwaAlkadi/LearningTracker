//
//  ChangeGoalView.swift
//  Challenge2Learning
//
//  Created by Arwa Alkadi on 22/10/2025.
//

import SwiftUI
import SwiftData

struct ChangeGoalView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = ChangeGoalViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack {
                    Button { vm.back() } label: {
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.clear)
                            .glassEffect(.clear)
                            .overlay {
                                Image(systemName: "chevron.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(.white)
                            }
                    }
                    Spacer()
                    Text("Learning Goal")
                        .foregroundStyle(.white)
                        .font(.title3.bold())
                    Spacer()
                    Button { vm.confirmUpdate() } label: {
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.clear)
                            .glassEffect(.clear.tint(._230))
                            .overlay {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 9) {
                    Text("I want to learn")
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                        .padding(.top, 25)

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
                        .foregroundStyle(.white)
                        .padding(.top, 15)

                    HStack(spacing: 10) {
                        GlassButton(
                            title: "Week",
                            isSelected: vm.selectedPlan == .week,
                            width: 97, height: 48,
                            selectedTint: ._230,
                            normalTint: .gray.opacity(0.2)
                        ) { vm.selectedPlan = .week }

                        GlassButton(
                            title: "Month",
                            isSelected: vm.selectedPlan == .month,
                            width: 97, height: 48,
                            selectedTint: ._230,
                            normalTint: .gray.opacity(0.2)
                        ) { vm.selectedPlan = .month }

                        GlassButton(
                            title: "Year",
                            isSelected: vm.selectedPlan == .year,
                            width: 97, height: 48,
                            selectedTint: ._230,
                            normalTint: .gray.opacity(0.2)
                        ) { vm.selectedPlan = .year }
                    }
                    .padding(.top, 5)
                }
                .padding()

                Spacer()
            }

            if vm.confirmUpdateAlert {
                VStack {
                    VStack (alignment:.leading, spacing: 10) {
                        Text("Update Learning goal")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                        Text("If you update now, your streak will start over.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    HStack {
                        Button { vm.dismissAlert() } label: {
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 132, height: 48)
                                .foregroundStyle(.white.opacity(0.1))
                                .overlay(
                                    Text("Dismiss")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                        }
                        Button { vm.applyUpdate() } label: {
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 132, height: 48)
                                .foregroundStyle(._230)
                                .overlay(
                                    Text("Update")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
                .padding()
                .frame(width: 300, height: 184)
                .foregroundStyle(.clear)
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 30))
            }
            
            if vm.noChangeAlert {
                VStack (spacing : 20) {
                    
                    VStack (alignment:.leading, spacing: 10) {
                        Text("No Changes")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                        Text("You haven’t made any changes yet.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                       
                        Button { vm.dismissAlert() } label: {
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 260, height: 48)
                                .foregroundStyle(.white.opacity(0.1))
                                .overlay(
                                    Text("Dismiss")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                        }
                        
                }
                .padding()
                .frame(width: 300, height: 184)
                .foregroundStyle(.clear)
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 30))
            }
        }
        .toolbarVisibility(.hidden)
        .navigationDestination(isPresented: $vm.goToNext) {
            ActivityView()
        }
        .onAppear {
            vm.setContext(context)
            vm.onAppear()
        }
    }
}

#Preview {
    ChangeGoalView()
}
