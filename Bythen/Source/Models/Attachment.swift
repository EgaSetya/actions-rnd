//
//  Attachment.swift
//  Bythen
//
//  Created by Darindra R on 30/09/24.
//

import SwiftUI

struct Attachment: Equatable {
    let type: FileType
    let fileName: String
    let fileURL: URL

    enum FileType: Equatable {
        case image(_ image: UIImage?)
        case pdf
        case ppt
        case excel
        case doc

        var rawValue: String {
            switch self {
            case .image:
                return "IMAGE"
            case .pdf:
                return "PDF"
            case .ppt:
                return "Presentation"
            case .excel:
                return "Spreadsheet"
            case .doc:
                return "Document"
            }
        }

        var icon: String {
            switch self {
            case .image:
                return "image"
            case .doc,
                 .pdf:
                return AppImages.kPdfIcon
            case .ppt:
                return AppImages.kPptIcon
            case .excel:
                return AppImages.kExcelIcon
            }
        }
    }
}

struct UploadFileResponse: Codable {
    let fileURL: String

    enum CodingKeys: String, CodingKey {
        case fileURL = "file_url"
    }
}
