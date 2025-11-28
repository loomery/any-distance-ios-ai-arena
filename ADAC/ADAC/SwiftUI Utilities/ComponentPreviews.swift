// Licensed under the Any Distance Source-Available License
//
//  ComponentPreviews.swift
//  ADAC
//
//  Interactive previews for all atomic SwiftUI components
//

import SwiftUI

// MARK: - Preview Helpers

/// A reusable dark background container for consistent preview styling
private struct PreviewContainer<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
    }
}

/// A section divider for organizing preview content
private struct PreviewSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
            content()
        }
    }
}

// MARK: - ADSegmentedControl Preview

private struct ADSegmentedControlPreview: View {
    @State private var selectedIdx2: Int = 0
    @State private var selectedIdx3: Int = 1
    @State private var selectedIdx4: Int = 2
    @State private var showBackground: Bool = true
    @State private var fontSize: CGFloat = 15
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "ADSegmentedControl") {
                    PreviewSection(title: "2 Segments") {
                        ADSegmentedControl(
                            segments: ["Week", "Month"],
                            selectedSegmentIdx: $selectedIdx2
                        )
                    }
                    
                    PreviewSection(title: "3 Segments") {
                        ADSegmentedControl(
                            segments: ["Running", "Cycling", "Swimming"],
                            selectedSegmentIdx: $selectedIdx3
                        )
                    }
                    
                    PreviewSection(title: "4 Segments") {
                        ADSegmentedControl(
                            segments: ["Day", "Week", "Month", "Year"],
                            selectedSegmentIdx: $selectedIdx4
                        )
                    }
                    
                    PreviewSection(title: "Custom Font Size (\(Int(fontSize))pt)") {
                        Slider(value: $fontSize, in: 10...24, step: 1)
                            .tint(.white)
                        ADSegmentedControl(
                            segments: ["Small", "Large"],
                            fontSize: fontSize,
                            selectedSegmentIdx: $selectedIdx2
                        )
                    }
                    
                    PreviewSection(title: "Without Background") {
                        ADSegmentedControl(
                            segments: ["Option A", "Option B"],
                            showBg: false,
                            selectedSegmentIdx: $selectedIdx2
                        )
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("ADSegmentedControl") {
    ADSegmentedControlPreview()
}

// MARK: - ADWhiteButton Preview

private struct ADWhiteButtonPreview: View {
    @State private var tapCount: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "ADWhiteButton") {
                    PreviewSection(title: "Default State") {
                        ADWhiteButton(title: "Continue") {
                            tapCount += 1
                        }
                    }
                    
                    PreviewSection(title: "Various Labels") {
                        VStack(spacing: 12) {
                            ADWhiteButton(title: "Get Started")
                            ADWhiteButton(title: "Sign Up")
                            ADWhiteButton(title: "Save Changes")
                        }
                    }
                    
                    PreviewSection(title: "Interactive (Tapped \(tapCount)x)") {
                        ADWhiteButton(title: "Tap Me!") {
                            tapCount += 1
                        }
                    }
                }
                
                PreviewContainer(title: "RoundedWhiteButtonLabel") {
                    PreviewSection(title: "Various Sizes") {
                        HStack(spacing: 12) {
                            RoundedWhiteButtonLabel(text: "Small")
                                .frame(width: 80, height: 32)
                            RoundedWhiteButtonLabel(text: "Medium")
                                .frame(width: 100, height: 36)
                            RoundedWhiteButtonLabel(text: "Large")
                                .frame(width: 120, height: 40)
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("ADWhiteButton") {
    ADWhiteButtonPreview()
}

// MARK: - AccessCodeField Preview

private struct AccessCodeFieldPreview: View {
    @State private var emptyCode: String = ""
    @State private var partialCode: String = "AB1"
    @State private var fullCode: String = "XY9Z4K"
    @FocusState private var isEmptyFocused: Bool
    @FocusState private var isPartialFocused: Bool
    @FocusState private var isFullFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "AccessCodeField") {
                    PreviewSection(title: "Empty (Tap to Focus)") {
                        AccessCodeField(
                            accessCode: $emptyCode,
                            isFocused: $isEmptyFocused
                        )
                    }
                    
                    PreviewSection(title: "Partial Entry (\(partialCode))") {
                        AccessCodeField(
                            accessCode: $partialCode,
                            isFocused: $isPartialFocused
                        )
                    }
                    
                    PreviewSection(title: "Complete Code") {
                        AccessCodeField(
                            accessCode: $fullCode,
                            isFocused: $isFullFocused
                        )
                    }
                    
                    Text("Current code: \(emptyCode.isEmpty ? "(empty)" : emptyCode)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("AccessCodeField") {
    AccessCodeFieldPreview()
}

// MARK: - AndiEmptyState Preview

private struct AndiEmptyStatePreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "AndiEmptyState") {
                    PreviewSection(title: "Shoes Type") {
                        AndiEmptyState(
                            text: "No activities yet. Start your first workout!",
                            type: .shoes
                        )
                    }
                    
                    PreviewSection(title: "Fly Type") {
                        AndiEmptyState(
                            text: "Nothing here yet. Time to get moving!",
                            type: .fly
                        )
                    }
                    
                    PreviewSection(title: "Long Text") {
                        AndiEmptyState(
                            text: "This is a longer message that wraps across multiple lines to demonstrate the text handling capabilities of this component.",
                            type: .shoes
                        )
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("AndiEmptyState") {
    AndiEmptyStatePreview()
}

// MARK: - BlurView Preview

private struct BlurViewPreview: View {
    @State private var intensity: CGFloat = 0.8
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "BlurView Styles") {
                    PreviewSection(title: "DarkBlurView") {
                        ZStack {
                            Image(systemName: "star.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.yellow)
                            DarkBlurView()
                                .frame(width: 150, height: 100)
                                .cornerRadius(16)
                        }
                        .frame(height: 120)
                    }
                    
                    PreviewSection(title: "LightBlurView") {
                        ZStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            LightBlurView()
                                .frame(width: 150, height: 100)
                                .cornerRadius(16)
                        }
                        .frame(height: 120)
                    }
                    
                    PreviewSection(title: "Custom Intensity (\(String(format: "%.1f", intensity)))") {
                        Slider(value: $intensity, in: 0...1)
                            .tint(.white)
                        ZStack {
                            LinearGradient(
                                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            BlurView(style: .systemUltraThinMaterialDark, intensity: intensity)
                        }
                        .frame(height: 60)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("BlurView") {
    BlurViewPreview()
}

// MARK: - LightBlurGlyph Preview

private struct LightBlurGlyphPreview: View {
    private let symbols = [
        "heart.fill",
        "star.fill",
        "bolt.fill",
        "flame.fill",
        "leaf.fill",
        "drop.fill"
    ]
    
    @State private var selectedSize: CGFloat = 40
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "LightBlurGlyph") {
                    PreviewSection(title: "Various Symbols") {
                        HStack(spacing: 20) {
                            ForEach(symbols, id: \.self) { symbol in
                                LightBlurGlyph(symbolName: symbol, size: 32)
                            }
                        }
                    }
                    
                    PreviewSection(title: "Size Variations") {
                        HStack(spacing: 20) {
                            LightBlurGlyph(symbolName: "star.fill", size: 20)
                            LightBlurGlyph(symbolName: "star.fill", size: 32)
                            LightBlurGlyph(symbolName: "star.fill", size: 48)
                            LightBlurGlyph(symbolName: "star.fill", size: 64)
                        }
                    }
                    
                    PreviewSection(title: "Custom Size (\(Int(selectedSize))pt)") {
                        Slider(value: $selectedSize, in: 16...80, step: 4)
                            .tint(.white)
                        HStack {
                            LightBlurGlyph(symbolName: "flame.fill", size: selectedSize)
                            Spacer()
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("LightBlurGlyph") {
    LightBlurGlyphPreview()
}

// MARK: - PageControl Preview

private struct PageControlPreview: View {
    @State private var currentPage3: Int = 0
    @State private var currentPage5: Int = 2
    @State private var currentPage10: Int = 5
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "PageControl") {
                    PreviewSection(title: "3 Pages (Page \(currentPage3 + 1))") {
                        VStack {
                            PageControl(currentPage: $currentPage3, numberOfPages: 3)
                            HStack {
                                Button("Previous") {
                                    if currentPage3 > 0 { currentPage3 -= 1 }
                                }
                                .foregroundColor(.white)
                                Spacer()
                                Button("Next") {
                                    if currentPage3 < 2 { currentPage3 += 1 }
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                    
                    PreviewSection(title: "5 Pages (Page \(currentPage5 + 1))") {
                        PageControl(currentPage: $currentPage5, numberOfPages: 5)
                    }
                    
                    PreviewSection(title: "10 Pages (Page \(currentPage10 + 1))") {
                        PageControl(currentPage: $currentPage10, numberOfPages: 10)
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("PageControl") {
    PageControlPreview()
}

// MARK: - ScalingPressButtonStyle Preview

private struct ScalingPressButtonStylePreview: View {
    @State private var tapCount: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "ScalingPressButtonStyle") {
                    PreviewSection(title: "Press and Hold to See Effect") {
                        VStack(spacing: 16) {
                            Button {
                                tapCount += 1
                            } label: {
                                Text("Tap Me (\(tapCount))")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(25)
                            }
                            .buttonStyle(ScalingPressButtonStyle())
                            
                            Button {
                                tapCount += 1
                            } label: {
                                HStack {
                                    Image(systemName: "heart.fill")
                                    Text("Like")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.pink)
                                .cornerRadius(25)
                            }
                            .buttonStyle(ScalingPressButtonStyle())
                            
                            Button {
                                tapCount += 1
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(ScalingPressButtonStyle())
                        }
                    }
                    
                    Text("Total taps: \(tapCount)")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.caption)
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("ScalingPressButtonStyle") {
    ScalingPressButtonStylePreview()
}

// MARK: - SearchField Preview

private struct SearchFieldPreview: View {
    @State private var searchText1: String = ""
    @State private var searchText2: String = "Running"
    @State private var searchText3: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "SearchField") {
                    PreviewSection(title: "Empty State") {
                        SearchField(text: $searchText1)
                            .placeholder("Search activities...")
                    }
                    
                    PreviewSection(title: "With Initial Text") {
                        SearchField(text: $searchText2)
                            .placeholder("Search...")
                    }
                    
                    PreviewSection(title: "Custom Placeholder") {
                        SearchField(text: $searchText3)
                            .placeholder("Find friends by username")
                    }
                    
                    Text("Current search: \(searchText1.isEmpty ? "(empty)" : searchText1)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("SearchField") {
    SearchFieldPreview()
}

// MARK: - SwiftUILoadingButton Preview

private struct SwiftUILoadingButtonPreview: View {
    @State private var isLoading1: Bool = false
    @State private var isLoading2: Bool = true
    @State private var isLoading3: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "SwiftUILoadingButton") {
                    PreviewSection(title: "Default State") {
                        SwiftUILoadingButton(
                            isLoading: isLoading1,
                            title: "Submit"
                        ) {
                            isLoading1 = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading1 = false
                            }
                        }
                    }
                    
                    PreviewSection(title: "Loading State") {
                        SwiftUILoadingButton(
                            isLoading: isLoading2,
                            title: "Processing..."
                        )
                    }
                    
                    PreviewSection(title: "Toggle Loading (Tap to Test)") {
                        SwiftUILoadingButton(
                            isLoading: isLoading3,
                            title: "Save Changes"
                        ) {
                            isLoading3 = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isLoading3 = false
                            }
                        }
                        
                        Button(isLoading3 ? "Cancel" : "Start Loading") {
                            isLoading3.toggle()
                        }
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("SwiftUILoadingButton") {
    SwiftUILoadingButtonPreview()
}

// MARK: - InlineReactionPicker Preview

private struct InlineReactionPickerPreview: View {
    @State private var heartFilled1: Bool = false
    @State private var showingReactions1: Bool = false
    @State private var heartFilled2: Bool = true
    @State private var showingReactions2: Bool = false
    @State private var heartFilled3: Bool = false
    @State private var showingReactions3: Bool = true
    @State private var lastReaction: String = "None"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "InlineReactionPicker") {
                    PreviewSection(title: "Unreacted State (Tap to React)") {
                        InlineReactionPicker(
                            heartFilled: $heartFilled1,
                            showingInlineReactions: $showingReactions1
                        ) { reaction in
                            lastReaction = reaction.emoji
                        }
                    }
                    
                    PreviewSection(title: "Already Reacted") {
                        InlineReactionPicker(
                            heartFilled: $heartFilled2,
                            showingInlineReactions: $showingReactions2
                        )
                    }
                    
                    PreviewSection(title: "Expanded State") {
                        InlineReactionPicker(
                            heartFilled: $heartFilled3,
                            showingInlineReactions: $showingReactions3
                        ) { reaction in
                            lastReaction = reaction.emoji
                        }
                        
                        Button("Toggle Expanded") {
                            showingReactions3.toggle()
                        }
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    }
                    
                    Text("Last reaction: \(lastReaction)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("InlineReactionPicker") {
    InlineReactionPickerPreview()
}

// MARK: - VariableBlurView Preview

private struct VariableBlurViewPreview: View {
    @State private var maxBlurRadius: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                PreviewContainer(title: "VariableBlurView") {
                    PreviewSection(title: "Blurred Top, Clear Bottom") {
                        ZStack {
                            VStack(spacing: 4) {
                                ForEach(0..<10, id: \.self) { _ in
                                    Text("Sample text content here")
                                        .foregroundColor(.white)
                                }
                            }
                            VariableBlurView(
                                maxBlurRadius: 20,
                                direction: .blurredTopClearBottom
                            )
                        }
                        .frame(height: 150)
                        .cornerRadius(12)
                    }
                    
                    PreviewSection(title: "Blurred Bottom, Clear Top") {
                        ZStack {
                            VStack(spacing: 4) {
                                ForEach(0..<10, id: \.self) { _ in
                                    Text("Sample text content here")
                                        .foregroundColor(.white)
                                }
                            }
                            VariableBlurView(
                                maxBlurRadius: 20,
                                direction: .blurredBottomClearTop
                            )
                        }
                        .frame(height: 150)
                        .cornerRadius(12)
                    }
                    
                    PreviewSection(title: "Adjustable Blur (\(Int(maxBlurRadius)))") {
                        Slider(value: $maxBlurRadius, in: 0...40, step: 2)
                            .tint(.white)
                        ZStack {
                            LinearGradient(
                                colors: [.purple, .blue, .cyan],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            VariableBlurView(
                                maxBlurRadius: maxBlurRadius,
                                direction: .blurredTopClearBottom
                            )
                        }
                        .frame(height: 100)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview("VariableBlurView") {
    VariableBlurViewPreview()
}

// MARK: - Combined Component Gallery

private struct ComponentGalleryPreview: View {
    @State private var segmentIdx: Int = 0
    @State private var searchText: String = ""
    @State private var accessCode: String = ""
    @FocusState private var isCodeFocused: Bool
    @State private var currentPage: Int = 1
    @State private var heartFilled: Bool = false
    @State private var showingReactions: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Component Gallery")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Interactive showcase of all atomic SwiftUI components")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.horizontal)
                
                // Components Grid
                VStack(spacing: 20) {
                    // Segmented Control
                    componentCard(title: "Segmented Control", icon: "rectangle.split.3x1") {
                        ADSegmentedControl(
                            segments: ["Day", "Week", "Month"],
                            selectedSegmentIdx: $segmentIdx
                        )
                    }
                    
                    // Search Field
                    componentCard(title: "Search Field", icon: "magnifyingglass") {
                        SearchField(text: $searchText)
                            .placeholder("Search...")
                    }
                    
                    // Access Code
                    componentCard(title: "Access Code", icon: "key") {
                        AccessCodeField(accessCode: $accessCode, isFocused: $isCodeFocused)
                    }
                    
                    // Page Control
                    componentCard(title: "Page Control", icon: "circle.grid.2x1") {
                        VStack {
                            PageControl(currentPage: $currentPage, numberOfPages: 5)
                            Text("Page \(currentPage + 1) of 5")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    
                    // Buttons
                    componentCard(title: "Buttons", icon: "hand.tap") {
                        VStack(spacing: 12) {
                            ADWhiteButton(title: "Primary Action")
                            
                            Button {
                            } label: {
                                RoundedWhiteButtonLabel(text: "Secondary")
                                    .frame(height: 36)
                            }
                            .buttonStyle(ScalingPressButtonStyle())
                        }
                    }
                    
                    // Loading Button
                    componentCard(title: "Loading Button", icon: "arrow.clockwise") {
                        VStack(spacing: 8) {
                            SwiftUILoadingButton(
                                isLoading: isLoading,
                                title: "Submit"
                            ) {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isLoading = false
                                }
                            }
                            
                            Button(isLoading ? "Loading..." : "Tap button above") {
                                isLoading.toggle()
                            }
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    
                    // Reaction Picker
                    componentCard(title: "Reaction Picker", icon: "heart") {
                        InlineReactionPicker(
                            heartFilled: $heartFilled,
                            showingInlineReactions: $showingReactions
                        )
                    }
                    
                    // Glyphs
                    componentCard(title: "Light Blur Glyphs", icon: "sparkles") {
                        HStack(spacing: 16) {
                            LightBlurGlyph(symbolName: "heart.fill", size: 32)
                            LightBlurGlyph(symbolName: "star.fill", size: 32)
                            LightBlurGlyph(symbolName: "bolt.fill", size: 32)
                            LightBlurGlyph(symbolName: "flame.fill", size: 32)
                        }
                    }
                    
                    // Empty State
                    componentCard(title: "Empty State", icon: "tray") {
                        AndiEmptyState(
                            text: "Nothing to show here yet",
                            type: .shoes
                        )
                        .scaleEffect(0.8)
                    }
                    
                    // Blur Views
                    componentCard(title: "Blur Effects", icon: "drop.fill") {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 40, height: 40)
                                DarkBlurView()
                                    .frame(width: 80, height: 50)
                                    .cornerRadius(8)
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                LightBlurView()
                                    .frame(width: 80, height: 50)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.black)
    }
    
    private func componentCard<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

#Preview("Component Gallery") {
    ComponentGalleryPreview()
}
