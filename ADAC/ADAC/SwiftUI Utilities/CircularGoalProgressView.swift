// Licensed under the Any Distance Source-Available License
//
//  CircularGoalProgressView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 6/29/23.
//

import SwiftUI

struct CircularGoalProgressView: UIViewRepresentable {
    var style: CircularGoalProgressIndicatorStyle
    var progress: CGFloat

    func makeUIView(context: Context) -> CircularGoalProgressIndicator {
        let indicator = CircularGoalProgressIndicator(frame: .zero)
        indicator.style = style
        indicator.progress = progress
        return indicator
    }

    func updateUIView(_ uiView: CircularGoalProgressIndicator, context: Context) {
        uiView.style = style
        uiView.progress = progress
    }
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 40) {
            VStack(spacing: 10) {
                Text("25%")
                    .font(.caption)
                    .foregroundColor(.white)

                CircularGoalProgressView(
                    style: .small,
                    progress: 0.25
                )
            }

            VStack(spacing: 10) {
                Text("50%")
                    .font(.caption)
                    .foregroundColor(.white)

                CircularGoalProgressView(
                    style: .medium,
                    progress: 0.5
                )
            }

            VStack(spacing: 10) {
                Text("100%")
                    .font(.caption)
                    .foregroundColor(.white)

                CircularGoalProgressView(
                    style: .large,
                    progress: 1.0
                )
            }
        }
        .frame(height: 150)

        Spacer()
    }
    .padding()
    .background(Color.black)
}
