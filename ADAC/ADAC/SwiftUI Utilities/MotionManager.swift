// Licensed under the Any Distance Source-Available License
//
//  MotionManager.swift
//  ADAC
//
//  Created by Daniel Kuntz on 12/10/21.
//

import SwiftUI
import CoreMotion

final class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0

    private var manager: CMMotionManager

    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { [weak self] (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                self?.pitch = motionData.attitude.pitch
                self?.roll = motionData.attitude.roll
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        MotionManagerWrapper()
    }
}

private struct MotionManagerWrapper: View {
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Motion Manager Preview")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Pitch: \(motionManager.pitch, specifier: "%.2f")")
                .foregroundColor(.white)
            
            Text("Roll: \(motionManager.roll, specifier: "%.2f")")
                .foregroundColor(.white)
            
            Text("(Requires physical device)")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
