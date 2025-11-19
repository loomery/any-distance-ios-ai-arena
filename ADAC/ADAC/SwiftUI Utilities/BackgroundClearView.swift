// Licensed under the Any Distance Source-Available License
//
//  BackgroundClearView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 6/29/22.
//

import SwiftUI

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    ZStack {
        Color.red.edgesIgnoringSafeArea(.all)
        
        VStack {
            Text("This view has a clear background")
                .padding()
                .background(Color.blue) // Inner background
            
            // This simulates a view that might usually have a default background
            // but we are clearing it.
            List {
                Text("Item 1")
                Text("Item 2")
            }
            .background(BackgroundClearView())
            .frame(height: 200)
        }
    }
}
