// Licensed under the Any Distance Source-Available License
//
//  TableViewCell.swift
//  ADAC
//
//  Created by Daniel Kuntz on 6/29/22.
//

import SwiftUI

enum TableViewCellType {
    case top
    case bottom
    case middle
    case floating
}

struct TableViewCell: View {
    var text: String?
    var font: Font?
    var textColor: Color?
    var image: Image?
    var accessoryImage: Image?
    var imageSize: CGSize?
    var accessoryTint: Color?
    var imageOffset: CGSize?
    var accessory: AnyView?
    var type: TableViewCellType
    var onTap: (() -> Void)?

    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    @State private var pressed: Bool = false

    func roundedCorners() -> UIRectCorner {
        switch type {
        case .top:
            return [.topLeft, .topRight]
        case .bottom:
            return [.bottomLeft, .bottomRight]
        case .middle:
            return []
        case .floating:
            return .allCorners
        }
    }

    func shouldAddSeparator() -> Bool {
        switch type {
        case .top, .middle:
            return true
        default:
            return false
        }
    }

    var body: some View {
        let stack = VStack(alignment: .leading, spacing: 0) {
            if shouldAddSeparator() {
                Spacer()
            }

            ZStack {
                HStack {
                    if let text = text {
                        Text(text)
                            .font(font ?? .system(size: 17))
                            .foregroundColor(textColor ?? .white)
                    }
                    if let image = image {
                        image.offset(x: 0.0, y: -1.0)
                    }
                    Spacer()
                }

                HStack {
                    Spacer()
                    if let accessory = accessory {
                        accessory
                    } else if let image = accessoryImage {
                        if let size = imageSize {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                                .offset(imageOffset ?? .zero)
                                .foregroundColor(accessoryTint ?? .white)
                        } else {
                            image
                                .offset(imageOffset ?? .zero)
                                .foregroundColor(accessoryTint ?? .white)
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 15)

            if shouldAddSeparator() {
                Spacer()
                Spacer()
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)
                    .background(Color(white: 0.25))
            }
        }
        .frame(height: 51)
        .background(Color(white: pressed ? 0.25 : 0.125))
        .cornerRadius(12, corners: roundedCorners())

        if accessory == nil || onTap != nil {
            stack.overlay(
                TappableView(onTap: {
                    feedbackGenerator.impactOccurred()
                    onTap?()
                }, onPress: onPress, pressDuration: 0.1)
            )
        } else {
            stack
        }
    }

    private func onPress(isPressed: Bool) {
        withAnimation(Animation.easeInOut.speed(8)) {
            self.pressed = isPressed
        }
    }
}

struct SectionHeaderText: View {
    var text: String

    var body: some View {
        HStack(spacing: 0) {
            Text(text)
                .font(.greedMedium(size: 18.0))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
            Spacer(minLength: 0)
                .frame(height: 12)
        }
        .padding(.leading, 5)
    }
}

#if DEBUG
private struct TableViewCellPreviewGallery: View {
    @State private var selectedType: TableViewCellType = .top
    @State private var notificationsEnabled: Bool = true
    @State private var headerText: String = "Settings"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderText(text: headerText)
                .padding(.horizontal)

            VStack(spacing: 0) {
                TableViewCell(text: "Notifications",
                              image: Image(systemName: "bell.fill"),
                              accessoryImage: Image(systemName: "chevron.right"),
                              imageSize: CGSize(width: 18, height: 18),
                              accessoryTint: .white.opacity(0.6),
                              type: selectedType,
                              onTap: {})
                TableViewCell(text: "Auto Upload",
                              font: .system(size: 16, weight: .medium),
                              accessory: AnyView(
                                Toggle("", isOn: $notificationsEnabled)
                                    .labelsHidden()
                                    .tint(.orange)
                              ),
                              type: .middle,
                              onTap: nil)
                TableViewCell(text: "Floating Example",
                              textColor: .orange,
                              accessoryImage: Image(systemName: "lock.fill"),
                              accessoryTint: .orange,
                              type: .floating,
                              onTap: {})
            }
            .padding()
            .background(Color(.systemGray4))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Picker("Cell Corner Style", selection: $selectedType) {
                Text("Top").tag(TableViewCellType.top)
                Text("Middle").tag(TableViewCellType.middle)
                Text("Bottom").tag(TableViewCellType.bottom)
                Text("Floating").tag(TableViewCellType.floating)
            }
            .pickerStyle(.segmented)

            TextField("Header Text", text: $headerText)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview("Table View Cell States") {
    TableViewCellPreviewGallery()
        .preferredColorScheme(.dark)
}
#endif
