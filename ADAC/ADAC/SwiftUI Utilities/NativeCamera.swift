// Licensed under the Any Distance Source-Available License
//
//  NativeCamera.swift
//  ADAC
//
//  Created by Daniel Kuntz on 5/30/23.
//

import SwiftUI
import Photos

struct NativeCamera: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<NativeCamera>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<NativeCamera>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: NativeCamera

        init(_ parent: NativeCamera) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    @State var selectedImage: UIImage?

    return VStack(spacing: 20) {
        Text("Native Camera")
            .font(.title2)
            .foregroundColor(.white)

        if let image = selectedImage {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .cornerRadius(12)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 300)
                .overlay(
                    VStack(spacing: 10) {
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text("Camera Placeholder")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
        }

        Text("NativeCamera opens the device camera or photo library")
            .font(.caption)
            .foregroundColor(.gray)
            .padding()

        Spacer()
    }
    .padding()
    .background(Color.black)
}
