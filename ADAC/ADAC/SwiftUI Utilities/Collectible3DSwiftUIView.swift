// Licensed under the Any Distance Source-Available License
//
//  Collectible3DSwiftUIView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 4/6/23.
//

import UIKit
import SwiftUI

struct Collectible3DSwiftUIView: UIViewRepresentable {
    let collectible: Collectible
    let earned: Bool
    let engraveInitials: Bool

    func makeUIView(context: Context) -> Collectible3DView {
        let view = Collectible3DView(frame: .zero)
        view.setup(withCollectible: collectible,
                   earned: earned,
                   engraveInitials: engraveInitials)
        return view
    }

    func updateUIView(_ uiView: Collectible3DView, context: Context) {}
}

struct Gear3DSwiftUIView: UIViewRepresentable {
    var usdzName: String
    var color: GearColor

    func makeUIView(context: Context) -> Gear3DView {
        let view = Gear3DView(frame: .zero)
        if let url = Bundle.main.url(forResource: usdzName, withExtension: "usdz") {
            view.setup(withLocalUsdzUrl: url, color: color)
        }
        return view
    }

    func updateUIView(_ uiView: Gear3DView, context: Context) {
        uiView.setColor(color: color)
    }
}

#Preview("Collectible3DSwiftUIView") {
    VStack(spacing: 20) {
        Text("Collectible 3D View")
            .font(.title2)
            .foregroundColor(.white)

        // Placeholder for 3D collectible view
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 300)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "cube.transparent")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    Text("3D Collectible Placeholder")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )

        Text("Displays 3D collectible items")
            .font(.caption)
            .foregroundColor(.gray)

        Spacer()
    }
    .padding()
    .background(Color.black)
}

#Preview("Gear3DSwiftUIView") {
    VStack(spacing: 20) {
        Text("Gear 3D View")
            .font(.title2)
            .foregroundColor(.white)

        // Placeholder for 3D gear view
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 300)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "gear")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    Text("3D Gear Placeholder")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )

        Text("Displays 3D gear models with color options")
            .font(.caption)
            .foregroundColor(.gray)

        Spacer()
    }
    .padding()
    .background(Color.black)
}
