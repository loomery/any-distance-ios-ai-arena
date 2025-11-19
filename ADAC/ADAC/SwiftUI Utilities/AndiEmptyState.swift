// Licensed under the Any Distance Source-Available License
//
//  AndiEmptyState.swift
//  ADAC
//
//  Created by Daniel Kuntz on 7/25/23.
//

import SwiftUI

enum AndiEmptyStateType: String {
    case shoes
    case fly
}

struct AndiEmptyState: View {
    var text: String
    var type: AndiEmptyStateType = .shoes

    var body: some View {
        VStack {
            Image("andi-\(type.rawValue)")
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding([.leading, .trailing], 50)
                .multilineTextAlignment(.center)
                .lineLimit(10)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
private struct AndiEmptyStatePreviewGallery: View {
    @State private var message: String = "Invite friends to see their movement magic here."
    @State private var selectedType: AndiEmptyStateType = .shoes

    var body: some View {
        VStack(spacing: 24) {
            AndiEmptyState(text: message, type: selectedType)
                .padding()
                .background(Color.black.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            Picker("Illustration", selection: $selectedType) {
                Text("Shoes").tag(AndiEmptyStateType.shoes)
                Text("Fly").tag(AndiEmptyStateType.fly)
            }
            .pickerStyle(.segmented)

            TextField("Message", text: $message, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview("Andi Empty State") {
    AndiEmptyStatePreviewGallery()
        .preferredColorScheme(.dark)
}
#endif
