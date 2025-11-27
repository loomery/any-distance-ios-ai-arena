// Licensed under the Any Distance Source-Available License
//
//  FadeAcrossButtonStyle.swift
//  ADAC
//
//  Created by GitHub Copilot on 11/27/25.
//

import SwiftUI

struct FadeAcrossButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        FadeAcrossButtonBody(configuration: configuration)
    }
}

private struct FadeAcrossButtonBody: View {
    let configuration: PrimitiveButtonStyle.Configuration
    @State private var isPressed = false
    @State private var tapLocation: CGPoint?
    
    // Brand color: #B2FE00 (Goal Green)
    private let activeColor = Color(red: 178/255, green: 254/255, blue: 0/255)
    
    var body: some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                GeometryReader { proxy in
                    let width = proxy.size.width
                    let height = proxy.size.height
                    let diagonal = sqrt(width * width + height * height)
                    let diameter = diagonal * 2
                    
                    ZStack {
                        // Idle state: Light capsule
                        Capsule()
                            .fill(Color.secondary.opacity(0.15))
                        
                        // Active state: Spotlight/Droplet effect
                        Circle()
                            .fill(activeColor)
                            .frame(width: diameter, height: diameter)
                            .scaleEffect(isPressed ? 1.0 : 0.001)
                            .position(tapLocation ?? CGPoint(x: width/2, y: height/2))
                            .opacity(isPressed ? 1 : 0)
                            .mask(Capsule())
                    }
                }
            )
            .foregroundColor(isPressed ? .black : .primary)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.35), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isPressed {
                            isPressed = true
                            tapLocation = value.location
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        configuration.trigger()
                    }
            )
    }
}

struct FadeAcrossButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button("Tap Me") {
                print("Tapped")
            }
            .buttonStyle(FadeAcrossButtonStyle())
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("With Icon")
                }
            }
            .buttonStyle(FadeAcrossButtonStyle())
            
            Button("Longer Button Text Example") {
                
            }
            .buttonStyle(FadeAcrossButtonStyle())
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
