// Licensed under the Any Distance Source-Available License
//
//  ActivityRingView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 6/29/23.
//

import SwiftUI
import HealthKitUI

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

#Preview {
    let summary = HKActivitySummary()
    summary.activeEnergyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: 350)
    summary.activeEnergyBurnedGoal = HKQuantity(unit: .kilocalorie(), doubleValue: 500)
    summary.appleExerciseTime = HKQuantity(unit: .minute(), doubleValue: 20)
    summary.appleExerciseTimeGoal = HKQuantity(unit: .minute(), doubleValue: 30)
    summary.appleStandHours = HKQuantity(unit: .count(), doubleValue: 8)
    summary.appleStandHoursGoal = HKQuantity(unit: .count(), doubleValue: 12)
    
    return ActivityRingView(summary: .constant(summary))
        .frame(width: 200, height: 200)
        .padding()
        .background(Color.black)
}
