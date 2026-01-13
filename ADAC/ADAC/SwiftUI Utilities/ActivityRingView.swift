// Licensed under the Any Distance Source-Available License
//
//  ActivityRingView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 6/29/23.
//

import SwiftUI
import HealthKitUI
import HealthKit

struct ActivityRingView: UIViewRepresentable {
    @Binding var summary: HKActivitySummary?

    func makeUIView(context: Context) -> HKActivityRingView {
        let activityRingView = HKActivityRingView(frame: .zero)
        return activityRingView
    }

    func updateUIView(_ activityRingView: HKActivityRingView, context: Context) {
        activityRingView.setActivitySummary(summary, animated: true)
    }
}

#if DEBUG
private struct ActivityRingViewPreview: View {
    @State private var moveProgress: Double = 0.65
    @State private var exerciseProgress: Double = 0.45
    @State private var standProgress: Double = 0.8
    @State private var summary: HKActivitySummary? = ActivityRingViewPreview.makeSummary(move: 0.65,
                                                                                        exercise: 0.45,
                                                                                        stand: 0.8)

    var body: some View {
        VStack(spacing: 24) {
            ActivityRingView(summary: $summary)
                .frame(width: 220, height: 220)

            VStack(spacing: 12) {
                progressRow(title: "Move", value: $moveProgress)
                progressRow(title: "Exercise", value: $exerciseProgress)
                progressRow(title: "Stand", value: $standProgress)
            }

            Button("Randomize Summary") {
                moveProgress = Double.random(in: 0...1)
                exerciseProgress = Double.random(in: 0...1)
                standProgress = Double.random(in: 0...1)
                rebuildSummary()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: moveProgress) { _ in rebuildSummary() }
        .onChange(of: exerciseProgress) { _ in rebuildSummary() }
        .onChange(of: standProgress) { _ in rebuildSummary() }
    }

    private func progressRow(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
                .frame(width: 80, alignment: .leading)
            Slider(value: value, in: 0...1)
            Text("\(Int(value.wrappedValue * 100))%")
                .frame(width: 50, alignment: .trailing)
        }
    }

    private func rebuildSummary() {
        summary = Self.makeSummary(move: moveProgress,
                                   exercise: exerciseProgress,
                                   stand: standProgress)
    }

    private static func makeSummary(move: Double, exercise: Double, stand: Double) -> HKActivitySummary {
        let summary = HKActivitySummary()
        summary.setValue(HKQuantity(unit: .largeCalorie(), doubleValue: move * 600), forKey: "activeEnergyBurned")
        summary.setValue(HKQuantity(unit: .largeCalorie(), doubleValue: 600), forKey: "activeEnergyBurnedGoal")
        summary.setValue(HKQuantity(unit: .minute(), doubleValue: move * 60), forKey: "appleMoveTime")
        summary.setValue(HKQuantity(unit: .minute(), doubleValue: 60), forKey: "appleMoveTimeGoal")
        summary.setValue(HKQuantity(unit: .minute(), doubleValue: exercise * 30), forKey: "appleExerciseTime")
        summary.setValue(HKQuantity(unit: .minute(), doubleValue: 30), forKey: "appleExerciseTimeGoal")
        summary.setValue(HKQuantity(unit: .count(), doubleValue: stand * 12), forKey: "appleStandHours")
        summary.setValue(HKQuantity(unit: .count(), doubleValue: 12), forKey: "appleStandHoursGoal")
        return summary
    }
}

#Preview("Activity Ring") {
    ActivityRingViewPreview()
}
#endif
