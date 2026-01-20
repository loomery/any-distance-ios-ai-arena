// Licensed under the Any Distance Source-Available License
//
//  GIFView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 9/7/22.
//

import SwiftyGif
import SwiftUI

struct GIFView: UIViewRepresentable {
    var gifName: String

    func makeUIView(context: Context) -> UIImageView {
        if let image = try? UIImage(gifName: gifName) {
            return UIImageView(gifImage: image)
        }

        return UIImageView(frame: .zero)
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

#Preview {
    VStack(spacing: 20) {
        Text("GIF View")
            .font(.title2)
            .foregroundColor(.white)

        // Placeholder for GIF view (actual GIF requires assets)
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 300)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "film")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    Text("GIF Asset Placeholder")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )

        Text("GIFView loads animated GIFs by name from assets")
            .font(.caption)
            .foregroundColor(.gray)
            .padding()

        Spacer()
    }
    .padding()
    .background(Color.black)
}
