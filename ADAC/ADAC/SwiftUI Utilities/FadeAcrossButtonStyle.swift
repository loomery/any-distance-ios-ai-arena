// Licensed under the Any Distance Source-Available License
//
//  FadeAcrossButtonStyle.swift
//  ADAC
//
//  Created by Copilot on 11/28/24.
//

import SwiftUI

struct FadeAcrossButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        FadeAcrossButtonView(
            isPressed: configuration.isPressed,
            label: configuration.label
        )
    }
}

private struct FadeAcrossButtonView: View {
    let isPressed: Bool
    let label: ButtonStyleConfiguration.Label
    
    @State private var rippleOrigin: CGPoint? = nil
    @State private var rippleScale: CGFloat = 0
    @State private var buttonSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            // Base background
            Capsule()
                .fill(Color.adYellow.opacity(0.15))
            
            // Ripple effect
            GeometryReader { geo in
                let size = geo.size
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let origin = rippleOrigin ?? center
                let maxDimension = max(size.width, size.height) * 2.5
                
                Circle()
                    .fill(Color.adOrange)
                    .frame(width: maxDimension, height: maxDimension)
                    .scaleEffect(rippleScale)
                    .position(origin)
                    .onAppear {
                        buttonSize = size
                    }
            }
            .clipShape(Capsule())
            
            // Label
            label
        }
        .clipShape(Capsule())
        .contentShape(Capsule())
        .onTouchDownGesture { location in
            rippleOrigin = location
        }
        .onChange(of: isPressed) { pressed in
            if pressed {
                withAnimation(.easeOut(duration: 0.3)) {
                    rippleScale = 1
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    rippleScale = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    rippleOrigin = nil
                }
            }
        }
    }
}

private struct TouchDownGestureModifier: ViewModifier {
    let onTouchDown: (CGPoint) -> Void
    
    @State private var hasCaptured = false
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !hasCaptured {
                            hasCaptured = true
                            onTouchDown(value.startLocation)
                        }
                    }
                    .onEnded { _ in
                        hasCaptured = false
                    }
            )
    }
}

private extension View {
    func onTouchDownGesture(perform: @escaping (CGPoint) -> Void) -> some View {
        modifier(TouchDownGestureModifier(onTouchDown: perform))
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Tap Me") {
            print("Tapped!")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .buttonStyle(FadeAcrossButtonStyle())
        
        Button {
            print("Action!")
        } label: {
            HStack {
                Image(systemName: "star.fill")
                Text("Start Activity")
            }
            .font(.headline)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .buttonStyle(FadeAcrossButtonStyle())
    }
    .padding()
}

#Preview {
    VStack(spacing: 20) {
        Button("Tap Me") {
            print("Tapped!")
        }
        .buttonStyle(FadeAcrossButtonStyle())
        .frame(width: 200, height: 50)
        
        Button {
            print("Action!")
        } label: {
            HStack {
                Image(systemName: "star.fill")
                Text("Start Activity")
            }
            .font(.headline)
        }
        .buttonStyle(FadeAcrossButtonStyle())
        .frame(width: 250, height: 56)
    }
    .padding()
}
