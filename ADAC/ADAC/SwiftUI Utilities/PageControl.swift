// Licensed under the Any Distance Source-Available License
//
//  PageControl.swift
//  ADAC
//
//  Created by Daniel Kuntz on 5/31/23.
//

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    @Binding var currentPage: Int
    var numberOfPages: Int

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged
        )
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        PageControlWrapper()
    }
}

private struct PageControlWrapper: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                Text("Page 0").tag(0).foregroundColor(.white)
                Text("Page 1").tag(1).foregroundColor(.white)
                Text("Page 2").tag(2).foregroundColor(.white)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)
            
            PageControl(currentPage: $currentPage, numberOfPages: 3)
        }
    }
}
