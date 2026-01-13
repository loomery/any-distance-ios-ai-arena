// Licensed under the Any Distance Source-Available License
//
//  ADWhiteButton.swift
//  ADAC
//
//  Created by Daniel Kuntz on 5/16/23.
//

import SwiftUI

struct ADWhiteButton: View {
    var title: String
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .foregroundColor(.white)
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
            }
        }
        .frame(height: 50)
    }
}

struct RoundedWhiteButtonLabel: View {
    var text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(Color.white)
            Text(text)
                .font(.system(size: 13.0, weight: .semibold))
                .foregroundColor(.black)
        }
    }
}

#if DEBUG
private struct ADWhiteButtonPreviewGallery: View {
    @State private var buttonTitle: String = "Continue"
    @State private var tapCount: Int = 0

    var body: some View {
        VStack(spacing: 24) {
            ADWhiteButton(title: buttonTitle) {
                tapCount += 1
            }
            .frame(maxWidth: 240)

            RoundedWhiteButtonLabel(text: "Compact Label")
                .frame(width: 180, height: 52)

            VStack(spacing: 12) {
                TextField("Button Title", text: $buttonTitle)
                    .textFieldStyle(.roundedBorder)
                Text("Tapped \(tapCount) time\(tapCount == 1 ? "" : "s")")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview("White Buttons") {
    ADWhiteButtonPreviewGallery()
}
#endif
