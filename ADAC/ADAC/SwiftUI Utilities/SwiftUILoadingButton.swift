// Licensed under the Any Distance Source-Available License
//
//  SwiftUILoadingButton.swift
//  ADAC
//
//  Created by Daniel Kuntz on 1/23/23.
//

import SwiftUI

struct SwiftUILoadingButton: UIViewRepresentable {
    var isLoading: Bool = false
    var title: String = ""
    var backgroundColor: UIColor = .white
    var action: (() -> Void)?

    func makeUIView(context: Context) -> LoadingButton {
        let button = LoadingButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        button.addAction(UIAction(handler: { _ in
            action?()
        }), for: .touchUpInside)
        button.autoSetDimension(.height, toSize: 50)
        button.autoSetDimension(.width, toSize: UIScreen.main.bounds.width - 40)
        return button
    }

    func updateUIView(_ uiView: LoadingButton, context: Context) {
        uiView.isLoading = isLoading
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var isLoading = false

        var body: some View {
            VStack(spacing: 20) {
                Text("Loading Button")
                    .font(.title2)
                    .foregroundColor(.white)

                SwiftUILoadingButton(
                    isLoading: isLoading,
                    title: isLoading ? "Loading..." : "Submit",
                    backgroundColor: .adOrange,
                    action: {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            isLoading = false
                        }
                    }
                )
                .frame(height: 50)

                Text(isLoading ? "Processing..." : "Tap to trigger loading")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
            .background(Color.black)
        }
    }

    return PreviewWrapper()
}
