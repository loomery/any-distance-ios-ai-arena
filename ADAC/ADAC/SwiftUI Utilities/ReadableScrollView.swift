// Licensed under the Any Distance Source-Available License
//
//  ReadableScrollView.swift
//  ADAC
//
//  Created by Daniel Kuntz on 3/29/23.
//

import SwiftUI
import Introspect

struct ReadableScrollView<Content: View>: View {
    @Binding var offset: CGFloat
    @Binding var contentSize: CGSize
    var presentedInSheet: Bool = false
    var showsIndicators: Bool = true
    var content: Content

    init(offset: Binding<CGFloat>,
         contentSize: Binding<CGSize>? = nil,
         presentedInSheet: Bool = false,
         showsIndicators: Bool = true,
         @ViewBuilder contentBuilder: () -> Content) {
        self._offset = offset
        self._contentSize = contentSize ?? .constant(.zero)
        self.presentedInSheet = presentedInSheet
        self.showsIndicators = showsIndicators
        self.content = contentBuilder()
    }

    var scrollReader: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: CGFloatPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minY)
                .preference(key: CGSizePreferenceKey.self,
                            value: geometry.size)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            VStack {
                content
            }
            .background(scrollReader.ignoresSafeArea())
            .onPreferenceChange(CGFloatPreferenceKey.self) { value in
                guard let window = UIApplication.shared.topWindowScene?.keyWindow else {
                    self.offset = value
                    return
                }

                self.offset = value - window.safeAreaInsets.top - (presentedInSheet ? 10.0 : 0.0)
            }
            .onPreferenceChange(CGSizePreferenceKey.self) { value in
                self.contentSize = value
            }
        }
        .introspectScrollView { scrollView in
            scrollView.delaysContentTouches = false
        }
    }
}

struct RefreshableScrollView<Content: View>: View {
    @Binding var offset: CGFloat
    @Binding var isRefreshing: Bool
    var presentedInSheet: Bool = false
    var content: Content

    @State private var refreshControlVisible: Bool = false
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let refreshOffset: CGFloat = 150.0

    init(offset: Binding<CGFloat>,
         isRefreshing: Binding<Bool>,
         presentedInSheet: Bool = false,
         @ViewBuilder contentBuilder: () -> Content) {
        self._offset = offset
        self._isRefreshing = isRefreshing
        self.presentedInSheet = presentedInSheet
        self.content = contentBuilder()
    }

    var scrollReader: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: CGFloatPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minY)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                content
            }
            .if(!presentedInSheet) { view in
                view
                    .overlay {
                        VStack {
                            ZStack {
                                ProgressView()
                                    .opacity(isRefreshing ? 1.0 : 0.0)
                                    .offset(y: -12.0)
                                Text("PULL TO REFRESH")
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white)
                                    .opacity((offset / refreshOffset).clamped(to: 0...1) * 0.6)
                                    .opacity(isRefreshing ? 0.0 : 1.0)
                                    .offset(y: -6.0)
                            }
                            .offset(y: -0.9 * offset)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRefreshing)

                            Spacer()
                        }
                    }
            }
            .offset(y: isRefreshing ? 30.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isRefreshing)
            .background(scrollReader.ignoresSafeArea())
            .onPreferenceChange(CGFloatPreferenceKey.self) { value in
                guard let window = UIApplication.shared.windows.first else {
                    self.offset = value
                    return
                }

                self.offset = value - window.safeAreaInsets.top - (presentedInSheet ? 10.0 : 0.0)
                if offset >= refreshOffset && !isRefreshing && !presentedInSheet {
                    isRefreshing = true
                    feedbackGenerator.impactOccurred()
                }
            }
        }
        .introspectScrollView { scrollView in
            scrollView.delaysContentTouches = false
        }
    }
}

#Preview("ReadableScrollView") {
    struct PreviewWrapper: View {
        @State var offset: CGFloat = 0
        @State var contentSize: CGSize = .zero

        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text("Scroll Position: \(Int(offset))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                .background(Color(white: 0.1))

                ReadableScrollView(offset: $offset, contentSize: $contentSize) {
                    VStack(spacing: 20) {
                        ForEach(0..<20, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.adOrange.opacity(Double(index) / 20))
                                .frame(height: 80)
                                .overlay(
                                    Text("Item \(index + 1)")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
        }
    }

    return PreviewWrapper()
}

#Preview("RefreshableScrollView") {
    struct PreviewWrapper: View {
        @State var offset: CGFloat = 0
        @State var isRefreshing: Bool = false

        var body: some View {
            VStack {
                RefreshableScrollView(offset: $offset, isRefreshing: $isRefreshing) {
                    VStack(spacing: 20) {
                        ForEach(0..<15, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.adYellow.opacity(Double(index) / 15))
                                .frame(height: 80)
                                .overlay(
                                    Text("Item \(index + 1)")
                                        .foregroundColor(.black)
                                )
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isRefreshing = false
                }
            }
        }
    }

    return PreviewWrapper()
}
