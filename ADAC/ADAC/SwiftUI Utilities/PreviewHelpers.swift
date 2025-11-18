// Licensed under the Any Distance Source-Available License
//
//  PreviewHelpers.swift
//  ADAC
//
//  Preview utilities for consistent preview styling and behavior
//

import SwiftUI

// MARK: - Preview Containers

/// Standard preview container with consistent dark background and spacing
struct PreviewContainer<Content: View>: View {
    var title: String?
    var showsTitle: Bool = true
    var colorScheme: PreviewColorScheme = .dark
    @ViewBuilder var content: Content

    var body: some View {
        Group {
            if colorScheme == .both {
                ForEach([ColorScheme.dark, .light], id: \.self) { scheme in
                    containerContent
                        .preferredColorScheme(scheme)
                }
            } else {
                containerContent
                    .preferredColorScheme(colorScheme.scheme)
            }
        }
    }

    private var containerContent: some View {
        VStack(spacing: 20) {
            if showsTitle, let title = title {
                Text(title)
                    .previewTitle()
            }

            content

            Spacer()
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}

/// Helper for creating stateful previews with a single state value
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var title: String?
    var colorScheme: PreviewColorScheme = .dark
    @ViewBuilder var content: (Binding<Value>) -> Content

    init(
        initialValue: Value,
        title: String? = nil,
        colorScheme: PreviewColorScheme = .dark,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self._value = State(initialValue: initialValue)
        self.title = title
        self.colorScheme = colorScheme
        self.content = content
    }

    var body: some View {
        PreviewContainer(title: title, colorScheme: colorScheme) {
            content($value)
        }
    }
}

/// Helper for creating stateful previews with two state values
struct StatefulPreviewWrapper2<Value1, Value2, Content: View>: View {
    @State private var value1: Value1
    @State private var value2: Value2
    var title: String?
    var colorScheme: PreviewColorScheme = .dark
    @ViewBuilder var content: (Binding<Value1>, Binding<Value2>) -> Content

    init(
        _ initial1: Value1,
        _ initial2: Value2,
        title: String? = nil,
        colorScheme: PreviewColorScheme = .dark,
        @ViewBuilder content: @escaping (Binding<Value1>, Binding<Value2>) -> Content
    ) {
        self._value1 = State(initialValue: initial1)
        self._value2 = State(initialValue: initial2)
        self.title = title
        self.colorScheme = colorScheme
        self.content = content
    }

    var body: some View {
        PreviewContainer(title: title, colorScheme: colorScheme) {
            content($value1, $value2)
        }
    }
}

/// Helper for creating stateful previews with three state values
struct StatefulPreviewWrapper3<Value1, Value2, Value3, Content: View>: View {
    @State private var value1: Value1
    @State private var value2: Value2
    @State private var value3: Value3
    var title: String?
    var colorScheme: PreviewColorScheme = .dark
    @ViewBuilder var content: (Binding<Value1>, Binding<Value2>, Binding<Value3>) -> Content

    init(
        _ initial1: Value1,
        _ initial2: Value2,
        _ initial3: Value3,
        title: String? = nil,
        colorScheme: PreviewColorScheme = .dark,
        @ViewBuilder content: @escaping (Binding<Value1>, Binding<Value2>, Binding<Value3>) -> Content
    ) {
        self._value1 = State(initialValue: initial1)
        self._value2 = State(initialValue: initial2)
        self._value3 = State(initialValue: initial3)
        self.title = title
        self.colorScheme = colorScheme
        self.content = content
    }

    var body: some View {
        PreviewContainer(title: title, colorScheme: colorScheme) {
            content($value1, $value2, $value3)
        }
    }
}

/// Preview container for testing accessibility at different Dynamic Type sizes
struct AccessibilityPreviewContainer<Content: View>: View {
    var title: String
    var sizeCategories: [ContentSizeCategory] = [.medium, .extraExtraLarge, .accessibilityExtraExtraLarge]
    @ViewBuilder var content: Content

    var body: some View {
        ForEach(sizeCategories, id: \.self) { category in
            PreviewContainer(title: "\(title) - \(categoryName(category))") {
                content
            }
            .environment(\.sizeCategory, category)
        }
    }

    private func categoryName(_ category: ContentSizeCategory) -> String {
        switch category {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .extraLarge: return "XL"
        case .extraExtraLarge: return "XXL"
        case .extraExtraExtraLarge: return "XXXL"
        case .accessibilityMedium: return "A11y M"
        case .accessibilityLarge: return "A11y L"
        case .accessibilityExtraLarge: return "A11y XL"
        case .accessibilityExtraExtraLarge: return "A11y XXL"
        case .accessibilityExtraExtraExtraLarge: return "A11y XXXL"
        @unknown default: return "Unknown"
        }
    }
}

// MARK: - Color Scheme Control

enum PreviewColorScheme {
    case dark
    case light
    case both

    var scheme: ColorScheme? {
        switch self {
        case .dark: return .dark
        case .light: return .light
        case .both: return nil
        }
    }
}

// MARK: - Preview Text Styling Extensions

extension Text {
    /// Standard preview title styling
    static func previewTitle(_ text: String) -> Text {
        Text(text)
            .font(.title2)
            .foregroundColor(.primary)
    }

    /// Standard preview caption styling
    static func previewCaption(_ text: String) -> Text {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
    }

    /// Standard preview info styling
    static func previewInfo(_ text: String) -> Text {
        Text(text)
            .font(.body)
            .foregroundColor(.primary)
    }
}

extension View {
    /// Apply standard preview title styling to any view
    func previewTitle() -> some View {
        self
            .font(.title2)
            .foregroundColor(.primary)
    }

    /// Apply standard preview caption styling to any view
    func previewCaption() -> some View {
        self
            .font(.caption)
            .foregroundColor(.secondary)
    }

    /// Apply standard preview info styling to any view
    func previewInfo() -> some View {
        self
            .font(.body)
            .foregroundColor(.primary)
    }
}

// MARK: - Preview Layout Constants

enum PreviewLayout {
    static let standardHeight: CGFloat = 150
    static let compactHeight: CGFloat = 60
    static let expandedHeight: CGFloat = 250
    static let largeHeight: CGFloat = 400
}

// MARK: - Preview Colors

extension Color {
    static let previewBackground = Color(uiColor: .systemBackground)
    static let previewCardBackground = Color(white: 0.15)
}
