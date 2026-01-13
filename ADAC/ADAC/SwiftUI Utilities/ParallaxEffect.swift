// Licensed under the Any Distance Source-Available License
//
//  ParallaxEffect.swift
//  ADAC
//
//  Created by Daniel Kuntz on 5/24/23.
//

import SwiftUI
import CoreMotion

struct ParallaxEffect: ViewModifier {
    @StateObject private var motionManager: MotionManager

    init(motionManager: MotionManager = MotionManager()) {
        _motionManager = StateObject(wrappedValue: motionManager)
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(1.05)
            .offset(x: (motionManager.roll * -15.0).clamped(to: -8.0...8.0),
                    y: (motionManager.pitch * -15.0).clamped(to: -8.0...8.0))
            .animation(.easeInOut(duration: 0.05), value: motionManager.roll)
            .animation(.easeInOut(duration: 0.05), value: motionManager.pitch)
    }
}

extension View {
    func parallaxEffect() -> some View {
        modifier(ParallaxEffect())
    }
}

#if DEBUG
private final class PreviewMotionManager: MotionManager {
    override init(manager: CMMotionManager = CMMotionManager()) {
        super.init(manager: manager)
    }

    override func startUpdates() {
        // Disable real motion updates for previews.
    }

    func update(pitch: Double, roll: Double) {
        DispatchQueue.main.async {
            self.pitch = pitch
            self.roll = roll
        }
    }
}

private struct ParallaxEffectPreview: View {
    @StateObject private var previewManager = PreviewMotionManager()
    @State private var pitch: Double = 0.1
    @State private var roll: Double = -0.1

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Image("activity_run")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(40)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
            .modifier(ParallaxEffect(motionManager: previewManager))
            .frame(height: 200)

            VStack(alignment: .leading) {
                Text("Pitch \(pitch, specifier: "%.2f")")
                Slider(value: $pitch, in: -0.5...0.5)
                Text("Roll \(roll, specifier: "%.2f")")
                Slider(value: $roll, in: -0.5...0.5)
            }
            .onChange(of: pitch) { _ in
                previewManager.update(pitch: pitch, roll: roll)
            }
            .onChange(of: roll) { _ in
                previewManager.update(pitch: pitch, roll: roll)
            }
        }
        .padding()
        .onAppear {
            previewManager.update(pitch: pitch, roll: roll)
        }
    }
}

#Preview("Parallax Effect") {
    ParallaxEffectPreview()
}
#endif
