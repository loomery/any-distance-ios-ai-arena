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

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 20) {
            LightBlurGlyph(symbolName: "heart.fill", size: 24)
            LightBlurGlyph(symbolName: "star.fill", size: 24)
            LightBlurGlyph(symbolName: "bolt.fill", size: 24)
            LightBlurGlyph(symbolName: "flame.fill", size: 24)
        }

        HStack(spacing: 20) {
            LightBlurGlyph(symbolName: "magnifyingglass", size: 20)
            LightBlurGlyph(symbolName: "gear", size: 20)
            LightBlurGlyph(symbolName: "bell", size: 20)
            LightBlurGlyph(symbolName: "checkmark.circle", size: 20)
        }
    }
    .padding()
    .background(Color.black)
}
