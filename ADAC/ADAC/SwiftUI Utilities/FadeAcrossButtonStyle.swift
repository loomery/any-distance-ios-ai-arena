// Licensed under the Any Distance Source-Available License
//
//  FadeAcrossButtonStyle.swift
//  ADAC
//
//  Created by GitHub Copilot CLI on 11/27/25.
//

import SwiftUI

struct FadeAcrossButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        FadeAcrossButton(configuration: configuration)
    }

    private struct FadeAcrossButton: View {
        let configuration: ButtonStyle.Configuration
        @State private var tapLocation: CGPoint?
        @State private var rippleProgress: CGFloat = 0
        @State private var isPressing = false

        private let idleFill = Color.adOrange.opacity(0.14)
        private let idleStroke = Color.adOrange.opacity(0.35)
        private let highlightGradient = Gradient(colors: [Color.adYellow, Color.adOrange])

        var body: some View {
            configuration.label
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .contentShape(Capsule())
                .background(
                    GeometryReader { proxy in
                        let size = proxy.size
                        ZStack {
                            Capsule()
                                .fill(idleFill)
                            dropletHighlight(in: size)
                            Capsule()
                                .stroke(idleStroke, lineWidth: 1)
                        }
                        .allowsHitTesting(false)
                    }
                )
                .scaleEffect(configuration.isPressed ? 0.99 : 1)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: configuration.isPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            tapLocation = value.location
                            beginPress()
                        }
                        .onEnded { value in
                            tapLocation = value.location
                            finishPress()
                        }
                )
                .onChange(of: configuration.isPressed) { pressed in
                    if pressed {
                        beginPress()
                    } else {
                        finishPress()
                    }
                }
        }

        @ViewBuilder
        private func dropletHighlight(in size: CGSize) -> some View {
            let safeSize = CGSize(width: max(size.width, 1), height: max(size.height, 1))
            let location = resolvedLocation(in: safeSize)
            let radius = dropletRadius(for: location, in: safeSize)

            RadialGradient(gradient: highlightGradient,
                           center: UnitPoint(x: location.x / safeSize.width,
                                             y: location.y / safeSize.height),
                           startRadius: 0,
                           endRadius: max(radius, 0.001))
                .frame(width: safeSize.width, height: safeSize.height)
                .opacity(rippleProgress == 0 ? 0 : 1)
                .animation(.easeOut(duration: 0.45), value: rippleProgress)
                .mask(Capsule())
        }

        private func resolvedLocation(in size: CGSize) -> CGPoint {
            let fallback = CGPoint(x: size.width / 2, y: size.height / 2)
            guard let tapLocation else { return fallback }

            let clampedX = min(max(tapLocation.x, 0), size.width)
            let clampedY = min(max(tapLocation.y, 0), size.height)
            return CGPoint(x: clampedX, y: clampedY)
        }

        private func dropletRadius(for location: CGPoint, in size: CGSize) -> CGFloat {
            let corners = [
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0),
                CGPoint(x: 0, y: size.height),
                CGPoint(x: size.width, y: size.height)
            ]

            let farthest = corners
                .map { hypot(location.x - $0.x, location.y - $0.y) }
                .max() ?? 0

            return farthest * rippleProgress
        }

        private func beginPress() {
            guard !isPressing else { return }
            isPressing = true
            rippleProgress = 0.12

            withAnimation(.easeOut(duration: 0.55)) {
                rippleProgress = 1
            }
        }

        private func finishPress() {
            guard isPressing else { return }
            isPressing = false
            withAnimation(.easeIn(duration: 0.35).delay(0.05)) {
                rippleProgress = 0
            }
        }
    }
}

#if DEBUG
struct FadeAcrossButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Button("Spotlight") {}
                .font(.presicav(size: 18, weight: .bold))
                .buttonStyle(FadeAcrossButtonStyle())

            Button {
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("Send Magic")
                }
                .font(.greedMedium(size: 16))
            }
            .buttonStyle(FadeAcrossButtonStyle())
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
#endif
