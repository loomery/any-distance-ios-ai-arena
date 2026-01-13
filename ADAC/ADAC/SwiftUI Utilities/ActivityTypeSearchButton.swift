// Licensed under the Any Distance Source-Available License
//
//  ActivityTypeSearchButton.swift
//  ADAC
//
//  Created by Daniel Kuntz on 7/4/23.
//

import SwiftUI

struct ActivityTypeSearchButton: View {
    @Binding var activityType: ActivityType
    @State private var showingActivityList: Bool = false

    var body: some View {
        Button {
            showingActivityList = true
        } label: {
            HStack(spacing: 5.0) {
                Image(activityType.glyphName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28.0, height: 28.0)
                Text(activityType.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .lineBreakMode(.byWordWrapping)
                Spacer()
                Image(systemName: .magnifyingglass)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                    .fontWeight(.medium)
            }
            .padding([.top, .bottom], 10.0)
            .padding([.leading, .trailing], 18.0)
            .foregroundColor(.white)
            .background {
                DarkBlurView()
                    .brightness(0.1)
                    .cornerRadius(24.0, style: .continuous)
            }
        }
        .id(activityType.displayName)
        .modifier(BlurOpacityTransition(speed: 1.8))
        .sheet(isPresented: $showingActivityList) {
            RecordingActivityPickerView { activityType in
                self.activityType = activityType
                showingActivityList = false
            }
        }
    }
}

#if DEBUG
private struct ActivityTypeSearchButtonPreviewGallery: View {
    @State private var selectedType: ActivityType = .run

    var body: some View {
        VStack(spacing: 24) {
            ActivityTypeSearchButton(activityType: $selectedType)
                .padding()
                .background(
                    Color.black
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                )

            Menu {
                Picker("Activity", selection: $selectedType) {
                    ForEach(ActivityType.allCases.prefix(12), id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
            } label: {
                Label("Change Activity (\(selectedType.displayName))", systemImage: "list.bullet")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Text("Tap the button to see the sheet transition and use the menu to explore other glyphs.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(Color(.systemGray6))
    }
}

#Preview("Activity Type Search") {
    ActivityTypeSearchButtonPreviewGallery()
}
#endif
