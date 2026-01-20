// Licensed under the Any Distance Source-Available License
//
//  GeometryBinding.swift
//  ADAC
//
//  Created by Daniel Kuntz on 12/14/21.
//

import SwiftUI

public extension View {
    func bindGeometry(to binding: Binding<CGFloat>,
                      reader: @escaping (GeometryProxy) -> CGFloat) -> some View {
            self.background(GeometryBinding(reader: reader))
                .onPreferenceChange(GeometryPreference.self) {
                    binding.wrappedValue = $0
                }
        }
}

private struct GeometryBinding: View {
    let reader: (GeometryProxy) -> CGFloat

    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(
                key: GeometryPreference.self,
                value: self.reader(geo)
            )
        }
    }
}

private struct GeometryPreference: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        GeometryBindingWrapper()
    }
}

private struct GeometryBindingWrapper: View {
    @State private var width: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("Width: \(Int(width))")
                .foregroundColor(.white)
            
            Rectangle()
                .fill(Color.blue)
                .frame(height: 100)
                .padding()
                .bindGeometry(to: $width) { proxy in
                    proxy.size.width
                }
        }
    }
}
