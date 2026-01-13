// Licensed under the Any Distance Source-Available License
//
//  LightBlurGlyph.swift
//  ADAC
//
//  Created by Daniel Kuntz on 2/28/23.
//

import SwiftUI

struct LightBlurGlyph: View {
    var symbolName: String
    var size: CGFloat

    var body: some View {
        Color.white
            .opacity(0.8)
            .frame(width: size, height: size)
            .mask {
                Image(systemName: symbolName)
                    .resizable()
            }
    }
}

#if DEBUG
private struct LightBlurGlyphPreviewGallery: View {
    @State private var symbol: String = "figure.walk.circle.fill"
    @State private var size: Double = 120

    var body: some View {
        VStack(spacing: 24) {
            LightBlurGlyph(symbolName: symbol, size: size)
                .shadow(radius: 10)

            TextField("SF Symbol", text: $symbol)
                .textFieldStyle(.roundedBorder)

            HStack {
                Text("Size \(Int(size))")
                Slider(value: $size, in: 40...200)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview("Light Blur Glyph") {
    LightBlurGlyphPreviewGallery()
}
#endif
