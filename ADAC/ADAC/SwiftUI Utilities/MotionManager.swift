// Licensed under the Any Distance Source-Available License
//
//  MotionManager.swift
//  ADAC
//
//  Created by Daniel Kuntz on 12/10/21.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0

    let manager: CMMotionManager

    init(manager: CMMotionManager = CMMotionManager()) {
        self.manager = manager
        self.manager.deviceMotionUpdateInterval = 1/60
        startUpdates()
    }

    func startUpdates() {
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motionData, error in
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
