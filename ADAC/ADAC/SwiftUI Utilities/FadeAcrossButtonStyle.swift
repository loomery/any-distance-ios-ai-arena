// Licensed under the Any Distance Source-Available License
//
//  FadeAcrossButtonStyle.swift
//  ADAC
//
//  Created by GitHub Copilot on 11/27/25.
//

import SwiftUI

struct FadeAcrossButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        FadeAcrossButtonView(configuration: configuration)
    }
}

private struct FadeAcrossButtonView: View {
    let configuration: ButtonStyle.Configuration
    @State private var tapLocation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base idle state - light capsule
                Capsule()
                    .fill(Color.white.opacity(0.15))
                
                // Spotlight droplet effect
                if configuration.isPressed {
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.adOrange,
                            Color.adOrangeLighter,
                            Color.adYellow.opacity(0.8)
                        ]),
                        center: UnitPoint(
                            x: tapLocation.x / geometry.size.width,
                            y: tapLocation.y / geometry.size.height
                        ),
                        startRadius: 0,
                        endRadius: sqrt(pow(geometry.size.width, 2) + pow(geometry.size.height, 2))
                    )
                    .clipShape(Capsule())
                }
            }
            .overlay(
                // Subtle border for definition
                Capsule()
                    .strokeBorder(Color.white.opacity(configuration.isPressed ? 0.3 : 0.1), lineWidth: 1)
            )
            .overlay(
                configuration.label
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        tapLocation = value.location
                    }
            )
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed && tapLocation == .zero {
                    // Set default center location if tap wasn't captured
                    tapLocation = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: configuration.isPressed)
        }
    }
}

struct AnimatedSpotlightShape: Shape {
    var tapLocation: CGPoint
    var animationProgress: CGFloat
    var buttonSize: CGSize
    
    var animatableData: CGFloat {
        get { animationProgress }
        set { animationProgress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let maxRadius = sqrt(pow(buttonSize.width, 2) + pow(buttonSize.height, 2))
        let currentRadius = maxRadius * animationProgress
        
        return Path { path in
            path.addEllipse(in: CGRect(
                x: tapLocation.x - currentRadius,
                y: tapLocation.y - currentRadius,
                width: currentRadius * 2,
                height: currentRadius * 2
            ))
        }
    }
}

// Preview
#if DEBUG
struct FadeAcrossButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button(action: {
                print("Button tapped")
            }) {
                Text("Tap Me")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
            }
            .buttonStyle(FadeAcrossButtonStyle())
            .frame(width: 200, height: 50)
            
            Button(action: {
                print("Another tapped")
            }) {
                Text("Try Another")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
            }
            .buttonStyle(FadeAcrossButtonStyle())
            .frame(width: 250, height: 60)
            
            // Debug version to see what's happening
            Button(action: {
                print("Debug tapped")
            }) {
                Text("Debug Button")
                    .foregroundColor(.white)
            }
            .buttonStyle(TestButtonStyle())
            .frame(width: 200, height: 50)
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}

// Debug button style to test basic functionality
struct TestButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Capsule()
                    .fill(configuration.isPressed ? Color.adOrange : Color.white.opacity(0.15))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
#endif
