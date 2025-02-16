//
//  DocumentPicker.swift
//  Bythen
//
//  Created by Darindra R on 25/09/24.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentationMode

    var didFinishPicking: (Attachment) -> Void?
    var didFailedValidation: () -> Void?

    var maxFileSize: Double = 20

    init(
        didFinishPicking: @escaping (Attachment) -> Void,
        didFailedValidation: @escaping () -> Void?
    ) {
        self.didFinishPicking = didFinishPicking
        self.didFailedValidation = didFailedValidation
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<DocumentPicker>
    ) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _: DocumentPicker.UIViewControllerType,
        context _: UIViewControllerRepresentableContext<DocumentPicker>
    ) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var context: DocumentPicker

        init(_ context: DocumentPicker) {
            self.context = context
        }

        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let doc = urls.first, doc.startAccessingSecurityScopedResource() {
                defer {
                    DispatchQueue.main.async {
                        doc.stopAccessingSecurityScopedResource()
                    }
                }

                guard isFileSizeValid(fileURL: doc)
                else {
                    context.didFailedValidation()
                    context.presentationMode.wrappedValue.dismiss()
                    return
                }

                let attachment = handleFileSelection(fileURL: doc)
                context.didFinishPicking(attachment)
                context.presentationMode.wrappedValue.dismiss()
            }
        }

        private func handleFileSelection(fileURL: URL) -> Attachment {
            let fileData = try? Data(contentsOf: fileURL)
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(fileURL.pathExtension.lowercased())

            do {
                if let fileData {
                    try fileData.write(to: destinationURL)
                }
            } catch {
                print("Error saving file: \(error.localizedDescription)")
            }

            let type: Attachment.FileType =
                switch fileURL.pathExtension.lowercased() {
                case "jpeg",
                     "jpg",
                     "png":

                    .image(UIImage(data: fileData ?? Data()))
                case "pdf":
                    .pdf
                case "csv":
                    .excel
                case "xlsv":
                    .excel
                case "ppt",
                     "pptx":
                    .ppt
                default:
                    .doc
                }

            return Attachment(
                type: type,
                fileName: destinationURL.lastPathComponent,
                fileURL: destinationURL
            )
        }

        private func isFileSizeValid(fileURL: URL) -> Bool {
            do {
                let resources = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                guard let fileSize = resources.fileSize else { return false }

                return fileSize.toMegaBytes() <= context.maxFileSize
            } catch {
                return false
            }
        }
    }
}
