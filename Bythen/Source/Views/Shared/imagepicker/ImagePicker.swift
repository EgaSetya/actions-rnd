//
//  ImagePicker.swift
//  Bythen
//
//  Created by Darindra R on 25/09/24.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentationMode

    var didFinishPicking: (Attachment) -> Void
    var didFailedValidation: () -> Void?
    var didCancel: () -> Void

    var maxFileSize: Double = 10

    init(
        didFinishPicking: @escaping (Attachment) -> Void,
        didFailedValidation: @escaping () -> Void?,
        didCancel: @escaping () -> Void = {}
    ) {
        self.didFinishPicking = didFinishPicking
        self.didFailedValidation = didFailedValidation
        self.didCancel = didCancel
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: PHPickerViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let firstResult = results.first else {
                self.parent.didCancel()
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            let provider = firstResult.itemProvider
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
                    guard let self else { return }
                    self.handlePickedData(data: data, error: error, type: "image/jpeg")
                }
            }
        }

        private func handlePickedData(data: Data?, error: Error?, type _: String) {
            DispatchQueue.main.async {
                if let error = error {
                    print("Error picking file: \(error)")
                    self.parent.presentationMode.wrappedValue.dismiss()
                    return
                }

                if let fileData = data {
                    if fileData.count.toMegaBytes() > self.parent.maxFileSize {
                        self.parent.didFailedValidation()
                        self.parent.presentationMode.wrappedValue.dismiss()
                    } else {
                        let fileManager = FileManager.default
                        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let destinationURL = documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")

                        do {
                            try fileData.write(to: destinationURL)

                            let image = UIImage(data: fileData)
                            let attachment = Attachment(
                                type: .image(image),
                                fileName: destinationURL.lastPathComponent,
                                fileURL: destinationURL
                            )

                            self.parent.didFinishPicking(attachment)
                            self.parent.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error saving file: \(error.localizedDescription)")
                            self.parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}
