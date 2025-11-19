// Licensed under the Any Distance Source-Available License
//
//  SwiftUIUtilitiesPreviewSupport.swift
//  ADAC
//
//  Created by OpenAI Codex on 3/17/24.
//

import SwiftUI
import UIKit

enum SwiftUIUtilitiesPreviewSupport {
    private static var didSeedUsers: Bool = false

    static func seedUserCacheIfNeeded() {
        guard !didSeedUsers else { return }

        let sampleFriends = [
            makeUser(id: "friend-1", name: "Avery Trail", username: "avery"),
            makeUser(id: "friend-2", name: "Max Climb", username: "max"),
            makeUser(id: "friend-3", name: "Riley River", username: "riley")
        ]

        let currentUser = makeUser(id: "preview-owner",
                                   name: "Andi Preview",
                                   username: "andi")
        currentUser.friendIDs = sampleFriends.map(\.id)
        ADUser.current = currentUser

        sampleFriends.forEach { UserCache.shared.cache(user: $0) }
        didSeedUsers = true
    }

    static func makeLocalImageURL(symbolName: String = "figure.run",
                                  size: CGSize = CGSize(width: 280, height: 280),
                                  background: UIColor = .systemOrange) -> URL {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            background.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            if let symbol = UIImage(systemName: symbolName) {
                let symbolRect = CGRect(origin: .zero, size: size).insetBy(dx: 30, dy: 30)
                UIColor.white.setFill()
                symbol.withTintColor(.white, renderingMode: .alwaysOriginal)
                    .draw(in: symbolRect)
            }
        }

        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appending(path: "swiftui-utilities-preview-\(UUID().uuidString).png")
        try? image.pngData()?.write(to: fileURL)
        return fileURL
    }

    private static func makeUser(id: String, name: String, username: String) -> ADUser {
        let user = ADUser()
        user.id = id
        user.name = name
        user.username = username
        user.profilePhotoUrl = URL(string: "https://example.com/\(username).jpg")
        return user
    }
}
